//
//  MGRDimensions.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

@import Mantle;

NS_ASSUME_NONNULL_BEGIN

@interface MGRDimensions : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, readonly) NSUInteger height;

@end

NS_ASSUME_NONNULL_END
