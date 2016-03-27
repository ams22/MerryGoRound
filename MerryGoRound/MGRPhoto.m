//
//  MGRPhoto.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRPhoto.h"

@implementation MGRPhoto

- (instancetype)initWithDropboxID:(NSString *)dropboxID
                             name:(NSString *)name
                             path:(NSString *)path
                   clientModified:(NSDate *)clientModified
                             size:(NSUInteger)size
                            width:(NSUInteger)width
                           height:(NSUInteger)height
                        dateTaken:(NSDate *)dateTaken {
    if (self = [super initWithDropboxID:dropboxID
                                   name:name
                                   path:path
                         clientModified:clientModified
                                   size:size]) {
        _width = width;
        _height = height;
        _dateTaken = [dateTaken copy];
    }
    return self;
}

- (NSUInteger)hash {
    return [super hash] ^ @(self.width).hash ^ @(self.height).hash ^ self.dateTaken.hash;
}

- (BOOL)isEqualToPhoto:(MGRPhoto *)photo {
    if (!photo) {
        return NO;
    }
    return ([self isEqualToFile:photo] &&
            self.width == photo.width &&
            self.height == photo.height &&
            [self.dateTaken isEqual:photo.dateTaken]);
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[MGRPhoto class]]) {
        return NO;
    }
    return [self isEqualToPhoto:(MGRPhoto *)object];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ dimensions:%lux%lu dateTaken:%@",
            [super description],
            (long unsigned)self.width, (long unsigned)self.height,
            self.dateTaken];
}

@end
