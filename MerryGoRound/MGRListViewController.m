//
//  MGRListViewController.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 07.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRListViewController.h"
#import "MGRSinglePhotoViewController.h"
#import "SWRevealViewController.h"

@interface MGRListViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuItem;

@end

@implementation MGRListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        [self.menuItem setTarget:self.revealViewController];
        [self.menuItem setAction:@selector(revealToggle:)];
        [self.navigationController.navigationBar addGestureRecognizer:[self.revealViewController panGestureRecognizer]];
    }
}

- (IBAction)unwindFromAbout:(UIStoryboardSegue *)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPhoto"]) {
        MGRSinglePhotoViewController *controller = segue.destinationViewController;
        controller.photoURL = [NSURL URLWithString:@"http://lorempixel.com/400/200/"];
    }
}

@end
