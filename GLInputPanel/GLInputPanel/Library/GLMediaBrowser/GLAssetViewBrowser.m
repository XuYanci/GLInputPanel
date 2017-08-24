// GLViewPagerViewController.h
//
// Copyright (c) 2017 XuYanci (http://yanci.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "GLAssetViewBrowser.h"
#import <AVFoundation/AVFoundation.h>
#import "GLAssetCollectionViewCell.h"

static NSString *const kCellIdentifier = @"cellIdentifier";

@interface GLAssetViewBrowser ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIVisualEffectView *effectView;
@property (nonatomic,strong) UILabel *currentPageLabel;
@end

@implementation GLAssetViewBrowser {
    BOOL _needsReload;  /*! 需要重载 */
    struct {
        unsigned numberOfItems:1;
        unsigned imageForItem:1;
        unsigned asyncImageForItem:1;
        unsigned asyncVideoForItem:1;
    }_datasourceHas;    /*! 数据源存在标识 */
    struct {
        unsigned didClickOnItemAtIndex:1;
        unsigned imageRectForItemAtIndex:1;
    }_delegateHas;      /*! 数据委托存在标识 */
    
    NSUInteger _numbersOfItems;
    CGRect _fromRect;
    UIImage *_thumbnail;
    NSUInteger _startShowIndex;

    
    /** Pan gesture for dismiss */
    UIPanGestureRecognizer *_swipeVerGestureRecognizer;
    UITapGestureRecognizer *_tapGestureRecognizer;
    CGPoint _firstPoint;
    CGPoint _prePoint;
    CGPoint _nowPoint;
}


#pragma mark - life cycle



- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        [self commonInit];
        [self setNeedsReload];
    }
    return self;
}


- (void)layoutSubviews {
    self.collectionView.frame = self.bounds;
    [self _reloadDataIfNeeded];
    [self _layoutSubviews];
}



#pragma mark - datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_datasourceHas.numberOfItems) {
        _numbersOfItems = [_dataSource numberOfItemsInGLAssetViewController:self];
        return _numbersOfItems;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GLAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (_datasourceHas.imageForItem) {
        cell.imageView.image = [_dataSource imageForItemInGLAssetViewControllerAtIndex:indexPath.row];
    }
    if (_datasourceHas.asyncImageForItem && self.type == GLAssetType_Picture) {
        cell.cellType = AssetCollectionViewCellType_Pic;
        [_dataSource asyncImageForItemInGLAssetViewControllerAtIndex:indexPath.row imageAsyncCallback:^(UIImage *image) {
            cell.imageView.image = image;
        }];
    }
    if (_datasourceHas.asyncVideoForItem && self.type == GLAssetType_Video) {
        cell.cellType = AssetCollectionViewCellType_Vid;
        [_dataSource asyncVideoForItemInGLAssetViewControllerAtIndex:indexPath.row videoAsyncCallback:^(AVAsset *playAsset) {
            [cell setPlayAsset:playAsset];
        }];
    }
    
    return cell;;
}

#pragma mark - delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(GLAssetCollectionViewCell *)cell stopPlay];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems]lastObject];
    self.currentPageLabel.text = [NSString stringWithFormat:@"%ld/%ld",
                                  (unsigned long)(indexPath.row + 1),
                                  (unsigned long)_numbersOfItems];
    [self setNeedsLayout];
}

#pragma mark - user events
- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
        CGRect originRect = CGRectZero;
        if (_delegateHas.imageRectForItemAtIndex) {
            originRect = [_delegate imageRectForItemInGLAssetViewControllerAtIndex:
                          [[self.collectionView indexPathsForVisibleItems]lastObject].row];
        }
    
        if (CGRectEqualToRect(originRect, CGRectZero)) {
            [self dismiss];
        }
        else {
            [self dismissToOriginRect:originRect];
        }
}

- (void)swipeVerGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    /** Swipe finish here we recover state*/
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (fabs(_nowPoint.y - _firstPoint.y) >= 200.0) {
            [self dismiss];
        }
        else {
            _nowPoint  = CGPointZero;
            _prePoint = CGPointZero;
            [UIView animateWithDuration:0.5 animations:^{
                self.collectionView.frame = self.bounds;
                self.collectionView.alpha = 1.0;
                self.effectView.alpha = 1.0;
            }];
        }
    }
    /** Swipe going on */
    else if(panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        _prePoint = _nowPoint;
        _nowPoint = [panGestureRecognizer locationInView:self];
        
        if (CGPointEqualToPoint(CGPointZero, _prePoint)) {
            _prePoint = _nowPoint;
            _firstPoint = _nowPoint;
        }
        CGFloat y =  _nowPoint.y - _prePoint.y;
        CGRect frameOfCollectionView = self.collectionView.frame;
        frameOfCollectionView.origin.y += y;
        self.collectionView.frame = frameOfCollectionView;
        self.collectionView.alpha = 1.0 - fabs(_nowPoint.y - _firstPoint.y) * 0.005;
        self.effectView.alpha = 1.0 - fabs(_nowPoint.y - _firstPoint.y) * 0.005;
    }
}

