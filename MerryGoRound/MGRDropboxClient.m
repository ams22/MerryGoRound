//
//  MGRDropboxClient.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 26/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRDropboxClient.h"
#import "MGRDropboxParser.h"

NSString *const MGRDropboxClientErrorDomain = @"MGRDropboxClientErrorDomain";
NSString *const MGRDropboxClientResponseJSONKey = @"ResponseJSON";
static NSString *const MGRDropboxClientUserAgent = @"Merry-go-round/1.0";
static NSString *const MGRDropboxClientEndpointBaseURL = @"https://api.dropboxapi.com/2";
static NSString *const MGRDropboxClientContentBaseURL = @"https://content.dropboxapi.com/2";

@interface MGRDropboxClient ()

@property (nonatomic, strong) NSURLSession *URLSession;
@property (nonatomic, strong) MGRDropboxSession *dropboxSession;

@end

@implementation MGRDropboxClient

- (instancetype)initWithSession:(MGRDropboxSession *)session {
    if (self = [super init]) {
        _dropboxSession = session;

        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{ @"User-Agent" : MGRDropboxClientUserAgent };
        configuration.timeoutIntervalForRequest = 30;
        configuration.timeoutIntervalForResource = 30;
        configuration.HTTPMaximumConnectionsPerHost = 6;
        configuration.HTTPShouldUsePipelining = YES;
        _URLSession = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

- (void)downloadPath:(NSString *)path
          saveToPath:(NSString *)saveToPath
         resultBlock:(MGRDropboxClientDataResultBlock)resultBlock {
    [self contentRequestWithMethod:@"POST"
                          endpoint:@"files/download"
                        parameters:@{ @"path" : path }
                       resultBlock:
     ^(NSData * _Nullable responseData, NSError * _Nullable error) {
         [responseData writeToFile:saveToPath atomically:NO];
         dispatch_async(dispatch_get_main_queue(), ^{
             resultBlock(responseData, error);
         });
     }];
}

- (void)getMetadataWithPath:(NSString *)path
                resultBlock:(MGRDropboxClientGetMetadataResultBlock)resultBlock {
    [self JSONRequestWithMethod:@"POST"
                       endpoint:@"files/get_metadata"
                     parameters:@{ @"path" : path,
                                   @"include_media_info": @(YES) }
                    resultBlock:
     ^(id  _Nullable responseObject, NSError * _Nullable error) {
         MGRDropboxClientGetMetadataResultBlock internalResultBlock = ^(MGRMetadata * _Nullable node,
                                                                        NSError * _Nullable error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 resultBlock(node, error);
             });
         };

         if (!responseObject) {
             internalResultBlock(nil, error);
             return;
         }

         MGRDropboxParser *parser = [[MGRDropboxParser alloc] init];
         NSError *parseError;
         MGRMetadata *node = [parser nodeFromJSONObject:responseObject error:&parseError];
         internalResultBlock(node, parseError);
     }];
}

- (void)getThumbnailWithPath:(NSString *)path
                  saveToPath:(nullable NSString *)saveToPath
                 resultBlock:(MGRDropboxClientImageResultBlock)resultBlock {
    [self contentRequestWithMethod:@"POST"
                          endpoint:@"files/get_thumbnail"
                        parameters:@{ @"path" : path,
                                      @"size": @"w128h128" }
                       resultBlock:
     ^(NSData * _Nullable responseData, NSError * _Nullable error) {
         MGRDropboxClientImageResultBlock internalResultBlock = ^(UIImage * _Nullable image, NSError * _Nullable error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 resultBlock(image, error);
             });
         };

         if (!responseData) {
             internalResultBlock(nil, error);
             return;
         }

         UIImage *image = [[UIImage alloc] initWithData:responseData scale:1];
         if (image && saveToPath) {
             [responseData writeToFile:saveToPath atomically:NO];
         }

         internalResultBlock(image, error);
     }];
}

