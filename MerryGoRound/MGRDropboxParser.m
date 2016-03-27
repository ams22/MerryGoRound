//
//  MGRDropboxParser.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 28.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRDropboxParser.h"
#import "MGRFile+MGRDropboxParser.h"
#import "MGRPhoto+MGRDropboxParser.h"
#import "MGRFolder+MGRDropboxParser.h"

NSString *const MGRDropboxParserErrorDomain = @"MGRDropboxParserErrorDomain";

@implementation MGRDropboxParser

- (NSArray<id<MGRNode>> *)nodesFromJSONObject:(id)JSONObject error:(NSError *__autoreleasing  _Nullable *)error {
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

    NSArray<id<MGRNode>> *nodes = [self nodesFromEntries:entries path:nil fromIndex:0 count:NULL error:error];

    return nodes;
}

- (id<MGRNode>)nodeFromJSONObject:(id)JSONObject error:(NSError *__autoreleasing  _Nullable *)error {
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
    if ([tag isEqualToString:@"file"]) {
        if (entry[@"media_info"] &&
            [entry[@"media_info"] isKindOfClass:[NSDictionary class]] &&
            [entry[@"media_info"][@".tag"] isKindOfClass:[NSString class]] &&
            [entry[@"media_info"][@".tag"] isEqualToString:@"metadata"] &&
            [entry[@"media_info"][@"metadata"] isKindOfClass:[NSDictionary class]] &&
            [entry[@"media_info"][@"metadata"][@".tag"] isKindOfClass:[NSString class]] &&
            [entry[@"media_info"][@"metadata"][@".tag"] isEqualToString:@"photo"]) {
            return [[MGRPhoto alloc] initWithJSONObject:entry error:error];
        }
        else {
            return [[MGRFile alloc] initWithJSONObject:entry error:error];
        }
    }
    else if ([tag isEqualToString:@"folder"]) {
        return [[MGRFolder alloc] initWithJSONObject:entry childNodes:@[] error:error];
    }
    else {
        if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
        return nil;
    }
}

- (NSArray<id<MGRNode>> *)nodesFromEntries:(NSArray *)entries
                                    path:(NSString *)filterPath
                               fromIndex:(NSUInteger)fromIndex
                                   count:(NSUInteger *)countOut
                                   error:(NSError **)error {
    NSMutableArray<id<MGRNode>> *nodes = [NSMutableArray array];
    NSUInteger idx = fromIndex;
    while (idx < entries.count) {
        id entryObject = entries[idx];
        if (![entryObject isKindOfClass:[NSDictionary class]]) {
            if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
            return nil;
        }

        NSDictionary *entry = entryObject;
        id tagObject = entry[@".tag"];
        if (![tagObject isKindOfClass:[NSString class]]) {
            if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
            return nil;
        }

        id pathObject = entry[@"path_lower"];
        if (![pathObject isKindOfClass:[NSString class]]) {
            return nil;
        }
        NSString *path = pathObject;

        if (filterPath && ![path hasPrefix:filterPath]) {
            break;
        }

        NSString *tag = tagObject;
        if ([tag isEqualToString:@"file"]) {
            MGRFile *file;
            if (entry[@"media_info"] &&
                [entry[@"media_info"] isKindOfClass:[NSDictionary class]] &&
                [entry[@"media_info"][@".tag"] isKindOfClass:[NSString class]] &&
                [entry[@"media_info"][@".tag"] isEqualToString:@"metadata"] &&
                [entry[@"media_info"][@"metadata"] isKindOfClass:[NSDictionary class]] &&
                [entry[@"media_info"][@"metadata"][@".tag"] isKindOfClass:[NSString class]] &&
                [entry[@"media_info"][@"metadata"][@".tag"] isEqualToString:@"photo"]) {
                file = [[MGRPhoto alloc] initWithJSONObject:entry error:error];
            }
            else {
                file = [[MGRFile alloc] initWithJSONObject:entry error:error];
            }
            if (!file) {
                break;
            }
            [nodes addObject:file];
            idx++;
        }
        else if ([tag isEqualToString:@"folder"]) {
            NSUInteger count = 0;
            NSArray<id<MGRNode>> *childNodes = [self nodesFromEntries:entries path:path fromIndex:idx + 1 count:&count error:error];
            if (!childNodes) {
                return nil;
            }
            idx += count;

            MGRFolder *folder = [[MGRFolder alloc] initWithJSONObject:entry childNodes:childNodes error:error];
            [nodes addObject:folder];
            idx++;
        }
        else {
            if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
            return nil;
        }
    }

    if (countOut) *countOut = idx - fromIndex;
    
    return nodes;
}

@end
