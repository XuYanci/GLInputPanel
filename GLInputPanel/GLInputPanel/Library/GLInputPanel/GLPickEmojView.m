//
//  GLEmojView.m
//  66GoodLook
//
//  Created by Yanci on 17/4/20.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import "GLPickEmojView.h"
#import "GLPickEmojCollectionViewFlowLayout.h"
#import "GLChatMsg.h"

@interface GLCustomerCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UIImage *image;
@end

@implementation GLCustomerCollectionViewCell {
    @protected
    UIImageView *_imageView;
    BOOL _setupSubViews;
}

- (void)setImage:(UIImage *)image {
    if (!_setupSubViews) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(5);
            make.top.mas_equalTo(self.mas_top).offset(5);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
            make.right.mas_equalTo(self.mas_right).offset(-5);
        }];
        self.backgroundColor = [UIColor whiteColor];
        _setupSubViews = YES;
    }
    _imageView.image = image;
}

@end


// 宏定义
#define kCustomerCollectionViewCellIdentifier    @"CustomerCollectionViewCellIdentifier"
#define KCollectionViewBackgroundColor          [UIColor whiteColor]
#define kViewBackgroundColor                    [UIColor whiteColor]

static const NSUInteger kEmojPageCount = 3;
static const NSUInteger kEmojCountPerPage = 21;
static const CGFloat    kEmojHeight = 40.0;

@interface GLPickEmojView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) GLPickEmojCollectionViewFlowLayout *collectionViewFlowLayout;
@end

@implementation GLPickEmojView {
    BOOL _needsReload;  /*! 需要重载 */
    
    struct {
        
    }_datasourceHas;    /*! 数据源存在标识 */
    
    struct {
        
    }_delegateHas;      /*! 数据委托存在标识 */
    
    
    NSArray *_emojPngArray;
}

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    [self _reloadDataIfNeeded];
    [self _layoutSubviews];
    [super layoutSubviews];
}

#pragma mark - datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kEmojPageCount * kEmojCountPerPage;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GLCustomerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCustomerCollectionViewCellIdentifier forIndexPath:indexPath];
    NSString *cellImagePath = [_emojPngArray objectAtIndex:indexPath.row];
    cell.image = [UIImage imageNamed:cellImagePath];
    return cell;
}

#pragma mark - delegate
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Select IndexPath Row = %ld",(long)indexPath.row);
    
    NSString *cellImagePath = [_emojPngArray objectAtIndex:indexPath.row];
    UIImage *emojImage = [UIImage imageNamed:cellImagePath];
    
    
    if ([cellImagePath isEqualToString:@"sl3_btn_shan_d"]) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(glPickEmojView:didPickDel:)]) {
            [self.delegate glPickEmojView:self didPickDel:nil];
        }
    }
    else if (self.delegate != nil
        && [self.delegate respondsToSelector:@selector(glPickEmojView:didPickEmoj:)]) {
        [self.delegate glPickEmojView:self didPickEmoj:emojImage];
    }
    
    
    
}
#pragma mark - user events
#pragma mark - functions

- (CGFloat)contentHeight { return kEmojHeight * 3 + 20.0;}

