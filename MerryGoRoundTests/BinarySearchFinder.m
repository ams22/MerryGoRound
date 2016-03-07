//
//  BinarySearchFinder.m
//  MRMail
//
//  Created by Andrey Shmatlay on 20.11.13.
//  Copyright (c) 2013 Mail.Ru. All rights reserved.
//

#import "BinarySearchFinder.h"

static CFComparisonResult comparatorFunction(const void *val1, const void *val2, void *context);

@interface BinarySearchFinder ()
@property (nonatomic, copy) NSComparator comparator;
@end

@implementation BinarySearchFinder

- (instancetype)initWithComparator:(NSComparator)comparator {
    if (self = [super init]) {
        _comparator = [comparator copy];
    }
    return self;
}

- (NSUInteger)indexOfObject:(id)object inArray:(NSArray *)array {
    CFIndex index = CFArrayBSearchValues((__bridge CFArrayRef)array,
                                         CFRangeMake(0, array.count),
                                         (__bridge const void *)object,
                                         &comparatorFunction,
                                         (__bridge void *)(self));
    if (index >= [array count]) {
        return NSNotFound;
    }
    if ([object isEqual:array[index]]) {
        return index;
    }
    return NSNotFound;
}

@end

static CFComparisonResult comparatorFunction(const void *val1, const void *val2, void *context) {
    id obj1 = (__bridge id)(val1);
    id obj2 = (__bridge id)(val2);
    BinarySearchFinder *self = (__bridge BinarySearchFinder *)(context);
    NSComparator comparator = self.comparator;
    return (CFComparisonResult)comparator(obj1, obj2);
}
