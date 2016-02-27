//
//  MGRFile.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 27.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGRFile : MGRNode

- (instancetype)initWithDropboxID:(NSString *)dropboxID
                             name:(NSString *)name
                             path:(NSString *)path
                   clientModified:(NSDate *)clientModified
                             size:(NSUInteger)size NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithDropboxID:(NSString *)dropboxID
                             name:(NSString *)name
                             path:(NSString *)path NS_UNAVAILABLE;

@property (nonatomic, readonly, copy) NSDate *clientModified;
@property (nonatomic, readonly) NSUInteger size;

@end

NS_ASSUME_NONNULL_END
