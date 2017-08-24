//
//  GLAlreadyPickCollectionViewCell.m
//  66GoodLook
//
//  Created by Yanci on 17/5/2.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import "GLAlreadyPickPicVidCollectionViewCell.h"

@interface GLAlreadyPickPicVidCollectionViewCell()
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation GLAlreadyPickPicVidCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _imageView = [[UIImageView alloc]init];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)setImage:(UIImage *)image {
    [_imageView setImage:image];
}

@end
