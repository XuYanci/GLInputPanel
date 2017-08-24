//
//  GLPickPicVidThumbnailCollectionView.m
//  66GoodLook
//
//  Created by Yanci on 17/5/1.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import "GLPickPicVidThumbnailCollectionView.h"
#import "GLAlreadyPickPicVidCollectionViewCell.h"


/**宏定义 */
static NSString *const kPickPicVidThumbnailCollectionCellIdentifier = @"kPickPicVidThumbnailCollectionCellIdentifier";

@interface GLPickPicVidThumbnailCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *collectionView;
@end


@implementation GLPickPicVidThumbnailCollectionView {
    BOOL _needsReload;  /*! 需要重载 */
    struct {
        unsigned numberOfItems:1;
        unsigned imageForIndex:1;
    }_datasourceHas;    /*! 数据源存在标识 */
    struct {
        unsigned didSelectAtIndex:1;
    }_delegateHas;      /*! 数据委托存在标识 */
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
        [self setNeedsReload];
    }
    return self;
}

- (void)layoutSubviews {
    [self _reloadDataIfNeeded];
    self.collectionView.frame = self.bounds;
    [super layoutSubviews];
}

#pragma mark - datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_datasourceHas.numberOfItems) {
        return [_dataSource glPickPicVidThumbnailCollectionViewNumberOfItems:self];
    }
    return 0;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GLAlreadyPickPicVidCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPickPicVidThumbnailCollectionCellIdentifier forIndexPath:indexPath];
    if (_datasourceHas.imageForIndex) {
        cell.image = [_dataSource glPickPicVidThumbnailCollectionView:self
                                                        imageForIndex:indexPath.row];
    }
    return  cell;
}
#pragma mark - delegate

#pragma mark - user events

#pragma mark - functions


- (void)commonInit {
    [self addSubview:self.collectionView];
}

- (void)setDataSource:(id<GLPickPicVidThumbnailCollectionViewDataSource>)dataSource {
    _dataSource = dataSource;
    if ([dataSource respondsToSelector:@selector(glPickPicVidThumbnailCollectionViewNumberOfItems:)]) {
        _datasourceHas.numberOfItems = 1;
    }
    
    if ([dataSource respondsToSelector:@selector(glPickPicVidThumbnailCollectionView:imageForIndex:)]) {
        _datasourceHas.imageForIndex = 1;
    }
}

- (void)setDelegate:(id<GLPickPicVidThumbnailCollectionViewDelegate>)delegate {
    _delegate = delegate;
    if ([delegate respondsToSelector:@selector(glPickPicVidThumbnailCollectionView:didSelectAtIndex:)]) {
        _delegateHas.didSelectAtIndex = 1;
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

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)reset {
    [[self.collectionView indexPathsForSelectedItems]enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.collectionView deselectItemAtIndexPath:obj animated:NO];
    }];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

#pragma mark - notification

#pragma mark - getter and setter

- (UICollectionViewFlowLayout *)flowLayout:(CGFloat)left
                              paddingRight:(CGFloat)right
                                paddingTop:(CGFloat)top
                             paddingBottom:(CGFloat)bottom
                                cellHeight:(CGFloat)height
                               cellSpacing:(CGFloat)cellSpacing
                                 cellCount:(NSUInteger)cellCount {
    UICollectionViewFlowLayout *_flowLayout = nil;
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemwidth = floor((([UIScreen mainScreen].bounds.size.width - right - left - ((cellSpacing ) * (cellCount - 1) )) / cellCount)) ;
        CGFloat itemheight = height;
        
        if (cellCount == 0) {
            itemwidth = itemheight;
        }
        
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


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[self flowLayout:10.0 paddingRight:10.0
                                                       paddingTop:0.0
                                                       paddingBottom:0.0
                                                       cellHeight:30.0
                                                       cellSpacing:10.0
                                                       cellCount:0]];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[GLAlreadyPickPicVidCollectionViewCell class] forCellWithReuseIdentifier:kPickPicVidThumbnailCollectionCellIdentifier];
    }
    return _collectionView;
}

@end
