//
//  MGRNode.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 28.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MGRNode <NSObject>

@property (nonatomic, readonly, copy) NSString *dropboxID;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *path;
@property (nonatomic, readonly, getter=isDirectory) BOOL directory;

@end

NS_ASSUME_NONNULL_END
