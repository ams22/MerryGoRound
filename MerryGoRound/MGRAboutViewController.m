//
//  MGRAboutViewController.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 07.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRAboutViewController.h"
#import "SWRevealViewController.h"

@implementation MGRAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:[self.revealViewController panGestureRecognizer]];
}

@end
