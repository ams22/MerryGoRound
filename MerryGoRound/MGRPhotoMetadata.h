//
//  MGRPhotoMetadata.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRMediaMetadata.h"
#import "MGRDimensions.h"
#import "MGRGPSCoordinates.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGRPhotoMetadata : MGRMediaMetadata <MTLJSONSerializing>

@property (nonatomic, copy, readonly, nullable) MGRDimensions *dimensions;
@property (nonatomic, copy, readonly, nullable) MGRGPSCoordinates *location;
@property (nonatomic, copy, readonly, nullable) NSDate *timeTaken;

@end

NS_ASSUME_NONNULL_END
