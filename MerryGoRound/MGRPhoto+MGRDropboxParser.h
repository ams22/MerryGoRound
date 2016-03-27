//
//  MGRPhoto+MGRDropboxParser.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRPhoto.h"
#import "MGRDropboxParser.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGRPhoto (MGRDropboxParser)

- (nullable instancetype)initWithJSONObject:(id)JSONObject error:(NSError * _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
