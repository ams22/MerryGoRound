//
//  MGRFile.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRFile.h"

@implementation MGRFile

- (instancetype)initWithDropboxID:(NSString *)dropboxID
                             name:(NSString *)name
                             path:(NSString *)path
                   clientModified:(NSDate *)clientModified
                             size:(NSUInteger)size {
    NSParameterAssert(clientModified);
    if (!clientModified) {
        return nil;
    }
    if (self = [super initWithDropboxID:dropboxID
                                   name:name
                                   path:path]) {
        _clientModified = [clientModified copy];
        _size = size;
    }
    return self;
}

- (BOOL)isDirectory {
    return NO;
}

- (BOOL)isImage {
    NSSet<NSString *> *imageExtensions = [NSSet setWithObjects:@"jpg", @"jpeg", @"png", @"tiff", @"tif", @"gif", @"bmp", nil];
    return [imageExtensions containsObject:self.path.pathExtension.lowercaseString];
}

- (NSUInteger)hash {
    return [super hash] ^ self.clientModified.hash ^ @(self.size).hash;
}

- (BOOL)isEqualToFile:(MGRFile *)file {
    if (!file) {
        return NO;
    }
    return ([self isEqualToNode:file] &&
            [self.clientModified isEqualToDate:file.clientModified] &&
            self.size == file.size);
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[MGRFile class]]) {
        return NO;
    }
    return [self isEqualToFile:(MGRFile *)object];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ clientModified:%@ size:%lu",
            [super description],
            self.clientModified,
            (long unsigned)self.size];
}

@end
