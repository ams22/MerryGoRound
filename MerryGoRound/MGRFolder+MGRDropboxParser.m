//
//  MGRFolder+MGRDropboxParser.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 28.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRFolder+MGRDropboxParser.h"

@implementation MGRFolder (MGRDropboxParser)

- (instancetype)initWithJSONObject:(id)JSONObject
                        childNodes:(NSArray<id<MGRNode>> *)childNodes
                             error:(NSError *__autoreleasing  _Nullable *)error {
    if (![JSONObject isKindOfClass:[NSDictionary class]]) {
        if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
        return nil;
    }
    NSDictionary *entry = JSONObject;

    id tagObject = entry[@".tag"];
    if (![tagObject isKindOfClass:[NSString class]]) {
        if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
        return nil;
    }
    NSString *tag = tagObject;

    if (![tag isEqualToString:@"folder"]) {
        if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
        return nil;
    }

    id dropboxIDObject = entry[@"id"];
    if (![dropboxIDObject isKindOfClass:[NSString class]]) {
        if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
        return nil;
    }

    id nameObject = entry[@"name"];
    if (![nameObject isKindOfClass:[NSString class]]) {
        if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
        return nil;
    }

    id pathObject = entry[@"path_lower"];
    if (![pathObject isKindOfClass:[NSString class]]) {
        if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
        return nil;
    }

    return [self initWithDropboxID:dropboxIDObject
                              name:nameObject
                              path:pathObject
                        childNodes:childNodes];
}

@end
