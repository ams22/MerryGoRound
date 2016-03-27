//
//  MGRMediaMetadata.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRMediaMetadata.h"
#import "MGRPhotoMetadata.h"

@implementation MGRMediaMetadata

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    return [MGRPhotoMetadata class];
}

@end
