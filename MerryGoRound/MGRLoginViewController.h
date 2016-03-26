//
//  MGRLoginViewController.h
//  MerryGoRound
//
//  Created by Nikolay Morev on 27.02.16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMOAuth2Authentication.h"

@interface MGRLoginViewController : UIViewController 

@property (strong, nonatomic) GTMOAuth2Authentication *authentication;

@end

