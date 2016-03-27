//
//  MGRNodesManager.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 06.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRNodesManager.h"
#import "MGRDropboxParser.h"

@interface MGRNodesManager ()

@property (nonatomic, readwrite, copy) NSArray<MGRMetadata *> *nodes;

@end

@implementation MGRNodesManager

- (instancetype)init {
    if (self = [super init]) {
        _nodes = @[];
    }
    return self;
}

- (void)setNodes:(NSArray<MGRMetadata *> *)nodes {
    _nodes = [nodes copy];
    [self.delegate managerDidUpdateNodes:self];
}

- (void)refresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MGRDropboxParser *parser = [[MGRDropboxParser alloc] init];
        self.nodes = [parser nodesFromJSONObject:[self listFolderJSONObject] error:NULL];
    });
}

- (id)listFolderJSONObject {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *URL = [bundle URLForResource:@"list_folder.json" withExtension:nil];
    NSData *data = [[NSData alloc] initWithContentsOfURL:URL];
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    return object;
}

@end
