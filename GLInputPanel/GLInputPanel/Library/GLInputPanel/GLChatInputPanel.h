//
//  GLChatInputPanel.h
//  66GoodLook
//
//  Created by Yanci on 17/4/20.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import "GLChatInputBaseView.h"

typedef enum : NSUInteger {
    GLChatInputPanelType_Text,
    GLChatInputPanelType_Image,
    GLChatInputPanelType_Video,
} GLChatInputPanelType;

@protocol GLChatInputPanelDataSource <NSObject>
@end

@protocol GLChatInputPanelDelegate <NSObject>

@end

/*!
 @class GLChatInputPanel
 
 @brief The UIView class
 
 @discussion    聊天输入面板
 
 @superclass SuperClass: GLChatInputBaseView\n
 @classdesign    No special design is applied here.
 @coclass    None
 @helps It helps no other classes.
 @helper    No helper exists for this class.
 */
@interface GLChatInputPanel : GLChatInputBaseView
@property (nonatomic,weak) id <GLChatInputPanelDataSource> dataSource;
@property (nonatomic,weak) id <GLChatInputPanelDelegate> delegate;
/**
 重载数据
 */
- (void)reloadData;
- (id)initWithPanelType:(GLChatInputPanelType)panelType;
- (void)setPanelType:(GLChatInputPanelType)panelType;

/**
 显示输入面板
 */
- (void)show;

/**
 隐藏输入面板
 */
- (void)dismiss;



@end



