//
//  MGRPhoto+MGRDropboxParser.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRPhoto+MGRDropboxParser.h"
#import "MGRFile+MGRDropboxParser.h"

@implementation MGRPhoto (MGRDropboxParser)

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

    id mediaInfoObject = entry[@"media_info"];
    if (![mediaInfoObject isKindOfClass:[NSDictionary class]]) {
        if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
        return nil;
    }
    NSDictionary *mediaInfo = mediaInfoObject;

    id mediaInfoTagObject = mediaInfo[@".tag"];
    if (![mediaInfoTagObject isKindOfClass:[NSString class]]) {
        if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
        return nil;
    }
    NSString *mediaInfoTag = mediaInfoTagObject;

    NSUInteger width = 0;
    NSUInteger height = 0;
    NSDate *dateTaken = nil;

    if ([mediaInfoTag isEqualToString:@"pending"]) {
        // Значения еще не заполнены на сервере
    }
    else if ([mediaInfoTag isEqualToString:@"metadata"]) {
        id metadataObject = mediaInfo[@"metadata"];
        if (![metadataObject isKindOfClass:[NSDictionary class]]) {
            if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
            return nil;
        }
        NSDictionary *metadata = metadataObject;

        id metadataTagObject = metadata[@".tag"];
        if (![metadataTagObject isKindOfClass:[NSString class]]) {
            if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
            return nil;
        }
        NSString *metadataTag = metadataTagObject;

        if (![metadataTag isEqualToString:@"photo"]) {
            if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
            return nil;
        }

        id dimensionsObject = metadata[@"dimensions"];
        if (![dimensionsObject isKindOfClass:[NSDictionary class]]) {
            if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
            return nil;
        }
        NSDictionary *dimensions = dimensionsObject;

        id widthObject = dimensions[@"width"];
        if (widthObject && ![widthObject isKindOfClass:[NSNumber class]]) {
            if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
            return nil;
        }
        width = [widthObject unsignedIntegerValue];

        id heightObject = dimensions[@"height"];
        if (heightObject && ![heightObject isKindOfClass:[NSNumber class]]) {
            if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
            return nil;
        }
        height = [heightObject unsignedIntegerValue];

        id timeTakenObject = metadata[@"time_taken"];
        if (timeTakenObject) {
            if (![timeTakenObject isKindOfClass:[NSString class]]) {
                if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
                return nil;
            }
            NSString *timeTaken = timeTakenObject;

            dateTaken = [[MGRFile dateFormatter] dateFromString:timeTaken];
        }
    }
    else {
        if (error) *error = [NSError errorWithDomain:MGRDropboxParserErrorDomain code:MGRDropboxParserErrorInvalidJSON userInfo:nil];
        return nil;
    }

    return [self initWithDropboxID:dropboxIDObject
                              name:nameObject
                              path:pathObject
                    clientModified:clientModified
                              size:size.unsignedIntegerValue
                             width:width
                            height:height
                         dateTaken:dateTaken];
}

@end
