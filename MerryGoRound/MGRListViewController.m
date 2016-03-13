//
//  MGRListViewController.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 07.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRListViewController.h"
#import "MGRSinglePhotoViewController.h"

@implementation MGRListViewController

- (IBAction)unwindFromAbout:(UIStoryboardSegue *)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPhoto"]) {
        MGRSinglePhotoViewController *controller = segue.destinationViewController;
        controller.photoURL = [NSURL URLWithString:@"http://lorempixel.com/400/200/"];
    }
}

@end
