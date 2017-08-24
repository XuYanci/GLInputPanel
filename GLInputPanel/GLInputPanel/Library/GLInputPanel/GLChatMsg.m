//
//  GLChatMsg.m
//  66GoodLook
//
//  Created by Yanci on 17/4/26.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import "GLChatMsg.h"

@implementation GLChatMsg

- (instancetype)initWith:(NSObject *)msg
                    type:(GLChatMsgType)type {
    if (self = [super init]) {
        self.msg = msg;
        self.msgType = type;
    }
    return self;
}

+ (instancetype)msgWithText:(NSString *)text {
    return [[GLChatMsg alloc]initWith:text type:GLChatMsgType_Text];
}

+ (instancetype)msgWithEmoj:(NSTextAttachment *)emojTextAttachment {
    return [[GLChatMsg alloc]initWith:emojTextAttachment type:GLChatMsgType_Emoj];
}

+ (instancetype)msgWithImage:(UIImage *)image {
    return [[GLChatMsg alloc]initWith:image type:GLChatMsgType_Image];
}

+ (instancetype)msgWithVideoPath:(NSString *)videoPath {
    return [[GLChatMsg alloc]initWith:videoPath type:GLChatMsgType_Video];
}
@end
