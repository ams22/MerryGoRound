//
//  ForwardingObject.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 07.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "ForwardingObject.h"
#import "DynamicMethodObject.h"

@interface ForwardingObject ()
@property (nonatomic, strong) DynamicMethodObject *object;
@end

@implementation ForwardingObject

- (instancetype)init {
    if (self = [super init]) {
        _object = [[DynamicMethodObject alloc] init];
    }
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _object;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [_object methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:_object];
}

@end
