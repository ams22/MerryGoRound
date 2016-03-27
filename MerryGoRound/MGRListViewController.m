//
//  MGRListViewController.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 07.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRListViewController.h"
#import "MGRSinglePhotoViewController.h"
#import "MGRFolderCell.h"
#import "MGRPhotoCell.h"
#import "MGRDropboxClient.h"
#import "EXTScope.h"
#import "MGRFileMetadata.h"
#import "MGRFolderMetadata.h"

@interface MGRListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (nonatomic, strong) MGRFolderMetadata *folder;
@property (nonatomic, copy) NSArray<__kindof MGRMetadata *> *contents;
@property (nonatomic, strong) MGRDropboxClient *dropbox;

@end

@implementation MGRListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    _refreshControl = refreshControl;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Убираем кнопку Выйти, если находимся не на первом экране, чтобы появилась кнопка Назад
    if (self.navigationController.viewControllers.firstObject != self) {
        self.navigationItem.leftBarButtonItems = nil;
    }

    if (self.session) {
        self.dropbox = [[MGRDropboxClient alloc] initWithSession:self.session];
    }
    [self loadFolderContents];
}

- (IBAction)unwindFromAbout:(UIStoryboardSegue *)sender {
}

- (void)loadFolderContents {
    if (self.path) {
        @weakify(self);
        [self.dropbox listFolderWithPath:self.path resultBlock:
         ^(NSArray<MGRMetadata *> * _Nullable nodes, NSError * _Nullable error) {
             @strongify(self);
             if (nodes) {
                 self.contents = [nodes filteredArrayUsingPredicate:
                                  [NSPredicate predicateWithBlock:^BOOL(MGRMetadata * _Nonnull node,
                                                                        NSDictionary<NSString *,id> * _Nullable bindings) {
                     return ([node isKindOfClass:[MGRFolderMetadata class]] ||
                             ([node isKindOfClass:[MGRFileMetadata class]] &&
                              [(MGRFileMetadata *)node isImage]));
                 }]];
                 [self.refreshControl endRefreshing];
                 [self.tableView reloadData];
             }
         }];

        if (self.path.length > 0) {
            [self.dropbox getMetadataWithPath:self.path resultBlock:
             ^(MGRFolderMetadata * _Nullable node, NSError * _Nullable error) {
                 @strongify(self);
                 if (node) {
                     self.title = node.name;
                     self.folder = node;
                 }
             }];
        }
        else {
            self.title = @"Merry-Go-Round";
        }
    }
}

- (IBAction)refresh:(id)sender {
    [self loadFolderContents];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPhoto"]) {
        MGRPhotoCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        MGRFileMetadata *node = self.contents[indexPath.row];

        MGRSinglePhotoViewController *controller = segue.destinationViewController;
        controller.session = self.session;
        controller.path = node.path;
    }
    else if ([segue.identifier isEqualToString:@"ShowFolder"]) {
        MGRFolderCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        MGRFolderMetadata *node = self.contents[indexPath.row];

        MGRListViewController *controller = segue.destinationViewController;
        controller.session = self.session;
        controller.path = node.path;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MGRMetadata *node = self.contents[indexPath.row];
    if ([node isKindOfClass:[MGRFolderMetadata class]]) {
        MGRFolderMetadata *folder = (MGRFolderMetadata *)node;
        MGRFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Folder" forIndexPath:indexPath];
        cell.titleLabel.text = folder.name;
        cell.subtitleLabel.text = folder.identifier;
        return cell;
    }
    else {
        MGRFileMetadata *file = (MGRFileMetadata *)node;

        MGRPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo" forIndexPath:indexPath];
        if ([file isImage]) {
            cell.thumbnailView.image = [UIImage imageWithContentsOfFile:[self thumbnailPathWithFile:file]];
        }
        else {
            cell.thumbnailView.image = nil;
        }

        NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
        formatter.formattingContext = NSFormattingContextStandalone;
        formatter.countStyle = NSByteCountFormatterCountStyleFile;
        formatter.allowsNonnumericFormatting = YES;
        formatter.adaptive = YES;

        cell.sizeLabel.text = [formatter stringFromByteCount:file.size];

        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Список файлов";
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 44;
}

- (NSString *)thumnailsPath {
    NSString *directory = [NSTemporaryDirectory() stringByAppendingPathComponent:@"thumbnails"];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (![[NSFileManager defaultManager] fileExistsAtPath:directory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    });
    return directory;
}

- (NSString *)thumbnailPathWithFile:(MGRFileMetadata *)file {
    NSString *filename = [file.path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/"].invertedSet];
    NSString *path = [[[self thumnailsPath] stringByAppendingPathComponent:filename] stringByAppendingPathExtension:@"png"];
    return path;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MGRMetadata *node = self.contents[indexPath.row];
    if ([node isKindOfClass:[MGRFileMetadata class]]) {
        MGRFileMetadata *file = (MGRFileMetadata *)node;
        if ([file isImage]) {
            MGRPhotoCell *photoCell = (MGRPhotoCell *)cell;
            if (!photoCell.thumbnailView.image) {
                NSString *thumbnailPath = [self thumbnailPathWithFile:file];
                @weakify(self);
                [self.dropbox getThumbnailWithPath:file.path
                                        saveToPath:thumbnailPath
                                       resultBlock:
                 ^(UIImage *image, NSError *error) {
                     @strongify(self);
                     for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows) {
                         MGRMetadata *cellNode = self.contents[indexPath.row];
                         if ([cellNode isEqual:file]) {
                             MGRPhotoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                             cell.thumbnailView.image = image;
                         }
                     }
                 }];
            }
        }
    }
}

@end
