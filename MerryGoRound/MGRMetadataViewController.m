//
//  MGRMetadataViewController.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 20/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRMetadataViewController.h"

@interface MGRMetadataViewController () <DBRestClientDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *filenameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pathLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastModifiedLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *revisionLabel;

@property (nonatomic, strong) DBRestClient *client;
@property (nonatomic, strong) DBMetadata *metadata;

@end

@implementation MGRMetadataViewController

- (void)dealloc {
    [self.client cancelAllRequests];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.session) {
        self.client = [[DBRestClient alloc] initWithSession:self.session];
        self.client.delegate = self;
    }

    self.iconView.image = nil;
    self.thumbnailView.image = nil;
    if (self.path) {
        UIImage *thumbnail = [UIImage imageWithContentsOfFile:[self thumbnailPathWithPath:self.path]];
        self.thumbnailView.image = thumbnail;
        if (!thumbnail) {
            [self.client loadThumbnail:self.path ofSize:@"m" intoPath:[self thumbnailPathWithPath:self.path]];
        }

        [self.client loadMetadata:self.path];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.client cancelAllRequests];
}

- (NSString *)thumbnailPathWithPath:(NSString *)path {
    NSString *filename = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/"].invertedSet];
    return [[self thumbnailsPath] stringByAppendingPathComponent:filename];
}

- (NSString *)thumbnailsPath {
    NSString *directory = [NSTemporaryDirectory() stringByAppendingPathComponent:@"thumbnails"];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (![[NSFileManager defaultManager] fileExistsAtPath:directory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    });
    return directory;
}

#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient *)client loadedThumbnail:(NSString *)destPath {
    self.thumbnailView.image = [UIImage imageWithContentsOfFile:destPath];
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    self.metadata = metadata;
    self.title = [metadata filename];
    self.iconView.image = [UIImage imageNamed:[metadata icon]];
    self.filenameLabel.text = metadata.filename;
    self.pathLabel.text = metadata.path;
    self.lastModifiedLabel.text = [NSString stringWithFormat:@"%@", metadata.lastModifiedDate];
    self.totalSizeLabel.text = [NSString stringWithFormat:@"%lli bytes", metadata.totalBytes];
    self.revisionLabel.text = metadata.rev;
}

@end
