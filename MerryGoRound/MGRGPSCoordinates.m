//
//  MGRGPSCoordinates.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRGPSCoordinates.h"
#import "EXTKeyPathCoding.h"

@implementation MGRGPSCoordinates

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @keypath(MGRGPSCoordinates.alloc, latitude) : @"latitude",
               @keypath(MGRGPSCoordinates.alloc, longitude) : @"longitude" };
}

@end
