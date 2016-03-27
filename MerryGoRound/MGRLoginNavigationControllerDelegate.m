//
//  MGRLoginNavigationControllerDelegate.m
//  MerryGoRound
//
//  Created by Nikolay Morev on 27/03/16.
//  Copyright © 2016 Nikolay Morev. All rights reserved.
//

#import "MGRLoginNavigationControllerDelegate.h"

@implementation MGRLoginNavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    // Отключаем навбар на экране-заставке с кнопкой Войти
    BOOL rootViewController = navigationController.viewControllers.firstObject == viewController;
    [navigationController setNavigationBarHidden:rootViewController animated:animated];
}

@end
