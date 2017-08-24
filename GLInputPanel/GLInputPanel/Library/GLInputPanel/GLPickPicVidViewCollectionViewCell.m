//
//  GLPickPictureViewCollectionView.m
//  66GoodLook
//
//  Created by Yanci on 17/4/28.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import "GLPickPicVidViewCollectionViewCell.h"
static NSUInteger const kPickMaxPictureCount = 4; /* 允许选择相片最大数 */
static NSUInteger const kPickMaxVideoCount = 1;   /* 允许选择视频最大数 */

@interface GLPickPicVidViewCollectionViewCell()
@property (nonatomic,strong) UIImageView *pictureImageView;
@property (nonatomic,strong) UIButton *tickBtn;
@end

@implementation GLPickPicVidViewCollectionViewCell {
    BOOL _needsReload;  /*! 需要重载 */
    struct {
        unsigned numberOfSelectedItems:1;
    }_datasourceHas;    /*! 数据源存在标识 */
    struct {
        unsigned didSelected:1;
        unsigned didUnSelected:1;
    }_delegateHas;      /*! 数据委托存在标识 */
}

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    
    if (self.pickPicVidCVType == GLPickPicVidCVType_TakePic) {
        self.tickBtn.hidden = YES;
        [self.pictureImageView sizeWith:CGSizeMake(30, 30)];
        [self.pictureImageView alignParentCenter];
        self.contentView.backgroundColor = [UIColor yellowColor];
    }
    else if(self.pickPicVidCVType == GLPickPicVidCVType_TakeVid) {
        self.tickBtn.hidden = YES;
        [self.pictureImageView sizeWith:CGSizeMake(30, 30)];
        [self.pictureImageView alignParentCenter];
        self.contentView.backgroundColor = [UIColor yellowColor];
    }
    else {
        self.tickBtn.hidden = NO;
        self.pictureImageView.frame = self.contentView.bounds;
        [self.tickBtn sizeWith:CGSizeMake(30, 30)];
        [self.tickBtn alignParentRightWithMargin:10.0];
        [self.tickBtn alignParentTopWithMargin:10.0];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - datasource
#pragma mark - delegate
#pragma mark - user events
- (void)tick:(id)sender {
    if (_datasourceHas.numberOfSelectedItems && !self.tickBtn.selected) {
        NSUInteger count = [_dataSource glPickPicVideViewCVCNumberOfSelectedItems];
        if (count > kPickMaxPictureCount - 1 && self.pickPicVidCVType == GLPickPicVidCVType_Pic) {
            [MBProgressHUD showHintHudWithMessage:@"select items count > max count"]; return;
        }
        else if(count > kPickMaxVideoCount - 1 && self.pickPicVidCVType == GLPickPicVidCVType_Vid) {
            [MBProgressHUD showHintHudWithMessage:@"select items count > max count"];return;
        }
    }
    
    self.tickBtn.selected = !self.tickBtn.selected;
    if (self.tickBtn.selected &&_delegateHas.didSelected) {
        [_delegate glPickPicVidViewCVCDidSelected:self];
    }
    else if(!self.tickBtn.selected && _delegateHas.didUnSelected) {
        [_delegate glPickPicVidViewCVCDidUnSelected:self];
    }
}

#pragma mark - functions
- (void)commonInit {
    [self.contentView addSubview:self.pictureImageView];
    [self.contentView addSubview:self.tickBtn];
  
    [self.tickBtn setImage:[UIImage imageNamed:@"ft_pic_icon_wrong"] forState:UIControlStateNormal];
    [self.tickBtn setImage:[UIImage imageNamed:@"ft_pic_icon_dui"] forState:UIControlStateSelected];
    [self.tickBtn addTarget:self action:@selector(tick:) forControlEvents:UIControlEventTouchUpInside];
    [self setNeedsReload];
}


- (void)setDataSource:(id<GLPickPicVidViewCollectionViewCellDataSource>)dataSource {
    _dataSource = dataSource;
    if ([dataSource respondsToSelector:@selector(glPickPicVideViewCVCNumberOfSelectedItems)]) {
        _datasourceHas.numberOfSelectedItems = 1;
    }
}

- (void)setDelegate:(id<GLPickPicVidViewCollectionViewCellDelegate>)delegate {
    _delegate = delegate;
    
    if ([delegate respondsToSelector:@selector(glPickPicVidViewCVCDidSelected:)]) {
        _delegateHas.didSelected = 1;
    }
    
    if ([delegate respondsToSelector:@selector(glPickPicVidViewCVCDidUnSelected:)]) {
        _delegateHas.didUnSelected = 1;
    }
}

- (void)setNeedsReload {
    _needsReload = YES;
    [self setNeedsLayout];
}
- (void)_reloadDataIfNeeded {
    if (_needsReload) {
        [self reloadData];
    }
}
- (void)reloadData {}
- (void)setFrame:(CGRect)frame { [super setFrame:frame];}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self.pictureImageView setImage:_image];
}

- (void)setPickPicVidCVType:(GLPickPicVidCVType)pickPicVidCVType {
    _pickPicVidCVType = pickPicVidCVType;
    [self setNeedsReload];
}


- (void)setTickBtnSelected:(BOOL)selected {
    self.tickBtn.selected = selected;
}

#pragma mark - notification
#pragma mark - getter and setter
- (UIImageView *)pictureImageView {
    if (!_pictureImageView) {
        _pictureImageView = [[UIImageView alloc]init];
        _pictureImageView.backgroundColor = [UIColor whiteColor];
    }
    return _pictureImageView;
}

- (UIButton *)tickBtn {
    if (!_tickBtn) {
        _tickBtn = [[UIButton alloc]init];
    }
    return _tickBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
