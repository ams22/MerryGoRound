//
//  DynamicMethodObject.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 07.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "DynamicMethodObject.h"
#import <objc/runtime.h>

static void dynamicInstanceMethodIMP(id self, SEL _cmd);
static void dynamicClassMethodIMP(id self, SEL _cmd);

@implementation DynamicMethodObject

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (strncmp(sel_getName(sel), "call", 4) == 0) {
        class_addMethod(self, sel, (IMP)dynamicInstanceMethodIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    if (strncmp(sel_getName(sel), "call", 4) == 0) {
        class_addMethod(object_getClass(self), sel, (IMP)dynamicClassMethodIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

@end

static void dynamicInstanceMethodIMP(id self, SEL _cmd) {
    NSLog(@"instance %@ %@", self, NSStringFromSelector(_cmd));
}

static void dynamicClassMethodIMP(id self, SEL _cmd) {
    NSLog(@"class %@ %@", self, NSStringFromSelector(_cmd));
}
