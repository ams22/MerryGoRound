//
//  MGRFolderMetadata.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRFolderMetadata.h"
#import "EXTKeyPathCoding.h"

@implementation MGRFolderMetadata

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @keypath(MGRFolderMetadata.alloc, name) : @"name",
              @keypath(MGRFolderMetadata.alloc, path) : @"path_lower",
              @keypath(MGRFolderMetadata.alloc, identifier) : @"id" };
}

@end
