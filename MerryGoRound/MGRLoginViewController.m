//
//  MGRLoginViewController.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRLoginViewController.h"
#import "MGRNodesManager.h"
#import "EXTScope.h"
#import "EXTKeyPathCoding.h"

//static void *const NodesManagerDidUpdateNodesObservationContext = &NodesManagerDidUpdateNodesObservationContext;

@interface MGRLoginViewController ()
//<MGRNodesManagerDelegate>

@property (nonatomic, strong) MGRNodesManager *nodesManager;

@end

@implementation MGRLoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _nodesManager = [[MGRNodesManager alloc] init];

//        [_nodesManager addTarget:self action:@selector(managerDidUpdateNodes:) forEvent:MGRNodesManagerEventDidUpdateNodes];

//        _nodesManager.delegate = self;

//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(managerDidUpdateNodesNotificationReceived:)
//                                                     name:MGRNodesManagerDidUpdateNodesNotification
//                                                   object:_nodesManager];

//        [_nodesManager addObserver:self
//                        forKeyPath:@"nodes"
//                           options:NSKeyValueObservingOptionInitial
//                           context:NodesManagerDidUpdateNodesObservationContext];
    }
    return self;
}

- (void)dealloc {
//    [_nodesManager removeTarget:self action:@selector(managerDidUpdateNodes:) forEvent:MGRNodesManagerEventDidUpdateNodes];

//    [[NSNotificationCenter defaultCenter] removeObserver:self];

//    [_nodesManager removeObserver:self
//                       forKeyPath:@"nodes"
//                          context:NodesManagerDidUpdateNodesObservationContext];
}

- (IBAction)unwindToLogin:(UIStoryboardSegue *)sender {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.nodesManager refresh];
}

//- (void)managerDidUpdateNodesNotificationReceived:(NSNotification *)notification {
//    NSLog(@"%s %@", __PRETTY_FUNCTION__, notification);
//}

//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary<NSString *,id> *)change
//                       context:(void *)context {
//    if (context == NodesManagerDidUpdateNodesObservationContext) {
//        NSLog(@"%s %@", __PRETTY_FUNCTION__, change);
//    }
//}

//- (void)managerDidUpdateNodes:(MGRNodesManager *)manager {
//    NSLog(@"%s %@", __PRETTY_FUNCTION__, manager);
//}

//- (void)managerDidUpdateNodes:(id)sender {
//    NSLog(@"%s %@", __PRETTY_FUNCTION__, sender);
//}

@end
