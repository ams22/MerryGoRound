//
//  MGRDropboxSession.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 26/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRDropboxSession.h"
#import "GTMOAuth2ViewControllerTouch.h"

static NSString *const MGRDropboxSessionProviderName = @"Dropbox";
static NSString *const MGRDropboxSessionKeychainItemName = @"Merry-go-round: Dropbox";
static NSString *const MGRDropboxSessionTokenURLString = @"https://api.dropboxapi.com/1/oauth2/token";
static NSString *const MGRDropboxSessionAuthorizationURLString = @"https://www.dropbox.com/1/oauth2/authorize";
static NSString *const MGRDropboxSessionRedirectURLString = @"http://localhost/oauthcallback";

@interface MGRDropboxSession ()

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appSecret;
@property (nonatomic, strong) GTMOAuth2Authentication *authentication;

@end

@implementation MGRDropboxSession

- (instancetype)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret {
    if (self = [super init]) {
        _appKey = [appKey copy];
        _appSecret = [appSecret copy];

        _authentication =
        [GTMOAuth2Authentication authenticationWithServiceProvider:MGRDropboxSessionProviderName
                                                          tokenURL:[NSURL URLWithString:MGRDropboxSessionTokenURLString]
                                                       redirectURI:MGRDropboxSessionRedirectURLString
                                                          clientID:_appKey
                                                      clientSecret:_appSecret];

        NSError *keychainAuthError;
        BOOL authorized = [GTMOAuth2ViewControllerTouch authorizeFromKeychainForName:MGRDropboxSessionKeychainItemName
                                                                      authentication:_authentication
                                                                               error:&keychainAuthError];
        NSLog(@"authorizeFromKeychain ok:%i error:%@", authorized, keychainAuthError);
    }
    return self;
}

- (BOOL)isLinked {
    return [self.authentication canAuthorize];
}

- (void)linkFromNavigationController:(UINavigationController *)navigationController
                          completion:(nullable void (^)(void))completion {
    GTMOAuth2ViewControllerTouch *controller =
    [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:self.authentication
                                                authorizationURL:[NSURL URLWithString:MGRDropboxSessionAuthorizationURLString]
                                                keychainItemName:MGRDropboxSessionKeychainItemName
                                               completionHandler:
     ^(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth, NSError *error) {
         if (completion) {
             completion();
         }
     }];
    controller.navigationItem.title = @"Вход";
    [navigationController pushViewController:controller animated:YES];
}

- (void)unlink {
    [self.authentication reset];
    [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:MGRDropboxSessionKeychainItemName];
}

- (void)authorizeRequest:(NSMutableURLRequest *)request {
    [self.authentication authorizeRequest:request];
}

@end
