//
//  AppDelegate+ViewControllerOpers.h
//  FirstRoadNetwork
//
//  Created by Yanci on 16/12/19.
//  Copyright © 2016年 DYLY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"


@interface AppDelegate (ViewControllerOpers)

- (UIViewController*)topViewController;
- (UINavigationController *)navigationViewController;
- (void)pushViewController:(UIViewController *)viewController;
- (void)pushViewController:(UIViewController *)viewController withBackTitle:(NSString *)title;
- (NSArray *)popToViewController:(UIViewController *)viewController;
- (UIViewController *)popViewController;
- (NSArray *)popToRootViewController;
- (void)presentViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)())completion;
- (void)dismissViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)())completion;
- (void)dismissViewController:(BOOL)animated completion:(void (^)())completion;

@end
