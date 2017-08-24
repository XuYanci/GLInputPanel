//
//  MBProgressHUD+GL.m
//  66GoodLook
//
//  Created by Yanci on 17/5/3.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import "MBProgressHUD+GL.h"

@implementation MBProgressHUD (GL)

+ (void)showHintHudWithMessage:(NSString *)message {
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = nil;
    hud.detailsLabelText = message;
    hud.mode = MBProgressHUDModeText;
    hud.labelFont = [UIFont systemFontOfSize:18];
    hud.detailsLabelFont = [UIFont systemFontOfSize:18];
    hud.cornerRadius = 4.0;
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = NO;
    hud.animationType = MBProgressHUDAnimationZoom;
    [hud hide:YES afterDelay:1.0];
}

@end
