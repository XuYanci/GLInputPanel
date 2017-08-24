//
//  GLChatInputToolBar.h
//  66GoodLook
//
//  Created by Yanci on 17/4/20.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import "GLChatInputBaseView.h"

typedef enum : NSUInteger {
    GLChatInputToolBarType_Default,
    GLChatInputToolBarType_Emoj,
    GLChatInputToolBarType_Pic,
    GLChatInputToolBarType_Video,
} GLChatInputToolBarType;


@protocol GLChatInputToolBarDataSource <NSObject>
@end

@protocol GLChatInputToolBarDelegate <NSObject>

- (void)glChatInputToolBar:(id)sender didSelectToolBarType:(GLChatInputToolBarType)toolBarType;

@end


/*!
 @class GLChatInputToolBar
 
 @brief The UIView class
 
 @discussion    聊天输入工具框
 
 @superclass SuperClass: GLChatInputBaseView\n
 @classdesign    No special design is applied here.
 @coclass    None
 @helps It helps no other classes.
 @helper    No helper exists for this class.
 */
@interface GLChatInputToolBar : GLChatInputBaseView
@property (nonatomic,weak) id<GLChatInputToolBarDataSource>dataSource;
@property (nonatomic,weak) id<GLChatInputToolBarDelegate>delegate;

/**
 重载数据
 */
- (void)reloadData;


/**
 初始化

 @param barType 输入类型
 @return 控件
 */
- (id)initWithBarType:(GLChatInputToolBarType)barType;

/**
 设置输入类型

 @param barType 输入类型
 */
- (void)setBarType:(GLChatInputToolBarType)barType;

/**
 是否编辑状态

 @return 是否编辑状态
 */
- (BOOL)isEditing;

- (void)beginOpenText;
- (void)beginOpenPhoto;
- (void)beginOpenVideo;
 
@end