- (void)commonInit {
    [self addSubview:self.collectionView];
    [self setNeedsReload];
    self.backgroundColor =  kViewBackgroundColor;
    
    _emojPngArray = @[
                      @"Expression.bundle/661",
                      @"Expression.bundle/662.png",
                      @"Expression.bundle/663.png",
                      @"Expression.bundle/664.png",
                      @"Expression.bundle/665.png",
                      @"Expression.bundle/666.png",
                      @"Expression.bundle/667.png",
                      @"Expression.bundle/668.png",
                      @"Expression.bundle/669.png",
                      @"Expression.bundle/6610.png",
                      @"Expression.bundle/6611.png",
                      @"Expression.bundle/6612.png",
                      @"Expression.bundle/6613.png",
                      @"Expression.bundle/6614.png",
                      @"Expression.bundle/6615.png",
                      @"Expression.bundle/6616.png",
                      @"Expression.bundle/6617.png",
                      @"Expression.bundle/6618.png",
                      @"Expression.bundle/6619.png",
                      @"Expression.bundle/6620.png",
                      @"sl3_btn_shan_d",
                      @"Expression.bundle/6621.png",
                      @"Expression.bundle/6622.png",
                      @"Expression.bundle/6623.png",
                      @"Expression.bundle/6624.png",
                      @"Expression.bundle/6625.png",
                      @"Expression.bundle/6626.png",
                      @"Expression.bundle/6627.png",
                      @"Expression.bundle/6628.png",
                      @"Expression.bundle/6629.png",
                      @"Expression.bundle/6630.png",
                      @"Expression.bundle/6631.png",
                      @"Expression.bundle/6632.png",
                      @"Expression.bundle/6633.png",
                      @"Expression.bundle/6634.png",
                      @"Expression.bundle/6635.png",
                      @"Expression.bundle/6636.png",
                      @"Expression.bundle/6637.png",
                      @"Expression.bundle/6638.png",
                      @"Expression.bundle/6639.png",
                      @"Expression.bundle/6640.png",
                      @"sl3_btn_shan_d",
                      @"Expression.bundle/6641.png",
                      @"Expression.bundle/6642.png",
                      @"",
                      @"Expression.bundle/6643.png",
                      @"Expression.bundle/6644.png",
                      @"",
                      @"Expression.bundle/6645.png",
                      @"",
                      @"",
                      @"Expression.bundle/6646.png",
                      @"",
                      @"",
                      @"Expression.bundle/6647.png",
                      @"",
                      @"",
                      @"Expression.bundle/6648.png",
                      @"",
                      @"",
                      @"Expression.bundle/6649.png",
                      @"",
                      @"sl3_btn_shan_d",
                      ];
}

- (void)setDataSource {}

- (void)setDelegate {}

- (void)setNeedsReload {
    _needsReload = YES;
    [self setNeedsLayout];
}

- (void)_reloadDataIfNeeded {
    if (_needsReload) {
        [self reloadData];
    }
}

- (void)_layoutSubviews {
    CGRect rect = self.bounds;
    rect.size.height = self.bounds.size.height - 20;
    self.collectionView.frame = rect;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];

}

#pragma mark - notification
#pragma mark - getter and setter

- (GLPickEmojCollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        
    }
    return _collectionViewFlowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero
                                            collectionViewLayout:[self flowLayout:0
                                                                     paddingRight:0
                                                                       paddingTop:0
                                                                    paddingBottom:0
                                                                       cellHeight:kEmojHeight
                                                                      cellSpacing:0
                                                                        cellCount:7]];
        _collectionView.showsHorizontalScrollIndicator = FALSE;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = KCollectionViewBackgroundColor;
        [_collectionView registerClass:[GLCustomerCollectionViewCell class]
            forCellWithReuseIdentifier:kCustomerCollectionViewCellIdentifier];
        
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout:(CGFloat)left
                              paddingRight:(CGFloat)right
                                paddingTop:(CGFloat)top
                             paddingBottom:(CGFloat)bottom
                                cellHeight:(CGFloat)height
                               cellSpacing:(CGFloat)cellSpacing cellCount:(NSUInteger)cellCount{
    UICollectionViewFlowLayout *_flowLayout = nil;
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemwidth = floor((([UIScreen mainScreen].bounds.size.width - right - left - ((cellSpacing ) * (cellCount - 1) )) / cellCount)) ;
        CGFloat itemheight = height;
        _flowLayout.itemSize = CGSizeMake(itemwidth, itemheight);
        _flowLayout.sectionInset = UIEdgeInsetsMake(top,
                                                    left,
                                                    bottom,
                                                    right);
        _flowLayout.minimumLineSpacing = (cellSpacing);
        _flowLayout.minimumInteritemSpacing = (cellSpacing);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
