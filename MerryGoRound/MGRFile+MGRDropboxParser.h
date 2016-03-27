//
//  MGRFile+MGRDropboxParser.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 28.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRFile.h"
#import "MGRDropboxParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGRFile (MGRDropboxParser)

- (nullable instancetype)initWithJSONObject:(id)JSONObject error:(NSError * _Nullable *)error;

+ (NSDateFormatter *)dateFormatter;

@end

NS_ASSUME_NONNULL_END
