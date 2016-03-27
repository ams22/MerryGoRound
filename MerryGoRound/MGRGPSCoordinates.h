//
//  MGRGPSCoordinates.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

@import Mantle;

NS_ASSUME_NONNULL_BEGIN

@interface MGRGPSCoordinates : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;

@end

NS_ASSUME_NONNULL_END
