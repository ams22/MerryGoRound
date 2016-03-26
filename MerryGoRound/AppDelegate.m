//
//  AppDelegate.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "AppDelegate.h"
#import <DropboxSDK/DropboxSDK.h>
#import "MGRLoginViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"

@interface AppDelegate ()

@property (nonatomic, strong) DBSession *session;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.session = [[DBSession alloc] initWithAppKey:@"yoykfhbr69abubo" appSecret:@"jzgj6imeiop5t6w" root:kDBRootDropbox];

    UINavigationController *rootViewController = (UINavigationController *)self.window.rootViewController;
    MGRLoginViewController *loginController = (MGRLoginViewController *)rootViewController.viewControllers.firstObject;

    NSURL *tokenURL = [NSURL URLWithString:@"https://api.dropboxapi.com/1/oauth2/token"];
    NSString *redirectURLString = @"http://localhost/oauthcallback";

    GTMOAuth2Authentication *authentication =
    [GTMOAuth2Authentication authenticationWithServiceProvider:@"Dropbox"
                                                      tokenURL:tokenURL
                                                   redirectURI:redirectURLString
                                                      clientID:@"yoykfhbr69abubo"
                                                  clientSecret:@"jzgj6imeiop5t6w"];
    [GTMOAuth2ViewControllerTouch authorizeFromKeychainForName:@"Merry-go-round: Dropbox"
                                                authentication:authentication
                                                         error:NULL];
    loginController.authentication = authentication;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([self.session handleOpenURL:url]) {
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([self.session handleOpenURL:url]) {
        return YES;
    }
    return NO;
}

@end
