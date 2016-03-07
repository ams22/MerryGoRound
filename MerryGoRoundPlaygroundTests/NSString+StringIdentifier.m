//
//  NSString+StringIdentifier.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 07.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "NSString+StringIdentifier.h"
#import <objc/runtime.h>

static const void *StringIdentifierKey = &StringIdentifierKey;

@implementation NSString (StringIdentifier)

- (NSString *)mgr_stringIdentifier {
    return objc_getAssociatedObject(self, StringIdentifierKey);
}

- (void)setMgr_stringIdentifier:(NSString *)mgr_stringIdentifier {
    objc_setAssociatedObject(self, StringIdentifierKey,
                             mgr_stringIdentifier,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
