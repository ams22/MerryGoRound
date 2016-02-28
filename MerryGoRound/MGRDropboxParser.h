//
//  MGRDropboxParser.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 28.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGRNode.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MGRDropboxParserErrorDomain;

typedef NS_ENUM(NSUInteger, MGRDropboxParserError) {
    MGRDropboxParserErrorInvalidJSON
};

@interface MGRDropboxParser : NSObject

- (nullable NSArray<MGRNode *> *)nodesFromJSONObject:(id)JSONObject error:(NSError * _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
