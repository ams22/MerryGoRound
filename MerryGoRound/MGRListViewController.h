//
//  MGRListViewController.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 07.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface MGRListViewController : UIViewController

@property (nonatomic, strong) DBSession *session;
@property (nonatomic, copy) NSString *path;

@end
