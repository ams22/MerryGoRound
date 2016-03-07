//
//  MGRMemoryPlaygroundTests.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 06.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BinarySearchFinder.h"

@interface NSString (MGRMemoryPlaygroundTests)
@end
@implementation NSString (MGRMemoryPlaygroundTests)

- (NSUInteger)lineIndexContainingSubstring:(NSString *)substring lineString:(NSString **)stringOut {
    __block NSUInteger index = NSNotFound;
    __block NSUInteger lineIndex = 0;
    [self enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
        if ([line containsString:substring]) {
            index = lineIndex;
            *stringOut = line;
            *stop = YES;
        }
        lineIndex++;
    }];
    return index;
}

@end

@class ClassB;

@interface ClassA : NSObject
@property (nonatomic, strong) ClassB *objectB;
@end
@implementation ClassA
@end

@interface ClassB : NSObject
@property (nonatomic, strong) ClassA *objectA;
@end
@implementation ClassB
@end

@interface TimerTarget : NSObject
@end
@implementation TimerTarget

- (void)fireTimer:(NSTimer *)timer {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, timer);
}

@end

@interface MGRMemoryPlaygroundTests : XCTestCase

@end

@implementation MGRMemoryPlaygroundTests

- (void)testRetainCycle {
    __weak ClassA *objectAOutsideAutoreleasePool;
    __weak ClassB *objectBOutsideAutoreleasePool;

    @autoreleasepool {
        ClassA *objectA = [[ClassA alloc] init];
        ClassB *objectB = [[ClassB alloc] init];

        objectA.objectB = objectB;
        objectB.objectA = objectA;

        objectAOutsideAutoreleasePool = objectA;
        objectBOutsideAutoreleasePool = objectB;
    }

    NSLog(@"%@ %@", objectAOutsideAutoreleasePool, objectBOutsideAutoreleasePool);
}

- (void)testMemoryLeak {
    __weak TimerTarget *targetOusideAutoreleasePool;

    @autoreleasepool {
        TimerTarget *target = [[TimerTarget alloc] init];
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:target
                                       selector:@selector(fireTimer:)
                                       userInfo:nil
                                        repeats:YES];

        targetOusideAutoreleasePool = target;
    }

    NSLog(@"target = %@", targetOusideAutoreleasePool);

    id expectation = [self expectationWithDescription:@"Wait 5 seconds"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testDanglingPointer {
    NSString *multilineString = [self listFolderJSONString];
    NSString *lineString = nil;
    NSUInteger index = [multilineString lineIndexContainingSubstring:@"Dropbox" lineString:&lineString];
    NSLog(@"Substring found in line number %lu (%@)", (unsigned long)index, lineString);
}


- (NSString *)listFolderJSONString {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *URL = [bundle URLForResource:@"list_folder.json" withExtension:nil];
    NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)testAccidentalMemoryUsage {
    NSMutableArray *imageData = [NSMutableArray array];

    for (NSInteger idx = 0; idx < 10; idx++) {
        UIImage *image = [UIImage imageNamed:@"large-picture.jpg" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
        NSLog(@"%@", image);

        NSData *data = CFBridgingRelease(CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage)));
        [imageData addObject:data];
        NSLog(@"%p %lu", data, (unsigned long)data.length);

        usleep(1000000);
    }
}

- (void)testAccidentalMemoryUsage2 {
    for (NSInteger idx = 0; idx < 100; idx++) {
//        NSString *string = [[NSString alloc] initWithFormat:@"asldjalsjdlasd %li", (long)idx];
        NSString *string = [NSString stringWithFormat:@"asldjalsjdlasd %li", (long)idx];
        NSLog(@"%@", string);
    }
}

- (void)testException {
    __weak NSString *aString;

    @try {
        NSString *theString = [[NSString alloc] initWithFormat:@"The Number is %i", 23];
        aString = theString;
        @throw [NSException exceptionWithName:@"Name" reason:@"Reason" userInfo:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"caught %@", exception);
    }
    @finally {
        NSLog(@"finally");
    }

    NSLog(@"%@", aString);
}

- (void)testBinarySearchFinder {
    NSComparator comparator = ^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        return [obj1 localizedCompare:obj2];
    };

    NSString *multilineString = [self listFolderJSONString];
    NSArray<NSString *> *strings = [multilineString componentsSeparatedByString:@"\n"];
    strings = [strings sortedArrayUsingComparator:comparator];

    BinarySearchFinder *finder = [[BinarySearchFinder alloc] initWithComparator:comparator];
    NSInteger index = [finder indexOfObject:@"      \"client_modified\": \"2016-02-27T19:12:07Z\"," inArray:strings];

    NSLog(@"Index = %li, object = %@", (long)index, strings[index]);
}

- (void)testBridging {
    CGSize size = CGSizeMake(100, 100);
    UIGraphicsBeginImageContext(size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();

    CGFloat locations[2] = {0, 1};
    NSArray *colors = @[ (id)[UIColor darkGrayColor].CGColor,
                         (id)[UIColor lightGrayColor].CGColor ];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);

    CGColorSpaceRelease(colorSpace);  // Release owned Core Foundation object.

    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(size.width, size.height);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint,
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);

    CGGradientRelease(gradient);  // Release owned Core Foundation object.

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    NSLog(@"%@", image);
}

@end
