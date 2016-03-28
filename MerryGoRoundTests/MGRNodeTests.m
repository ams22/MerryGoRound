//
//  MGRNodeTests.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MGRFileMetadata.h"
#import "MGRFolderMetadata.h"

@interface MGRNodeTests : XCTestCase

@end

@implementation MGRNodeTests

- (void)testFileDescription {
    NSDate *clientModified = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    MGRFileMetadata *file = [[MGRFileMetadata alloc] init];
    [file setValue:@"id" forKey:@"identifier"];
    [file setValue:@"name" forKey:@"name"];
    [file setValue:@"/name" forKey:@"path"];
    [file setValue:clientModified forKey:@"clientModified"];
    [file setValue:@23 forKey:@"size"];
    XCTAssertNotNil([file description]);
//    NSLog(@"%@", file);
}

- (void)testFolderDescription {
    MGRFolderMetadata *folder = [[MGRFolderMetadata alloc] init];
    [folder setValue:@"id" forKey:@"identifier"];
    [folder setValue:@"name" forKey:@"name"];
    [folder setValue:@"/name" forKey:@"path"];

    XCTAssertNotNil([folder description]);
//    NSLog(@"%@", folder);
}

- (void)testFileHash {
    NSDate *clientModified = [NSDate dateWithTimeIntervalSinceReferenceDate:0];

    MGRFileMetadata *a = [[MGRFileMetadata alloc] init];
    [a setValue:@"id1" forKey:@"identifier"];
    [a setValue:@"a" forKey:@"name"];
    [a setValue:@"/a" forKey:@"path"];
    [a setValue:clientModified forKey:@"clientModified"];
    [a setValue:@23 forKey:@"size"];

    MGRFileMetadata *b = [[MGRFileMetadata alloc] init];
    [b setValue:@"id1" forKey:@"identifier"];
    [b setValue:@"a" forKey:@"name"];
    [b setValue:@"/a" forKey:@"path"];
    [b setValue:clientModified forKey:@"clientModified"];
    [b setValue:@23 forKey:@"size"];

    MGRFileMetadata *c = [[MGRFileMetadata alloc] init];
    [c setValue:@"id2" forKey:@"identifier"];
    [c setValue:@"c" forKey:@"name"];
    [c setValue:@"/c" forKey:@"path"];
    [c setValue:clientModified forKey:@"clientModified"];
    [c setValue:@23 forKey:@"size"];

    XCTAssertEqual(a.hash, b.hash);
    XCTAssertNotEqual(a.hash, c.hash);
}

- (void)testFileEquality {
    NSDate *clientModified = [NSDate dateWithTimeIntervalSinceReferenceDate:0];

    MGRFileMetadata *a = [[MGRFileMetadata alloc] init];
    [a setValue:@"id1" forKey:@"identifier"];
    [a setValue:@"a" forKey:@"name"];
    [a setValue:@"/a" forKey:@"path"];
    [a setValue:clientModified forKey:@"clientModified"];
    [a setValue:@23 forKey:@"size"];

    MGRFileMetadata *b = [[MGRFileMetadata alloc] init];
    [b setValue:@"id1" forKey:@"identifier"];
    [b setValue:@"a" forKey:@"name"];
    [b setValue:@"/a" forKey:@"path"];
    [b setValue:clientModified forKey:@"clientModified"];
    [b setValue:@23 forKey:@"size"];

    MGRFileMetadata *c = [[MGRFileMetadata alloc] init];
    [c setValue:@"id2" forKey:@"identifier"];
    [c setValue:@"c" forKey:@"name"];
    [c setValue:@"/c" forKey:@"path"];
    [c setValue:clientModified forKey:@"clientModified"];
    [c setValue:@23 forKey:@"size"];

    XCTAssertEqualObjects(a, b);
    XCTAssertNotEqualObjects(a, c);
}

@end
