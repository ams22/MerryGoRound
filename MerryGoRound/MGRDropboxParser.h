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

/**
 Преобразует распаршеный JSON-объект в иерархию файлов и папок.
 
 @param JSONObject JSON-объект
 @param error ошибка парсинга
 @return массив файлов и папок или nil в случае ошибки
 */
- (nullable NSArray<id<MGRNode>> *)nodesFromJSONObject:(id)JSONObject error:(NSError * _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
