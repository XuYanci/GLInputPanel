//
//  GLEmojView.h
//  66GoodLook
//
//  Created by Yanci on 17/4/20.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLChatInputAbleView.h"
#import "GLChatInputBaseView.h"
@protocol GLPickEmojViewDataSource <NSObject>
@end

@protocol GLPickEmojViewDelegate <NSObject>
- (void)glPickEmojView:(id)sender didPickEmoj:(UIImage *)emojImage;
- (void)glPickEmojView:(id)sender didPickDel:(UIImage *)delImage;
@end

/*!
 @class GLPickEmojView
 
 @brief The UIView class
 
 @discussion    表情选择器
 
 @superclass SuperClass: UIView\n
 @classdesign    No special design is applied here.
 @coclass    None
 @helps It helps no other classes.
 @helper    No helper exists for this class.
 */
@interface GLPickEmojView : UIView
@property (nonatomic)id <GLPickEmojViewDelegate>delegate;
- (CGFloat)contentHeight;
@end
