//
//  MGRAbstractNode.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 27.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGRNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGRAbstractNode : NSObject <MGRNode>

- (instancetype)initWithDropboxID:(NSString *)dropboxID
                             name:(NSString *)name
                             path:(NSString *)path NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (BOOL)isEqualToNode:(MGRAbstractNode *)node;

@end

NS_ASSUME_NONNULL_END
