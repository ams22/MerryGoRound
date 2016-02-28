//
//  MGRFolder+MGRDropboxParser.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 28.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRFolder.h"
#import "MGRDropboxParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGRFolder (MGRDropboxParser)

- (nullable instancetype)initWithJSONObject:(id)JSONObject
                                 childNodes:(NSArray<MGRNode *> *)childNodes
                                      error:(NSError * _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
