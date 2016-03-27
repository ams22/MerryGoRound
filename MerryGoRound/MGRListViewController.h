//
//  MGRListViewController.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 07.03.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGRDropboxSession.h"

@interface MGRListViewController : UIViewController

@property (nonatomic, strong) MGRDropboxSession *session;
@property (nonatomic, copy) NSString *path;

@end
