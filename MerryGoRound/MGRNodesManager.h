//
//  MGRNodesManager.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 06.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGRNode.h"

//extern NSString *const MGRNodesManagerDidUpdateNodesNotification;

//typedef NS_ENUM(NSUInteger, MGRNodesManagerEvent) {
//    MGRNodesManagerEventDidUpdateNodes
//};

//@class MGRNodesManager;
//
//@protocol MGRNodesManagerDelegate <NSObject>
//- (void)managerDidUpdateNodes:(MGRNodesManager *)manager;
//@end

@interface MGRNodesManager : NSObject

@property (nonatomic, readonly, copy) NSArray<id<MGRNode>> *nodes;

- (void)refresh;

//@property (nonatomic, weak) id<MGRNodesManagerDelegate> delegate;

//- (void)addTarget:(id)target action:(SEL)action forEvent:(MGRNodesManagerEvent)event;
//- (void)removeTarget:(id)target action:(SEL)action forEvent:(MGRNodesManagerEvent)event;

@end