- (void)listFolderWithPath:(NSString *)path
               resultBlock:(MGRDropboxClientListFolderResultBlock)resultBlock {
    [self JSONRequestWithMethod:@"POST"
                       endpoint:@"files/list_folder"
                     parameters:@{ @"path" : path,
                                   @"include_media_info": @(YES) }
                    resultBlock:
     ^(id  _Nullable responseObject, NSError * _Nullable error) {
         MGRDropboxClientListFolderResultBlock internalResultBlock = ^(NSArray<MGRMetadata *> * _Nullable nodes,
                                                                       NSError * _Nullable error) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 resultBlock(nodes, error);
             });
         };

         if (!responseObject) {
             internalResultBlock(nil, error);
             return;
         }

         MGRDropboxParser *parser = [[MGRDropboxParser alloc] init];
         NSError *parseError;
         NSArray<MGRMetadata *> *nodes = [parser nodesFromJSONObject:responseObject error:&parseError];
         internalResultBlock(nodes, parseError);
     }];
}

- (void)JSONRequestWithMethod:(NSString *)method
                     endpoint:(NSString *)endpoint
                   parameters:(NSDictionary *)parameters
                  resultBlock:(void (^)(id _Nullable responseObject, NSError * _Nullable error))resultBlock {
    NSURL *baseURL = [NSURL URLWithString:MGRDropboxClientEndpointBaseURL];
    NSURL *URL = [baseURL URLByAppendingPathComponent:endpoint];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    request.HTTPMethod = method;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:NULL];

    [self.dropboxSession authorizeRequest:request];

    NSURLSessionTask *task =
    [self.URLSession dataTaskWithRequest:request completionHandler:
     ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         if (!data || !response) {
             resultBlock(nil, error);
             return;
         }

         NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
         NSInteger statusCode = HTTPResponse.statusCode;
         if (statusCode != 200) {
             NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
             id responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             if (responseJSON) {
                 userInfo[MGRDropboxClientResponseJSONKey] = responseJSON;
             }
             NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             if (responseString) {
                 userInfo[NSLocalizedDescriptionKey] = responseString;
             }

             NSError *dropboxError = [NSError errorWithDomain:MGRDropboxClientErrorDomain code:statusCode userInfo:userInfo];
             resultBlock(nil, dropboxError);
             return;
         }

         NSError *JSONError;
         id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
         if (!responseObject) {
             resultBlock(nil, JSONError);
             return;
         }

         resultBlock(responseObject, nil);
     }];
    [task resume];
}

- (void)contentRequestWithMethod:(NSString *)method
                        endpoint:(NSString *)endpoint
                      parameters:(NSDictionary *)parameters
                     resultBlock:(void (^)(NSData * _Nullable responseData, NSError * _Nullable error))resultBlock {
    NSURL *baseURL = [NSURL URLWithString:MGRDropboxClientContentBaseURL];
    NSURL *URL = [baseURL URLByAppendingPathComponent:endpoint];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    request.HTTPMethod = method;
    NSData *JSONParametersData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:NULL];
    NSString *JSONParametersString = [[NSString alloc] initWithData:JSONParametersData encoding:NSUTF8StringEncoding];
    [request setValue:JSONParametersString forHTTPHeaderField:@"Dropbox-API-Arg"];

    [self.dropboxSession authorizeRequest:request];

    NSURLSessionTask *task =
    [self.URLSession dataTaskWithRequest:request completionHandler:
     ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         if (!data || !response) {
             resultBlock(nil, error);
             return;
         }

         NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
         NSInteger statusCode = HTTPResponse.statusCode;
         if (statusCode != 200) {
             NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
             id responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             if (responseJSON) {
                 userInfo[MGRDropboxClientResponseJSONKey] = responseJSON;
             }
             NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             if (responseString) {
                 userInfo[NSLocalizedDescriptionKey] = responseString;
             }

             NSError *dropboxError = [NSError errorWithDomain:MGRDropboxClientErrorDomain code:statusCode userInfo:userInfo];
             resultBlock(nil, dropboxError);
             return;
         }

         resultBlock(data, nil);
     }];
    [task resume];
}

@end
