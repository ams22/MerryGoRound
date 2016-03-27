//
//  MGRFileMetadata.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRFileMetadata.h"
#import "EXTKeyPathCoding.h"
#import "MGRDropboxParserUtilities.h"

@implementation MGRFileMetadata

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @keypath(MGRFileMetadata.alloc, name) : @"name",
              @keypath(MGRFileMetadata.alloc, path) : @"path_lower",
              @keypath(MGRFileMetadata.alloc, identifier) : @"id",
              @keypath(MGRFileMetadata.alloc, clientModified) : @"client_modified",
              @keypath(MGRFileMetadata.alloc, serverModified) : @"server_modified",
              @keypath(MGRFileMetadata.alloc, size) : @"size",
              @keypath(MGRFileMetadata.alloc, mediaMetadata) : @"media_info.metadata" };
}

+ (NSValueTransformer *)clientModifiedJSONTransformer {
    return [MGRDropboxParserUtilities dateValueJSONTransformer];
}

+ (NSValueTransformer *)serverModifiedJSONTransformer {
    return [MGRDropboxParserUtilities dateValueJSONTransformer];
}

- (BOOL)isImage {
    NSSet<NSString *> *imageExtensions = [NSSet setWithObjects:@"jpg", @"jpeg", @"png", @"tiff", @"tif", @"gif", @"bmp", nil];
    return [imageExtensions containsObject:self.path.pathExtension.lowercaseString];
}

@end
