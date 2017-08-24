//
//  AppDelegate.m
//  GLInputPanel
//
//  Created by Yanci on 2017/8/24.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+(AppDelegate*)shareInstance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)saveVideoToLocal {
    NSMutableArray *videoArray = [NSMutableArray arrayWithCapacity:3];
    
    NSArray *movs = [[NSBundle mainBundle] pathsForResourcesOfType:@"mp4" inDirectory:nil];
    [videoArray addObjectsFromArray:movs];
    
    // save video to camera roll
    for (id item in videoArray) {
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(item)) {
            
            // Note：save to camera roll is async, so the later item may copy complete than previous item
            UISaveVideoAtPathToSavedPhotosAlbum(item, self, nil, NULL);
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Only For Test
    [self saveVideoToLocal];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
