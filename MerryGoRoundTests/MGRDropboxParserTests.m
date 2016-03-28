//
//  MGRDropboxParserTests.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 28.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MGRDropboxParser.h"

@interface MGRDropboxParserTests : XCTestCase
@property (nonatomic, strong) MGRDropboxParser *parser;
@end

@implementation MGRDropboxParserTests

- (void)setUp {
    [super setUp];
    self.parser = [[MGRDropboxParser alloc] init];
}

- (void)testParse {
    id JSONObject = [self listFolderJSONObject];
    NSError *error;
    NSArray<MGRMetadata *> *nodes = [self.parser nodesFromJSONObject:JSONObject error:&error];
    XCTAssertNotNil(nodes, @"%@", error);

//    NSLog(@"%@", nodes);
}

- (id)listFolderJSONObject {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *URL = [bundle URLForResource:@"list_folder.json" withExtension:nil];
    NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    return object;
}

@end
