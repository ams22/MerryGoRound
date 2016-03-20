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

@interface MGRListViewController () <DBRestClientDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (nonatomic, strong) DBRestClient *client;
@property (nonatomic, strong) DBMetadata *metadata;
@property (nonatomic, copy) NSArray<DBMetadata *> *contents;

@end

@implementation MGRListViewController

- (void)dealloc {
    [self.client cancelAllRequests];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Убираем кнопку Выйти, если находимся не на первом экране, чтобы появилась кнопка Назад
    if (self.navigationController.viewControllers.firstObject != self) {
        self.navigationItem.leftBarButtonItems = nil;
    }

    if (self.session) {
        self.client = [[DBRestClient alloc] initWithSession:self.session];
        self.client.delegate = self;
    }
    if (self.path) {
        [self.client loadMetadata:self.path];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.client cancelAllRequests];
}

- (IBAction)unwindFromAbout:(UIStoryboardSegue *)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPhoto"]) {
        MGRPhotoCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        DBMetadata *metadata = self.contents[indexPath.row];

        MGRSinglePhotoViewController *controller = segue.destinationViewController;
        controller.session = self.session;
        controller.path = [metadata path];
    }
    else if ([segue.identifier isEqualToString:@"ShowFolder"]) {
        MGRFolderCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        DBMetadata *metadata = self.contents[indexPath.row];

        MGRListViewController *controller = segue.destinationViewController;
        controller.session = self.session;
        controller.path = metadata.path;
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
    DBMetadata *metadata = self.contents[indexPath.row];
    if ([metadata isDirectory]) {
        MGRFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Folder" forIndexPath:indexPath];
        cell.titleLabel.text = metadata.filename;

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;

        cell.subtitleLabel.text = [dateFormatter stringFromDate:metadata.lastModifiedDate];

        return cell;
    }
    else {
        MGRPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo" forIndexPath:indexPath];
        if ([metadata thumbnailExists]) {
            cell.thumbnailView.image = [UIImage imageWithContentsOfFile:[self thumbnailPathWithMetadata:metadata]];
        }
        else {
            cell.thumbnailView.image = nil;
        }

        NSByteCountFormatter *formatter = [[NSByteCountFormatter alloc] init];
        formatter.formattingContext = NSFormattingContextStandalone;
        formatter.countStyle = NSByteCountFormatterCountStyleFile;
        formatter.allowsNonnumericFormatting = YES;
        formatter.adaptive = YES;
        
        cell.sizeLabel.text = [formatter stringFromByteCount:[metadata totalBytes]];

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

- (NSString *)thumbnailPathWithMetadata:(DBMetadata *)metadata {
    NSString *filename = [[metadata path] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"/"].invertedSet];
    NSString *path = [[[self thumnailsPath] stringByAppendingPathComponent:filename] stringByAppendingPathExtension:@"png"];
    return path;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    DBMetadata *metadata = self.contents[indexPath.row];
    if ([metadata thumbnailExists]) {
        MGRPhotoCell *photoCell = (MGRPhotoCell *)cell;
        if (!photoCell.thumbnailView.image) {
            [self.client loadThumbnail:metadata.path ofSize:@"m" intoPath:[self thumbnailPathWithMetadata:metadata]];
        }
    }
}

#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    self.title = metadata.filename;
    self.metadata = metadata;
    self.contents = [self.metadata.contents filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(DBMetadata *  _Nonnull metadata, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [metadata isDirectory] || [metadata thumbnailExists];
    }]];
    [self.tableView reloadData];
}

- (void)restClient:(DBRestClient *)client loadedThumbnail:(NSString *)destPath metadata:(DBMetadata *)metadata {
    for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows) {
        DBMetadata *cellMetadata = self.contents[indexPath.row];
        if ([cellMetadata isEqual:metadata]) {
            MGRPhotoCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.thumbnailView.image = [UIImage imageWithContentsOfFile:destPath];
        }
    }
}

@end
