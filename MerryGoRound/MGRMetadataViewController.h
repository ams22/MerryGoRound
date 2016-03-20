//
//  MGRMetadataViewController.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 20/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface MGRMetadataViewController : UIViewController

@property (nonatomic, strong) DBSession *session;
@property (nonatomic, copy) NSString *path;

@end
