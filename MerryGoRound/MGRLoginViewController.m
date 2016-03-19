//
//  MGRLoginViewController.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRLoginViewController.h"
#import "MGRListViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface MGRLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation MGRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *loginButton = self.loginButton;
    loginButton.layer.cornerRadius = 10;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.session isLinked]) {
        [self performSegueWithIdentifier:@"Photos" sender:nil];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"Photos"]) {
        if (![self.session isLinked]) {
            [self.session linkFromController:self];
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Photos"]) {
        UINavigationController *destination = segue.destinationViewController;
        MGRListViewController *controller = destination.viewControllers.firstObject;
        controller.session = self.session;
    }
}

- (IBAction)unwindToLogin:(UIStoryboardSegue *)sender {
    [self.session unlinkAll];
}

- (IBAction)unwindFromAbout:(UIStoryboardSegue *)sender {
}

@end
