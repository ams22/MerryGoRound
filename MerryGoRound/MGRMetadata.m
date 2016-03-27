//
//  MGRMetadata.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRMetadata.h"
#import "MGRFileMetadata.h"
#import "MGRFolderMetadata.h"

@implementation MGRMetadata

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    id tagObject = JSONDictionary[@".tag"];
    if (![tagObject isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString *tag = tagObject;

    if ([tag isEqualToString:@"file"]) {
        return [MGRFileMetadata class];
    }
    else if ([tag isEqualToString:@"folder"]) {
        return [MGRFolderMetadata class];
    }
    else {
        return nil;
    }
}

@end
