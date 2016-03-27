//
//  MGRLoginViewController.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRLoginViewController.h"
#import "MGRListViewController.h"
#import "EXTScope.h"

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

    if (self.session.linked) {
        [self performSegueWithIdentifier:@"Photos" sender:nil];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"Photos"]) {
        if (!self.session.linked) {
            self.loginButton.enabled = NO;
            @weakify(self);
            [self.session linkFromNavigationController:self.navigationController completion:^{
                @strongify(self);
                self.loginButton.enabled = YES;
                if (self.session.linked) {
                    [self performSegueWithIdentifier:@"Photos" sender:nil];
                }
            }];
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
        controller.path = @""; // Root folder
    }
}

- (IBAction)unwindToLogin:(UIStoryboardSegue *)sender {
    [self.session unlink];
}

- (IBAction)unwindFromAbout:(UIStoryboardSegue *)sender {
}

@end
