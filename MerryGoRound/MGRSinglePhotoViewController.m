//
//  MGRSinglePhotoViewController.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 07.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRSinglePhotoViewController.h"
#import "MGRMetadataViewController.h"
#import "MGRDropboxClient.h"
#import "MGRFileMetadata.h"
#import "EXTScope.h"

@interface MGRSinglePhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *aboutItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *infoItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareItem;

@property (nonatomic, strong) MGRDropboxClient *dropbox;
@property (nonatomic, strong) MGRFileMetadata *file;
@property (nonatomic, strong) UIImage *image;

@end

@implementation MGRSinglePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.shareItem.enabled = !!self.image;

    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.toolbarItems = @[ self.infoItem,
                           flexibleSpace,
                           self.aboutItem ];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.session) {
        self.dropbox = [[MGRDropboxClient alloc] initWithSession:self.session];
    }

    self.photoView.image = nil;
    if (self.path) {
        self.image = [UIImage imageWithContentsOfFile:[self photoPathWithPath:self.path]];
        self.photoView.image = self.image;
        if (!self.image) {
            @weakify(self);
            [self.dropbox downloadPath:self.path
                            saveToPath:[self photoPathWithPath:self.path]
                           resultBlock:
             ^(NSData * _Nullable data, NSError * _Nullable error) {
                 @strongify(self);
                 if (data) {
                     self.image = [UIImage imageWithData:data];
                     self.photoView.image = self.image;
                 }
             }];
        }

        @weakify(self);
        [self.dropbox getMetadataWithPath:self.path resultBlock:^(MGRFileMetadata * _Nullable node, NSError * _Nullable error) {
            @strongify(self);
            self.file = node;
            self.title = node.name;
        }];
    }

    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowMetadata"]) {
        MGRMetadataViewController *controller = segue.destinationViewController;
        controller.session = self.session;
        controller.path = self.file.path;
    }
}

- (NSString *)photoPathWithPath:(NSString *)path {
    NSString *filename = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/"].invertedSet];
    return [[self photosPath] stringByAppendingPathComponent:filename];
}

- (NSString *)photosPath {
    NSString *directory = [NSTemporaryDirectory() stringByAppendingPathComponent:@"photos"];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (![[NSFileManager defaultManager] fileExistsAtPath:directory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    });
    return directory;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.shareItem.enabled = !!_image;
}

- (IBAction)unwindFromAbout:(UIStoryboardSegue *)sender {
}

- (IBAction)unwindFromMetadata:(UIStoryboardSegue *)sender {
}

- (IBAction)openShare:(id)sender {
    if (self.image) {
        UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[ self.image ] applicationActivities:nil];
        [self presentViewController:controller animated:YES completion:nil];
        controller.popoverPresentationController.barButtonItem = sender;
    }
}

@end
