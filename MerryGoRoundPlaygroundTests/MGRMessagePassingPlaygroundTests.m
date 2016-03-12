//
//  MGRMessagePassingPlaygroundTests.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 07.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DynamicMethodObject.h"
#import "ForwardingObject.h"
#import "NSString+StringIdentifier.h"
#import "NSString+SwizzleDescription.h"

@interface MGRMessagePassingPlaygroundTests : XCTestCase

@end

@implementation MGRMessagePassingPlaygroundTests

- (void)testDynamicMethodImplementation {
    DynamicMethodObject *obj = [[DynamicMethodObject alloc] init];

    [obj callHelloWorld];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

    [obj performSelector:@selector(callDoStuff) withObject:nil];

    [[DynamicMethodObject class] performSelector:@selector(callAnything)];

#pragma clang diagnostic pop
}

- (void)testForwarding {
    ForwardingObject *obj = [[ForwardingObject alloc] init];

    [obj callHelloWorld];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

    [obj performSelector:@selector(callDoStuff) withObject:nil];

    [[DynamicMethodObject class] performSelector:@selector(callAnything)];
    
#pragma clang diagnostic pop
}

- (void)testCategoryProperty {
    NSString *aString = @"Hello, world";
    aString.mgr_stringIdentifier = [[NSUUID UUID] UUIDString];

    NSLog(@"String «%@» identifier is %@", aString, aString.mgr_stringIdentifier);
}

- (void)testSwizzling {
    NSLog(@"%@", @"Hello, world");
}

@end
