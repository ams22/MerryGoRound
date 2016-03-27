//
//  MGRFolder.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRFolder.h"

@implementation MGRFolder

- (instancetype)initWithDropboxID:(NSString *)dropboxID
                             name:(NSString *)name
                             path:(NSString *)path {
    return [self initWithDropboxID:dropboxID name:name path:path childNodes:@[]];
}

- (instancetype)initWithDropboxID:(NSString *)dropboxID
                             name:(NSString *)name
                             path:(NSString *)path
                       childNodes:(NSArray<id<MGRNode>> *)childNodes {
    if (self = [super initWithDropboxID:dropboxID name:name path:path]) {
        _childNodes = [childNodes copy];
    }
    return self;
}

- (BOOL)isDirectory {
    return YES;
}

- (NSUInteger)hash {
    return [super hash] ^ self.childNodes.hash;
}

- (BOOL)isEqualToFolder:(MGRFolder *)folder {
    if (!folder) {
        return NO;
    }
    return ([self isEqualToNode:folder] &&
            [self.childNodes isEqualToArray:folder.childNodes]);
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[MGRFolder class]]) {
        return NO;
    }
    return [self isEqualToFolder:(MGRFolder *)object];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ childNodes:%@",
            [super description],
            self.childNodes];
}

@end
