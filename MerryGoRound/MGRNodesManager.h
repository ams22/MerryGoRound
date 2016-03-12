//
//  MGRNodesManager.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 06.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGRNode.h"

@class MGRNodesManager;

@protocol MGRNodesManagerDelegate <NSObject>
- (void)managerDidUpdateNodes:(MGRNodesManager *)manager;
@end

@interface MGRNodesManager : NSObject

@property (nonatomic, weak) id<MGRNodesManagerDelegate> delegate;
@property (nonatomic, readonly, copy) NSArray<id<MGRNode>> *nodes;

- (void)refresh;

@end
