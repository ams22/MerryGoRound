//
//  MGRNodesManager.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 06.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRNodesManager.h"
#import "MGRDropboxParser.h"

//NSString *const MGRNodesManagerDidUpdateNodesNotification = @"MGRNodesManagerDidUpdateNodesNotification";

@interface MGRNodesManager ()

@property (nonatomic, readwrite, copy) NSArray<id<MGRNode>> *nodes;

//@property (nonatomic, strong) NSMapTable *didUpdateNodesTargetActions;

//@property (nonatomic, weak) NSTimer *timer;

@end

@implementation MGRNodesManager

- (instancetype)init {
    if (self = [super init]) {
        _nodes = @[];
//        _didUpdateNodesTargetActions = [NSMapTable weakToStrongObjectsMapTable];
    }
    return self;
}

- (void)setNodes:(NSArray<id<MGRNode>> *)nodes {
    _nodes = [nodes copy];
//    [[NSNotificationCenter defaultCenter] postNotificationName:MGRNodesManagerDidUpdateNodesNotification
//                                                        object:self];

//    [self sendActionsForEvent:MGRNodesManagerEventDidUpdateNodes];

//    [self.delegate managerDidUpdateNodes:self];
}

- (void)refresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MGRDropboxParser *parser = [[MGRDropboxParser alloc] init];
        self.nodes = [parser nodesFromJSONObject:[self listFolderJSONObject] error:NULL];
    });

//    self.timer = [NSTimer scheduledTimerWithTimeInterval:2
//                                                  target:self
//                                                selector:@selector(fireTimer:)
//                                                userInfo:nil
//                                                 repeats:YES];
}

//- (void)fireTimer:(NSTimer *)timer {
//    MGRDropboxParser *parser = [[MGRDropboxParser alloc] init];
//    self.nodes = [parser nodesFromJSONObject:[self listFolderJSONObject] error:NULL];
//}
//
//- (void)stopTimer {
//    [self.timer invalidate];
//}

//- (void)addTarget:(id)target action:(SEL)action forEvent:(MGRNodesManagerEvent)event {
//    NSValue *actionValue = [NSValue value:action withObjCType:@encode(SEL)];
//    [self.didUpdateNodesTargetActions setObject:actionValue forKey:target];
//}
//
//- (void)removeTarget:(id)target action:(SEL)action forEvent:(MGRNodesManagerEvent)event {
//    [self.didUpdateNodesTargetActions removeObjectForKey:target];
//}
//
//- (void)sendActionsForEvent:(MGRNodesManagerEvent)event {
//    for (id target in self.didUpdateNodesTargetActions) {
//        SEL action = nil;
//        NSValue *actionValue = [self.didUpdateNodesTargetActions objectForKey:target];
//        [actionValue getValue:&action];
//        [target performSelector:action withObject:self];
//    }
//}

- (id)listFolderJSONObject {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *URL = [bundle URLForResource:@"list_folder.json" withExtension:nil];
    NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    return object;
}

@end
