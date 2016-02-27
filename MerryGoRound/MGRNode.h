//
//  MGRNode.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 27.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGRNode : NSObject

- (instancetype)initWithDropboxID:(NSString *)dropboxID
                             name:(NSString *)name
                             path:(NSString *)path NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, readonly, copy) NSString *dropboxID;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *path;

- (BOOL)isEqualToNode:(MGRNode *)node;

@end

NS_ASSUME_NONNULL_END
