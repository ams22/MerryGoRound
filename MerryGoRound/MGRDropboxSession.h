//
//  MGRDropboxSession.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 26/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGRDropboxSession : NSObject

- (instancetype)initWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, readonly, getter=isLinked) BOOL linked;

- (void)linkFromNavigationController:(UINavigationController *)navigationController
                          completion:(nullable void (^)(void))completion;
- (void)unlink;

- (void)authorizeRequest:(NSMutableURLRequest *)request;

@end

NS_ASSUME_NONNULL_END
