//
//  MGRFolder.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 27.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRAbstractNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGRFolder : MGRAbstractNode

- (instancetype)initWithDropboxID:(NSString *)dropboxID
                             name:(NSString *)name
                             path:(NSString *)path
                       childNodes:(NSArray<id<MGRNode>> *)childNodes NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly, copy) NSArray<id<MGRNode>> *childNodes;

@end

NS_ASSUME_NONNULL_END
