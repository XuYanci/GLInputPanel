//
//  GLChatMsg.h
//  66GoodLook
//
//  Created by Yanci on 17/4/26.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    GLChatMsgType_Text,
    GLChatMsgType_Emoj,
    GLChatMsgType_Image,
    GLChatMsgType_Video,
    GLChatMsgType_Other,
} GLChatMsgType;

@interface GLChatMsg : NSObject

@property (nonatomic,assign) GLChatMsgType msgType; /** message type */
@property (nonatomic,strong) NSObject *msg;  /* message body , decide by msgType */

- (instancetype)initWith:(NSObject *)msg type:(GLChatMsgType)type;
+ (instancetype)msgWithText:(NSString *)text;
+ (instancetype)msgWithEmoj:(NSTextAttachment *)emojTextAttachment;
+ (instancetype)msgWithImage:(UIImage *)image;
+ (instancetype)msgWithVideoPath:(NSString *)videoPath;

@end




