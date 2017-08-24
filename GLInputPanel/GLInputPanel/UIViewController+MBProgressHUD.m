/*
 *  UIViewController+MBProgressHUD.m
 *
 *  Created by Adam Duke on 10/20/11.
 *  Copyright 2015 Adam Duke All rights reserved.
 *
 */

#import "MBProgressHUD.h"
#import "UIViewController+MBProgressHUD.h"
#import <objc/runtime.h>

/* This key is used to dynamically create an instance variable
 * within the MBProgressHUD category using objc_setAssociatedObject
 */
const char *progressHUDKey = "progressHUDKey";

/* This key is used to dynamically create an instance variable
 * within the MBProgressHUD category using objc_setAssociatedObject
 */
const char *finishedHandlerKey = "finishedHandlerKey";

/*************************************************************/
// 2016.07.05       Fix BProgressHUD Crash


@interface UIViewController (MBProgressHUD_Private) <MBProgressHUDDelegate>

@property (nonatomic, retain) MBProgressHUD *progressHUD;
@property (nonatomic, copy) HUDFinishedHandler finishedHandler;

@end

@implementation UIViewController (MBProgressHUD)

- (MBProgressHUD *)progressHUD
{
    MBProgressHUD *hud = objc_getAssociatedObject(self, progressHUDKey);
    if(!hud)
    {
        UIView *hudSuperView = self.view;
        hud = [[MBProgressHUD alloc] initWithView:hudSuperView];
        hud.detailsLabelFont = [UIFont systemFontOfSize:18];
        hud.cornerRadius = 4.0;
        hud.labelFont = [UIFont systemFontOfSize:18];
        hud.dimBackground = NO;
        hud.removeFromSuperViewOnHide = YES;
        [hudSuperView addSubview:hud];
        self.progressHUD = hud;
    }
    return hud;
}

- (void)setProgressHUD:(MBProgressHUD *)progressHUD
{
    objc_setAssociatedObject(self, progressHUDKey, progressHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HUDFinishedHandler)finishedHandler
{
    HUDFinishedHandler block = objc_getAssociatedObject(self, finishedHandlerKey);
    return block;
}

- (void)setFinishedHandler:(HUDFinishedHandler)completionBlock
{
    objc_setAssociatedObject(self, finishedHandlerKey, completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)_showHUDWithMessage:(NSString *)message
{
    self.progressHUD.labelText = message;
    if(self.progressHUD.taskInProgress)
    {
        return;
    }
    self.progressHUD.taskInProgress = YES;
    [self.progressHUD show:YES];
}

- (void)showHUD
{
    [self _showHUDWithMessage:nil];
}

- (void)showHUDWithMessage:(NSString *)message
{
    [self _showHUDWithMessage:message];
}



- (void)hideHUD
{
    if(!self.progressHUD.taskInProgress)
    {
        return;
    }
    
    if(self.finishedHandler)
    {
        self.finishedHandler();
        self.finishedHandler = nil;
    }
    
    self.progressHUD.taskInProgress = NO;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
}

- (void)hideHUDWithCompletionMessage:(NSString *)message
{
    
    if (message.length == 0) {
        [self hideHUD];return;
    }

    self.progressHUD.labelText = nil;
    self.progressHUD.detailsLabelText = message;
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.margin = 10.0;
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:2.5];
}

- (void)hideHUDWithCompletionMessage:(NSString *)message finishedHandler:(HUDFinishedHandler)finishedHandler
{
    self.finishedHandler = finishedHandler;
    [self hideHUDWithCompletionMessage:message];
}


- (void)showHintHudWithMessage:(NSString *)message
{
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.detailsLabelText = message;
    
    self.progressHUD.margin = 10.f;
    if(self.progressHUD.taskInProgress)
    {
        return;
    }
    
    [self.progressHUD show:YES];
    self.progressHUD.taskInProgress = YES;
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:2.5];
}

- (void)showTextHUDWithMessage:(NSString *)message {
    self.progressHUD.labelText = message;
    self.progressHUD.mode = MBProgressHUDModeText;
    if(self.progressHUD.taskInProgress)
    {
        return;
    }
    self.progressHUD.taskInProgress = YES;
    [self.progressHUD show:YES];
}

@end
