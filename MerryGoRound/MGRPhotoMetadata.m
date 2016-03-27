//
//  MGRPhotoMetadata.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRPhotoMetadata.h"
#import "EXTKeyPathCoding.h"
#import "MGRDropboxParserUtilities.h"

@implementation MGRPhotoMetadata

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @keypath(MGRPhotoMetadata.alloc, dimensions) : @"dimensions",
              @keypath(MGRPhotoMetadata.alloc, location) : @"location",
              @keypath(MGRPhotoMetadata.alloc, timeTaken) : @"time_taken" };
}

+ (NSValueTransformer *)timeTakenJSONTransformer {
    return [MGRDropboxParserUtilities dateValueJSONTransformer];
}

@end
