//
//  MGRDimensions.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRDimensions.h"
#import "EXTKeyPathCoding.h"

@implementation MGRDimensions

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{ @keypath(MGRDimensions.alloc, width) : @"width",
              @keypath(MGRDimensions.alloc, height) : @"height" };
}

@end
