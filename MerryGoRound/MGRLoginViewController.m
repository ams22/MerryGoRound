//
//  MGRLoginViewController.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRLoginViewController.h"
#import "MGRListViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"

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

    if ([self.authentication canAuthorize]) {
        [self performSegueWithIdentifier:@"Photos" sender:nil];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"Photos"]) {
        if (![self.authentication canAuthorize]) {
            NSURL *authorizationURL = [NSURL URLWithString:@"https://www.dropbox.com/1/oauth2/authorize"];

            GTMOAuth2ViewControllerTouch *controller =
            [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:self.authentication
                                                        authorizationURL:authorizationURL
                                                        keychainItemName:@"Merry-go-round: Dropbox"
                                                       completionHandler:
             ^(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth, NSError *error) {
                 [self.navigationController setNavigationBarHidden:YES animated:YES];
             }];
            controller.navigationItem.title = @"Вход";
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            [self.navigationController pushViewController:controller animated:YES];

            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Photos"]) {
        UINavigationController *destination = segue.destinationViewController;
        MGRListViewController *controller = destination.viewControllers.firstObject;
//        controller.session = self.session;
        controller.path = @"/";
    }
}

- (IBAction)unwindToLogin:(UIStoryboardSegue *)sender {
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:@"Merry-go-round: Dropbox"];
}

- (IBAction)unwindFromAbout:(UIStoryboardSegue *)sender {
}

@end
