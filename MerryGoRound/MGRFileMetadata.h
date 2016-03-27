//
//  MGRFileMetadata.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRMetadata.h"
#import "MGRMediaMetadata.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGRFileMetadata : MGRMetadata <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *path;
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSDate *clientModified;
@property (nonatomic, copy, readonly) NSDate *serverModified;
@property (nonatomic, readonly) NSUInteger size;
@property (nonatomic, copy, readonly, nullable) MGRMediaMetadata *mediaMetadata;

@property (nonatomic, readonly, getter=isImage) BOOL image;

@end

NS_ASSUME_NONNULL_END
