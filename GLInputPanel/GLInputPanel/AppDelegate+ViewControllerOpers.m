//
//  AppDelegate+ViewControllerOpers.m
//  FirstRoadNetwork
//
//  Created by Yanci on 16/12/19.
//  Copyright © 2016年 DYLY. All rights reserved.
//

#import "AppDelegate+ViewControllerOpers.h"

@implementation AppDelegate (ViewControllerOpers)


- (UIViewController*)topViewController
{
    return [self topViewControllerWithRootViewController:self.window.rootViewController];
}


- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}



- (UINavigationController *)navigationViewController
{
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        return (UINavigationController *)self.window.rootViewController;
    }
    else if ([self.window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        UIViewController *selectVc = [((UITabBarController *)self.window.rootViewController) selectedViewController];
        if ([selectVc isKindOfClass:[UINavigationController class]])
        {
            return (UINavigationController *)selectVc;
        }
    }
    return nil;
}

- (void)pushViewController:(UIViewController *)viewController {
    [[self navigationViewController] pushViewController:viewController animated:true];
}

- (void)pushViewController:(UIViewController *)viewController withBackTitle:(NSString *)title {

}

- (NSArray *)popToViewController:(UIViewController *)viewController {
    return  [[self navigationViewController]popToViewController:viewController animated:true];
}

- (UIViewController *)popViewController {
    return nil;
}

- (NSArray *)popToRootViewController {
    return  [[self navigationViewController]popToRootViewControllerAnimated:NO];
}

- (void)presentViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)())completion {
    [[self topViewController]presentViewController:vc animated:animated completion:completion];
}

- (void)dismissViewController:(BOOL)animated completion:(void (^)())completion {
    [[self topViewController]dismissViewControllerAnimated:animated completion:completion];
}

- (void)dismissViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)())completion {
    
}



@end
