//
//  MGRMetadataViewController.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 20/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRMetadataViewController.h"
#import "MGRDropboxClient.h"
#import "MGRFileMetadata.h"
#import "EXTScope.h"

@interface MGRMetadataViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *filenameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pathLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastModifiedLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *revisionLabel;

@property (nonatomic, strong) MGRDropboxClient *dropbox;
@property (nonatomic, strong) MGRFileMetadata *file;

@end

@implementation MGRMetadataViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.session) {
        self.dropbox = [[MGRDropboxClient alloc] initWithSession:self.session];
    }

    self.iconView.image = nil;
    self.thumbnailView.image = nil;
    if (self.path) {
        NSString *thumnailPath = [self thumbnailPathWithPath:self.path];
        UIImage *thumbnail = [UIImage imageWithContentsOfFile:thumnailPath];
        self.thumbnailView.image = thumbnail;
        if (!thumbnail) {
            @weakify(self);
            [self.dropbox getThumbnailWithPath:self.path
                                    saveToPath:thumnailPath
                                   resultBlock:
             ^(UIImage * _Nullable image, NSError * _Nullable error) {
                 @strongify(self);
                 self.thumbnailView.image = image;
             }];
        }

        @weakify(self);
        [self.dropbox getMetadataWithPath:self.path resultBlock:^(MGRFileMetadata * _Nullable file, NSError * _Nullable error) {
            @strongify(self);
            self.file = file;
            self.title = file.name;
            self.iconView.image = [UIImage imageNamed:@"page_white"];
            self.filenameLabel.text = file.name;
            self.pathLabel.text = file.path;
            self.lastModifiedLabel.text = [NSString stringWithFormat:@"%@", file.clientModified];
            self.totalSizeLabel.text = [NSString stringWithFormat:@"%lu bytes", (unsigned long)file.size];
            self.revisionLabel.text = file.identifier;
        }];
    }
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

@end
