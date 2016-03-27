//
//  MGRDropboxParser.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 28.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRDropboxParser.h"
#import "MGRFileMetadata.h"
#import "MGRFolderMetadata.h"

NSString *const MGRDropboxParserErrorDomain = @"MGRDropboxParserErrorDomain";

@implementation MGRDropboxParser

- (NSArray<MGRMetadata *> *)nodesFromJSONObject:(id)JSONObject error:(NSError *__autoreleasing  _Nullable *)error {
    if (![JSONObject isKindOfClass:[NSDictionary class]]) {
        if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
        return nil;
    }

    NSDictionary *root = JSONObject;
    id entriesObject = root[@"entries"];
    if (![entriesObject isKindOfClass:[NSArray class]]) {
        if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
        return nil;
    }
    NSArray *entries = entriesObject;

    return [MTLJSONAdapter modelsOfClass:[MGRMetadata class] fromJSONArray:entries error:error];
}

- (MGRMetadata *)nodeFromJSONObject:(id)JSONObject error:(NSError *__autoreleasing  _Nullable *)error {
    if (![JSONObject isKindOfClass:[NSDictionary class]]) {
        if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
        return nil;
    }

    return [MTLJSONAdapter modelOfClass:[MGRMetadata class] fromJSONDictionary:JSONObject error:error];
}

@end
