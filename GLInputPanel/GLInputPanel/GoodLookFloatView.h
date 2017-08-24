//
//  GoodLookFloatView.h
//  66GoodLook
//
//  Created by Yanci on 17/4/18.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GLEditText,         /** 文本 */
    GLEditEmoj,         /** 表情 */
    GLEditUploadPic,    /** 上传图片 */
    GLEditUploadVideo,  /** 上传视频 */
} GLEditType;           /** 编辑类型 */

@protocol GoodLookFloatViewDataSource <NSObject>
@end

@protocol GoodLookFloatViewDelegate <NSObject>

/**
 悬浮点击编辑类型
 
 @param sender 悬浮视图
 @param editType 编辑类型 (评论,上传图片,上传视频)
 */
- (void)floatView:(id)sender didPickEdit:(GLEditType)editType;
@end

/**
 悬浮视图
 用于发表文字,视频,图片等
 */
@interface GoodLookFloatView : UIView
@property (nonatomic,weak)id <GoodLookFloatViewDataSource>dataSource;
@property (nonatomic,weak)id <GoodLookFloatViewDelegate>delegate;
@property (nonatomic,assign)BOOL naviBarHidden;

/**
 重载数据
 */
- (void)reloadData;

/** 重置位置 */
- (void)resetPosition;
/** 更新位置 */
- (void)updatePosition:(CGPoint)point;

@end
