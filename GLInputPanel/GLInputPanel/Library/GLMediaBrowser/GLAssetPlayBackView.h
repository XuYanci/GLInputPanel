//
//  GLAssetPlayBackView.h
//  GLAssetGridViewController
//
//  Created by Yanci on 17/5/18.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVPlayer;

@interface GLAssetPlayBackView : UIView

@property (nonatomic, strong) AVPlayer* player;

- (void)setPlayer:(AVPlayer*)player;
- (void)setVideoFillMode:(NSString *)fillMode;
@end
