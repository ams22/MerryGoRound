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

@end

@implementation MGRListViewController

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

- (IBAction)unwindFromAbout:(UIStoryboardSegue *)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowPhoto"]) {
        MGRSinglePhotoViewController *controller = segue.destinationViewController;
        controller.photoURL = [NSURL URLWithString:@"http://lorempixel.com/400/200/"];
    }
    else if ([segue.identifier isEqualToString:@"ShowFolder"]) {
        MGRFolderCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        DBMetadata *metadata = self.metadata.contents[indexPath.row];

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
    return self.metadata.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBMetadata *metadata = self.metadata.contents[indexPath.row];
    if ([metadata isDirectory]) {
        MGRFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Folder" forIndexPath:indexPath];
        cell.titleLabel.text = metadata.filename;
        return cell;
    }
    else {
        MGRPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo" forIndexPath:indexPath];
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

#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    self.title = metadata.filename;
    self.metadata = metadata;
    [self.tableView reloadData];
}

@end
