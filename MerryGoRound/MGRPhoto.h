//
//  MGRPhoto.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGRPhoto : MGRFile

- (instancetype)initWithDropboxID:(NSString *)dropboxID
                             name:(NSString *)name
                             path:(NSString *)path
                   clientModified:(NSDate *)clientModified
                             size:(NSUInteger)size
                            width:(NSUInteger)width
                           height:(NSUInteger)height
                        dateTaken:(nullable NSDate *)dateTaken NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithDropboxID:(NSString *)dropboxID
                             name:(NSString *)name
                             path:(NSString *)path
                   clientModified:(NSDate *)clientModified
                             size:(NSUInteger)size NS_UNAVAILABLE;

@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, readonly) NSUInteger height;
@property (nonatomic, readonly, copy) NSDate *dateTaken;

@end

NS_ASSUME_NONNULL_END
