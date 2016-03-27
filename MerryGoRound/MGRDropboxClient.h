//
//  MGRDropboxClient.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 26/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGRNode.h"
#import "MGRDropboxSession.h"

@class MPOAuthCredentialConcreteStore;

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MGRDropboxClientErrorDomain;
extern NSString *const MGRDropboxClientResponseJSONKey;

typedef NS_ENUM(NSUInteger, MGRDropboxClientErrorCode) {
    MGRDropboxClientErrorCodeBadInput       = 400,
    MGRDropboxClientErrorCodeBadToken       = 401,
    MGRDropboxClientErrorCodeEndpointError  = 409,
    MGRDropboxClientErrorCodeRateLimit      = 429,
};

#define MGRDropboxClientErrorCodeServerError(code)  ((code) >= 500 && (code) <= 599)

typedef void (^MGRDropboxClientListFolderResultBlock)(NSArray<id<MGRNode>> * _Nullable nodes,
                                                      NSError * _Nullable error);
typedef void (^MGRDropboxClientGetMetadataResultBlock)(id<MGRNode> _Nullable node,
                                                       NSError * _Nullable error);
typedef void (^MGRDropboxClientImageResultBlock)(UIImage * _Nullable image, NSError * _Nullable error);
typedef void (^MGRDropboxClientDataResultBlock)(NSData * _Nullable data, NSError * _Nullable error);

@interface MGRDropboxClient : NSObject

- (instancetype)initWithSession:(MGRDropboxSession *)session NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void)downloadPath:(NSString *)path
          saveToPath:(nullable NSString *)saveToPath
         resultBlock:(MGRDropboxClientDataResultBlock)resultBlock;

- (void)getMetadataWithPath:(NSString *)path
                resultBlock:(MGRDropboxClientGetMetadataResultBlock)resultBlock;

- (void)getThumbnailWithPath:(NSString *)path
                  saveToPath:(nullable NSString *)saveToPath
                 resultBlock:(MGRDropboxClientImageResultBlock)resultBlock;

- (void)listFolderWithPath:(NSString *)path
               resultBlock:(MGRDropboxClientListFolderResultBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
