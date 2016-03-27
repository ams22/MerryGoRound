//
//  MGRDropboxParserUtilities.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGRDropboxParserUtilities : NSObject

+ (NSValueTransformer *)dateValueJSONTransformer;

@end
