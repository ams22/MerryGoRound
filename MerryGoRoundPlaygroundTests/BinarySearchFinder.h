//
//  BinarySearchFinder.h
//  MRMail
//
//  Created by Andrey Shmatlay on 20.11.13.
//  Copyright (c) 2013 Mail.Ru. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BinarySearchFinder : NSObject

- (instancetype)initWithComparator:(NSComparator)comparator NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

// Если не найден, вернем NSNotFound
- (NSUInteger)indexOfObject:(id)object inArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
