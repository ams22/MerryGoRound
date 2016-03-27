//
//  MGRFolderMetadata.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRMetadata.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGRFolderMetadata : MGRMetadata <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *path;
@property (nonatomic, copy, readonly) NSString *identifier;

@end

NS_ASSUME_NONNULL_END
