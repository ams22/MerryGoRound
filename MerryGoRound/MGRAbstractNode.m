//
//  MGRAbstractNode.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRAbstractNode.h"

@implementation MGRAbstractNode

@synthesize dropboxID = _dropboxID;
@synthesize name = _name;
@synthesize path = _path;

- (instancetype)initWithDropboxID:(NSString *)dropboxID
                             name:(NSString *)name
                             path:(NSString *)path {
    NSParameterAssert(dropboxID);
    NSParameterAssert(name);
    NSParameterAssert(path);
    if (!(dropboxID && name && path)) {
        return nil;
    }
    if (self = [super init]) {
        _dropboxID = [dropboxID copy];
        _name = [name copy];
        _path = [path copy];
    }
    return self;
}

- (NSUInteger)hash {
    return self.dropboxID.hash ^ self.name.hash ^ self.path.hash;
}

- (BOOL)isEqualToNode:(MGRAbstractNode *)node {
    if (!node) {
        return NO;
    }
    return ([self.dropboxID isEqualToString:node.dropboxID] &&
            [self.name isEqualToString:node.name] &&
            [self.path isEqualToString:node.path]);
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[MGRAbstractNode class]]) {
        return NO;
    }
    return [self isEqualToNode:(MGRAbstractNode *)object];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ dropboxID:%@ name:%@ path:%@",
            [super description],
            self.dropboxID,
            self.name,
            self.path];
}

@end