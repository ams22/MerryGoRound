//
//  MGRFile+MGRDropboxParser.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 28.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRFile+MGRDropboxParser.h"

@implementation MGRFile (MGRDropboxParser)

- (instancetype)initWithJSONObject:(id)JSONObject error:(NSError *__autoreleasing  _Nullable *)error {
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

    if (![tag isEqualToString:@"file"]) {
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

    id clientModifiedObject = entry[@"client_modified"];
    if (![clientModifiedObject isKindOfClass:[NSString class]]) {
        if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
        return nil;
    }

    NSDate *clientModified = [[[self class] dateFormatter] dateFromString:clientModifiedObject];
    if (!clientModified) {
        if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
        return nil;
    }

    id sizeObject = entry[@"size"];
    if (![sizeObject isKindOfClass:[NSNumber class]]) {
        if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
        return nil;
    }
    NSNumber *size = sizeObject;

    return [self initWithDropboxID:dropboxIDObject
                              name:nameObject
                              path:pathObject
                    clientModified:clientModified
                              size:size.unsignedIntegerValue];
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    });
    return dateFormatter;
}

@end