#pragma mark - functions
- (void)commonInit {
    
    /** Add blur */
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.bounds;
    [self addSubview:effectView];
    _effectView = effectView;
    
    /** Add collectionview */
    [self addSubview:self.collectionView];
    
    /** Add swipe gesture */
    _swipeVerGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(swipeVerGestureRecognizer:)];
    [self addGestureRecognizer:_swipeVerGestureRecognizer];
    _prePoint = _nowPoint = CGPointZero;
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self addGestureRecognizer:_tapGestureRecognizer];
    
    /** Add current label */
    [self addSubview:self.currentPageLabel];
    self.currentPageLabel.text = @"0/0";
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.effectView.alpha = 0.0;
    self.collectionView.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.effectView.alpha = 1.0;
        self.collectionView.alpha = 1.0;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5 animations:^{
        self.effectView.alpha = 0.0;
        self.collectionView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showFromOriginRect:(CGRect)originRect
                 thumbnail:(UIImage *)thumbnail
                 withIndex:(NSUInteger)originIndex {
    _fromRect = originRect;
    _thumbnail = thumbnail;
    _startShowIndex = originIndex;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.collectionView.hidden = YES;
    self.effectView.hidden = YES;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    
    /** Get origin image */
    __block UIImage *originImage = nil;
    if (_datasourceHas.imageForItem) {
        originImage = [_dataSource imageForItemInGLAssetViewControllerAtIndex:originIndex];
        CGRect finalRect = [self calculateScaledFinalFrame:originImage];
        imageView.image = _thumbnail;
        imageView.frame = originRect;
        
        [UIView animateWithDuration:0.5 animations:^{
            imageView.frame = finalRect;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            self.effectView.hidden = NO;
            self.collectionView.hidden = NO;
        }];
    }
    /** Get origin image for image picker or video picker */
    if (_datasourceHas.asyncImageForItem ) {
        [_dataSource asyncImageForItemInGLAssetViewControllerAtIndex:originIndex imageAsyncCallback:^(UIImage *image) {
            if (!originImage) {
                originImage = image;
                CGRect finalRect = [self calculateScaledFinalFrame:image];
                imageView.image = image;
                imageView.frame = originRect;
                [UIView animateWithDuration:0.5 animations:^{
                    imageView.frame = finalRect;
                } completion:^(BOOL finished) {
                    [imageView removeFromSuperview];
                    self.effectView.hidden = NO;
                    self.collectionView.hidden = NO;
                }];
            }
        }];
    }
}

- (void)dismissToOriginRect:(CGRect)originRect {
    self.collectionView.hidden = YES;
    self.effectView.hidden = YES;

    __block UIImage *originImage = nil;
    if (_datasourceHas.imageForItem) {
        CGRect fromRect = CGRectZero;
        fromRect = [self caculateCurrentDisplayImageFrame];
        UIImageView *imageView = [[UIImageView alloc]init];
        [self addSubview:imageView];
        
        originImage = [_dataSource imageForItemInGLAssetViewControllerAtIndex:
                       [[self.collectionView indexPathsForVisibleItems] lastObject].row];
        imageView.image = originImage;
        imageView.frame = fromRect;
        
        [UIView animateWithDuration:0.5 animations:^{
            imageView.frame = originRect;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            [self removeFromSuperview];
        }];
    }
    
    if (_datasourceHas.asyncImageForItem && self.type == GLAssetType_Picture) {
        CGRect fromRect = CGRectZero;
        fromRect = [self caculateCurrentDisplayImageFrame];
        UIImageView *imageView = [[UIImageView alloc]init];
        [self addSubview:imageView];
        
        [_dataSource asyncImageForItemInGLAssetViewControllerAtIndex:[[self.collectionView indexPathsForVisibleItems] lastObject].row imageAsyncCallback:^(UIImage *image) {
            if (!originImage) {
                originImage = image;
                imageView.image = originImage;
                imageView.frame = fromRect;
                
                [UIView animateWithDuration:0.5 animations:^{
                    imageView.frame = originRect;
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
            }
        }];
    }
    
    if (_datasourceHas.asyncVideoForItem && self.type == GLAssetType_Video) {
        [self dismiss];
        // TODO: Add animations
    }
}

- (void)setDataSource:(id<GLAssetViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
    if ([dataSource respondsToSelector:@selector(numberOfItemsInGLAssetViewController:)]) {
        _datasourceHas.numberOfItems= 1;
    }
    if ([dataSource respondsToSelector:@selector(imageForItemInGLAssetViewControllerAtIndex:)]) {
        _datasourceHas.imageForItem = 1;
    }
    if ([dataSource respondsToSelector:@selector(asyncImageForItemInGLAssetViewControllerAtIndex:imageAsyncCallback:)]) {
        _datasourceHas.asyncImageForItem = 1;
    }
    if ([dataSource respondsToSelector:@selector(asyncVideoForItemInGLAssetViewControllerAtIndex:videoAsyncCallback:)]) {
        _datasourceHas.asyncVideoForItem = 1;
    }
  
}

- (void)setDelegate:(id<GLAssetViewControllerDelegate>)delegate {
    _delegate = delegate;
    if ([_delegate respondsToSelector:@selector(glAssetViewController:didClickOnItemAtIndex:)]) {
        _delegateHas.didClickOnItemAtIndex = 1;
    }
    if ([_delegate respondsToSelector:@selector(imageRectForItemInGLAssetViewControllerAtIndex:)]) {
        _delegateHas.imageRectForItemAtIndex = 1;
    }
}

- (CGRect)calculateScaledFinalFrame:(UIImage *)finalImage
{
    CGSize thumbSize = finalImage.size;
    CGFloat finalHeight = self.frame.size.width * (thumbSize.height / thumbSize.width);
    CGFloat top = 0.f;
    if (finalHeight < self.frame.size.height)
    {
        top = (self.frame.size.height - finalHeight) / 2.f;
    }
    return CGRectMake(0.f, top, self.frame.size.width, finalHeight);
}

- (CGSize)caculateScaledFinalFrameForPlayerItem:(AVPlayerItem *)playerItem {
    AVAssetTrack *track = [[playerItem.asset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0];
    CGSize size = CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform);
    CGSize videoSize = CGSizeMake(fabs(size.width), fabs(size.height));
    CGSize actualSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,
                                   [UIScreen mainScreen].bounds.size.width  / (videoSize.width / videoSize.height ) );
    
    return actualSize;
}

- (CGRect)caculateCurrentDisplayImageFrame {
    UIImageView *iv = ((GLAssetCollectionViewCell *)[[self.collectionView visibleCells]lastObject]).imageView;
    CGSize imageSize = iv.image.size;
    CGFloat imageScale = fminf(CGRectGetWidth(iv.bounds)/imageSize.width, CGRectGetHeight(iv.bounds)/imageSize.height);
    CGSize scaledImageSize = CGSizeMake(imageSize.width*imageScale, imageSize.height*imageScale);
    CGRect imageFrame = CGRectMake(roundf(0.5f*(CGRectGetWidth(iv.bounds)-scaledImageSize.width)), roundf(0.5f*(CGRectGetHeight(iv.bounds)-scaledImageSize.height)), roundf(scaledImageSize.width), roundf(scaledImageSize.height));
    return imageFrame;
}


- (void)setNeedsReload {
    _needsReload = YES;
    [self  setNeedsLayout];
}
- (void)_reloadDataIfNeeded {
    if (_needsReload) {
        [self reloadData];
        _needsReload = NO;
    }
}

- (void)_layoutSubviews {
    self.collectionView.frame = self.bounds;
    [self.currentPageLabel sizeToFit];
    
    CGRect frameOfCurrentPageLabel = self.currentPageLabel.frame;
    self.currentPageLabel.frame = CGRectMake(self.bounds.size.width - self.currentPageLabel.intrinsicContentSize.width - 10,
                                             self.bounds.size.height - self.currentPageLabel.intrinsicContentSize.height - 10,
                                             frameOfCurrentPageLabel.size.width,
                                             frameOfCurrentPageLabel.size.height);
}

- (void)reloadData {
    __weak typeof(self)weakSelf = self;
    [self.collectionView setCollectionViewLayout:  [self flowLayout:0
                                                       paddingRight:0
                                                         paddingTop:0
                                                      paddingBottom:0
                                                         cellHeight:self.bounds.size.height
                                                        cellSpacing:0
                                                          cellCount:1] animated:NO completion:^(BOOL finished) {
        
    }];
    
    self.collectionView.contentInset = UIEdgeInsetsZero;
    [weakSelf.collectionView reloadData];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_startShowIndex inSection:0]atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO];
    self.currentPageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(unsigned long)(_startShowIndex + 1),(unsigned long)_numbersOfItems];
    [self setNeedsLayout];
    
    if (self.type == GLAssetType_Video) {
        self.currentPageLabel.hidden = YES;
    }
    else if (self.type == GLAssetType_Picture) {
        self.currentPageLabel.hidden = NO;
    }
}


#pragma mark - notification
#pragma mark - getter and setter

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

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:
                           [self flowLayout:0
                               paddingRight:0
                                 paddingTop:0
                              paddingBottom:0
                                 cellHeight:[UIScreen mainScreen].bounds.size.height
                                cellSpacing:0
                                  cellCount:1]];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[GLAssetCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (UILabel *)currentPageLabel {
    if (!_currentPageLabel) {
        _currentPageLabel = [[UILabel alloc]init];
        _currentPageLabel.textColor = [UIColor whiteColor];
    }
    return _currentPageLabel;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

