//
//  MGRSinglePhotoViewController.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 07.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRSinglePhotoViewController.h"
#import "MGRMetadataViewController.h"

@interface MGRSinglePhotoViewController () <DBRestClientDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *aboutItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *infoItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareItem;

@property (nonatomic, strong) DBRestClient *client;
@property (nonatomic, strong) DBMetadata *metadata;
@property (nonatomic, strong) UIImage *image;

@end

@implementation MGRSinglePhotoViewController

- (void)dealloc {
    [self.client cancelAllRequests];
}

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
        self.client = [[DBRestClient alloc] initWithSession:self.session];
        self.client.delegate = self;
    }

    self.photoView.image = nil;
    if (self.path) {
        self.image = [UIImage imageWithContentsOfFile:[self photoPathWithPath:self.path]];
        self.photoView.image = self.image;
        if (!self.image) {
            [self.client loadFile:self.path intoPath:[self photoPathWithPath:self.path]];
        }

        [self.client loadMetadata:self.path];
    }

    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.client cancelAllRequests];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowMetadata"]) {
        MGRMetadataViewController *controller = segue.destinationViewController;
        controller.session = self.session;
        controller.path = [self.metadata path];
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

- (IBAction)openInfo:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)openShare:(id)sender {
    if (self.image) {
        UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[ self.image ] applicationActivities:nil];
        [self presentViewController:controller animated:YES completion:nil];
        controller.popoverPresentationController.barButtonItem = sender;
    }
}

#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)destPath {
    self.image = [UIImage imageWithContentsOfFile:destPath];
    self.photoView.image = self.image;
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    self.metadata = metadata;
    self.title = [metadata filename];
}

@end
