//
//  MGRBlocksPlaygroundTests.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 06.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EXTScope.h"

@interface ObjectWithStrongBlockReference : NSObject
@property (nonatomic, strong) void (^block)(void);
@end
@implementation ObjectWithStrongBlockReference
@end

@interface MGRBlocksPlaygroundTests : XCTestCase

@end

@implementation MGRBlocksPlaygroundTests

- (void)testBlockCaptureScalar {
    // А если добавить __block?
    int anInteger = 23;

    void (^testBlock)(void) = ^{
        NSLog(@"Integer is: %i", anInteger);
    };

    anInteger++;

    testBlock();
}

- (void)testBlockCaptureMutableObject {
    NSMutableArray *anArray = [@[ @"23" ] mutableCopy];

    void (^testBlock)(void) = ^{
        NSLog(@"Array is: %@", anArray);
    };

    [anArray addObject:@"24"];

    testBlock();
}

- (void)testVoidArgumentsBlock {
    int anInteger = 23;

    void (^testBlock)() = ^{
        NSLog(@"Integer is: %i", anInteger);
    };

    testBlock(123, 456, @"Hello");
}

- (void)testBlockAutorelease {
    // Что будет, если здесь добавить __weak?
    void (^testBlockOutsideAutoreleasePool)(void);
    __weak NSString *aStringOutsideAutoreleasePool;

    @autoreleasepool {
        // Попробуйте поменять строку на более короткую
        NSString *aString = [NSString stringWithFormat:@"The Number %i", 23];

        void (^testBlock)(void) = [self createBlockWithString:aString];

        aStringOutsideAutoreleasePool = aString;
        testBlockOutsideAutoreleasePool = testBlock;
    }

    NSLog(@"%@", aStringOutsideAutoreleasePool);

    testBlockOutsideAutoreleasePool();
}

- (void (^)(void))createBlockWithString:(NSString *)aString {

    // Что будет, если здесь добавить __weak?
    NSString *theString = aString;

    return ^{
        NSLog(@"String is: %@", theString);
    };
}

- (void)testObjectLikeBlock {
    NSDictionary *obj1 = [self createObjectLikeBlock];

    void (^print)() = obj1[@"print"];
    void (^increment)() = obj1[@"increment"];
    void (^setString)(NSString *) = obj1[@"setString"];
    print();
    increment();
    print();
    setString(@"newString");
    print();

    NSDictionary *obj2 = [self createObjectLikeBlock];
    print = obj2[@"print"];
    print();
}

- (NSDictionary<NSString *, id> *)createObjectLikeBlock {
    __block NSInteger anInteger = 23;
    __block NSString *aString = @"Hello, world!";

    return @{
             @"print" : ^{
                 NSLog(@"Integer is: %li, String is: %@", (long)anInteger, aString);
             },
             @"increment" : ^{
                 anInteger++;
             },
             @"setString" : ^void(NSString *newString) {
                 aString = newString;
             }};
}

- (void)testStrongReferenceCycle {
    __weak ObjectWithStrongBlockReference *objectOutsideAutoreleasePool;

    @autoreleasepool {
        ObjectWithStrongBlockReference *obj = [[ObjectWithStrongBlockReference alloc] init];

        void (^block)(void) = ^{
            NSLog(@"%@", obj.block);
        };

        obj.block = block;

        objectOutsideAutoreleasePool = obj;
    }

    // Что произойдет? Как этого избежать?
    NSLog(@"%@", objectOutsideAutoreleasePool);
}

@end
