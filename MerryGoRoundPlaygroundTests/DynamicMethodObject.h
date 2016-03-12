//
//  DynamicMethodObject.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 07.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicMethodObject : NSObject

@end

@interface DynamicMethodObject (DynamicMethods)

- (void)callHelloWorld;

@end
