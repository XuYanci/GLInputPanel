//
//  GLChatInputTextView.m
//  66GoodLook
//
//  Created by Yanci on 17/4/26.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import "GLChatInputTextView.h"

@interface GLChatInputTextView ()

@end

@implementation GLChatInputTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)textStorage:(NSTextStorage *)textStorage
  didProcessEditing:(NSTextStorageEditActions)editedMask
              range:(NSRange)editedRange
     changeInLength:(NSInteger)delta {
    
    __block NSMutableDictionary *dict;
    [textStorage enumerateAttributesInRange:editedRange
                                    options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                                 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs,
                                              NSRange range,
                                              BOOL * _Nonnull stop)
     {
         dict = [[NSMutableDictionary alloc]initWithDictionary:attrs];
         [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key,
                                                   id  _Nonnull obj,
                                                   BOOL * _Nonnull stop) {
             if ([[key description] isEqualToString:NSAttachmentAttributeName]) {
                 NSTextAttachment *attachment = obj;
                 attachment.bounds = CGRectMake(0, -3, 15, 15);
             }
         }];
     }];
}


@end
