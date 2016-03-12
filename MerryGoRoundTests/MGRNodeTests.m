//
//  MGRNodeTests.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MGRFile.h"
#import "MGRFolder.h"

@interface MGRNodeTests : XCTestCase

@end

@implementation MGRNodeTests

- (void)testThrowsOnInvalidParameters {
    NSDate *clientModified = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    MGRFile *validFile = [[MGRFile alloc] initWithDropboxID:@"id1" name:@"a" path:@"/a" clientModified:clientModified size:23];
    XCTAssertNotNil(validFile);

    NSDate *invalidClientModified = nil;
    XCTAssertThrows([[MGRFile alloc] initWithDropboxID:@"id" name:@"name" path:@"/name" clientModified:invalidClientModified size:0]);
}

- (void)testFileDescription {
    NSDate *clientModified = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    MGRFile *file = [[MGRFile alloc] initWithDropboxID:@"id" name:@"name" path:@"/name" clientModified:clientModified size:23];
    XCTAssertNotNil([file description]);
//    NSLog(@"%@", file);
}

- (void)testFolderDescription {
    NSDate *clientModified = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    MGRFile *file = [[MGRFile alloc] initWithDropboxID:@"id" name:@"name" path:@"/name" clientModified:clientModified size:23];
    MGRFolder *folder = [[MGRFolder alloc] initWithDropboxID:@"id" name:@"name" path:@"/name" childNodes:@[ file ]];
    XCTAssertNotNil([folder description]);
//    NSLog(@"%@", folder);
}

- (void)testFileHash {
    NSDate *clientModified = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    MGRFile *a = [[MGRFile alloc] initWithDropboxID:@"id1" name:@"a" path:@"/a" clientModified:clientModified size:23];
    MGRFile *b = [[MGRFile alloc] initWithDropboxID:@"id1" name:@"a" path:@"/a" clientModified:clientModified size:23];
    MGRFile *c = [[MGRFile alloc] initWithDropboxID:@"id2" name:@"c" path:@"/c" clientModified:clientModified size:23];

    XCTAssertEqual(a.hash, b.hash);
    XCTAssertNotEqual(a.hash, c.hash);
}

- (void)testFileEquality {
    NSDate *clientModified = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    MGRFile *a = [[MGRFile alloc] initWithDropboxID:@"id1" name:@"a" path:@"/a" clientModified:clientModified size:23];
    MGRFile *b = [[MGRFile alloc] initWithDropboxID:@"id1" name:@"a" path:@"/a" clientModified:clientModified size:23];
    MGRFile *c = [[MGRFile alloc] initWithDropboxID:@"id2" name:@"c" path:@"/c" clientModified:clientModified size:23];

    XCTAssertEqualObjects(a, b);
    XCTAssertNotEqualObjects(a, c);
}

@end
