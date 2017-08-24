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

#import <Photos/Photos.h>
#import "GLAssetGridViewController.h"
#import "GLPickPicVidViewCollectionViewCell.h"
#import "GLAssetViewBrowser.h"
 

////////////////////////// Select Asset  //////////////////////////
@implementation SelectAsset
@end


static NSString *const kGLPickPicVidViewCollectionViewCellIdentifier = @"kGLPickPicVidViewCollectionViewCellIdentifier";

@interface GLAssetGridViewController ()<UICollectionViewDataSource,
                                        UICollectionViewDelegate,GLPickPicVidViewCollectionViewCellDelegate,GLPickPicVidViewCollectionViewCellDataSource,
                                            GLAssetViewControllerDataSource,
                                            GLAssetViewControllerDelegate>
@property (nonatomic,strong) UICollectionView  *collectionView;
@property (nonatomic,strong)PHFetchResult<PHAsset *> *allPhotos;
@property (nonatomic,strong)PHCachingImageManager *imageManager;
@property (nonatomic,assign)CGRect previousPreheatRect;
@property (nonatomic,assign)CGSize thumbnailSize;
@property (nonatomic,strong)NSMutableDictionary <NSString *,SelectAsset*>*selectedAddsets;
@property (nonatomic,strong)NSArray *preSelectedAssets;

@end

@implementation GLAssetGridViewController {
    BOOL _needsReload;  /*! 需要重载 */
    struct {
    }_datasourceHas;    /*! 数据源存在标识 */
    struct {
        unsigned  didPickAssets:1;
    }_delegateHas;      /*! 数据委托存在标识 */
    
    NSUInteger _selectedCount;
    
 
}

#pragma mark - life cycle


- (id)initWithSelectedAssets:(NSArray *)assets {
    if (self = [super init]) {
        [self commonInit];
        [self _setNeedsReload];
        _preSelectedAssets = assets;
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self commonInit];
        [self _setNeedsReload];
    }
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (void)viewWillLayoutSubviews {
    self.collectionView.frame = self.view.bounds;
    [self _reloadDataIfNeed];
    [self _layoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.allPhotos.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GLPickPicVidViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGLPickPicVidViewCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.dataSource = self;
    
    if (self.pickerType == GLAssetGridType_Picture) {
        [cell setPickPicVidCVType:GLPickPicVidCVType_Pic];
        if (indexPath.row == 0) {
            [cell setPickPicVidCVType:GLPickPicVidCVType_TakePic];
            [cell setImage:[UIImage imageNamed:@"ft_pic_icon_img"]];
            return cell;
        }
        
    }
    else if(self.pickerType == GLAssetGridType_Video) {
        [cell setPickPicVidCVType:GLPickPicVidCVType_Vid];
        if (indexPath.row == 0) {
            [cell setPickPicVidCVType:GLPickPicVidCVType_TakeVid];
            [cell setImage:[UIImage imageNamed:@"ft_pic_icon_camera"]];
            return cell;
        }
    }
    
    PHAsset *asset = [self.allPhotos objectAtIndex:indexPath.row - 1];
    [self.imageManager requestImageForAsset:asset
                                 targetSize:self.thumbnailSize
                                contentMode:PHImageContentModeAspectFit
                                    options:nil
                              resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                  cell.image = result;
                              }];
    
    
    BOOL selected =  [self.selectedAddsets.allKeys containsObject:asset.localIdentifier];
    
    if (!selected ) {
        [cell setTickBtnSelected:FALSE];
    }
    else if(selected) {
        [cell setTickBtnSelected:YES];
    }
    
    return cell;
}

#pragma mark - GLAssetViewControllerDataSource
- (NSUInteger)numberOfItemsInGLAssetViewController:(GLAssetViewBrowser *)assetViewController {
    return self.allPhotos.count;
}

- (void)asyncImageForItemInGLAssetViewControllerAtIndex:(NSUInteger)itemIndex imageAsyncCallback:(GLAssetViewImageAsyncCallback)callback {
    
    PHAsset *asset = [self.allPhotos objectAtIndex:itemIndex];
    [self.imageManager requestImageForAsset:asset
                                 targetSize:[UIScreen mainScreen].bounds.size
                                contentMode:PHImageContentModeAspectFit
                                    options:nil
                              resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        callback(result);
                                    });
                              }];
}

- (void)asyncVideoForItemInGLAssetViewControllerAtIndex:(NSUInteger)itemIndex videoAsyncCallback:(GLAssetViewVideoAsyncCallback)callback {
    PHAsset *asset = [self.allPhotos objectAtIndex:itemIndex];
    [self.imageManager requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(asset);
        });
    }];
}

#pragma mark - GLAssetViewControllerDelegate

- (CGRect)imageRectForItemInGLAssetViewControllerAtIndex:(NSUInteger)itemIndex {
    CGRect cellRect = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:itemIndex + 1 inSection:0]].frame;
    CGRect fromRect = [self.collectionView convertRect:cellRect
                                                toView:[UIApplication sharedApplication].keyWindow];
    
    if (![self.collectionView.indexPathsForVisibleItems containsObject:[NSIndexPath indexPathForRow:itemIndex + 1 inSection:0]]) {
        return CGRectZero;
    }
    
    return fromRect;
}

#pragma mark - delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && self.pickerType == GLAssetGridType_Picture) {
        NSLog(@"take video");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Take Photo" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Confirm"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];

    }
    else if(indexPath.row == 0 && self.pickerType == GLAssetGridType_Video) {
        NSLog(@"take pic");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Take Video" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Confirm"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];

    }
    else {
        GLAssetViewBrowser *assetViewController = [[GLAssetViewBrowser alloc]init];
        assetViewController.type = (self.pickerType == GLAssetGridType_Picture ? GLAssetType_Picture : GLAssetType_Video);
        assetViewController.dataSource = self;
        assetViewController.delegate = self;
        [assetViewController reloadData];
        
        CGRect cellRect = [collectionView cellForItemAtIndexPath:indexPath].frame;
        CGRect fromRect = [collectionView convertRect:cellRect
                                               toView:[UIApplication sharedApplication].keyWindow];
        
        [assetViewController showFromOriginRect:fromRect
                                      thumbnail:nil
                                      withIndex:indexPath.row - 1];
    }

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCachedAssets];
}

#pragma mark - GLPickPicVidViewCollectionViewCellDataSource

- (NSUInteger)glPickPicVideViewCVCNumberOfSelectedItems {
    return _selectedCount;
}

#pragma mark - GLPickPicVidViewCollectionViewCellDelegate
- (void)glPickPicVidViewCVCDidSelected:(id)sender {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    if (indexPath.row == 0 && self.pickerType == GLAssetGridType_Picture) {
        NSLog(@"take pic");
    }
    else if(indexPath.row == 0 && self.pickerType == GLAssetGridType_Video) {
        NSLog(@"take video");
    }
    else {
        PHAsset *asset = [self.allPhotos objectAtIndex:indexPath.row - 1];
        _selectedCount += 1;
        if (![self.selectedAddsets.allKeys containsObject:asset.localIdentifier]) {
            
            SelectAsset *selectAsset = [[SelectAsset alloc]init];
            selectAsset.asset = asset;
            [self.selectedAddsets setObject:selectAsset forKey:asset.localIdentifier];
           
            [self.imageManager requestImageForAsset:asset
                                         targetSize:self.thumbnailSize
                                        contentMode:PHImageContentModeAspectFit
                                            options:nil
                                      resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
            {
//                __strong typeof(self)strongSelf = weakSelf;
                selectAsset.image = result;
            }];
        }
    }
    
}

- (void)glPickPicVidViewCVCDidUnSelected:(id)sender {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    if (indexPath.row == 0 && self.pickerType == GLAssetGridType_Picture) {
        NSLog(@"take pic");
    }
    else if(indexPath.row == 0 && self.pickerType == GLAssetGridType_Video) {
        NSLog(@"take video");
    }
    else {
        PHAsset *asset = [self.allPhotos objectAtIndex:indexPath.row - 1];
        [self.imageManager requestImageForAsset:asset
                                     targetSize:self.thumbnailSize
                                    contentMode:PHImageContentModeAspectFit
                                        options:nil
                                  resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//                                      __strong typeof(self)strongSelf = weakSelf;
                                    
                                  }];
        
        _selectedCount -= 1;
        if ([self.selectedAddsets.allKeys containsObject:asset.localIdentifier]) {
            [self.selectedAddsets removeObjectForKey:asset.localIdentifier];
        }
    }
    
}


#pragma mark - user events
#pragma mark - functions

- (void)back {
    [self dismissViewControllerAnimated:YES completion:^{
        if (_delegateHas.didPickAssets) {
            [_delegate glAssetGridViewController:self didPickAssets:self.selectedAddsets];
        }
    }];
}

- (void)commonInit {
    if (self.pickerType == GLAssetGridType_Picture) {
        self.title = @"全部相册";
    }
    else if(self.pickerType == GLAssetGridType_Video) {
        self.title = @"全部视频";
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];

}

- (void)setDataSource:(id<GLAssetGridViewControllerDataSource>)dataSource {
    
}

- (void)setDelegate:(id<GLAssetGridViewControllerDelegate>)delegate {
    _delegate = delegate;
    if ([delegate respondsToSelector:@selector(glAssetGridViewController:didPickAssets:)]) {
        _delegateHas.didPickAssets = 1;
    }
}

/**
 * 重新加载数据
 */
- (void)_setNeedsReload {
    _needsReload = YES;
    [self.view setNeedsLayout];
}

/**
 按需重新加载数据
 */
- (void)_reloadDataIfNeed {
    if (_needsReload) {
        [self reloadData];
        _needsReload = NO;
    }
}

/** 视图布局 */
- (void)_layoutSubviews {
    self.collectionView.frame = self.view.bounds;
}

/**
 重载数据
 */
- (void)reloadData {
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
        [self requestAuthorzationStatus];
    }
    else {
        PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc]init];
        
        if (self.pickerType == GLAssetGridType_Video) {
            allPhotosOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeVideo];
            
        }
        else if(self.pickerType == GLAssetGridType_Picture) {
            allPhotosOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
            
        }
        
        allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false]];
        _allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
        [self resetCachedAssets];
        self.collectionView.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateCachedAssets];
            [self.collectionView reloadData];
            self.collectionView.userInteractionEnabled = YES;
        });
        
        if (self.pickerType == GLAssetGridType_Picture) {
            self.title = @"全部相册";
        }
        else if(self.pickerType == GLAssetGridType_Video) {
            self.title = @"全部视频";
        }
    }
}


#pragma mark - Asset Caching

- (void)requestAuthorzationStatus {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status) {
        case PHAuthorizationStatusAuthorized:
            [self reloadData];
            break;
        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted: {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Photo auth status deny or restricted,please auth before" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Confirm"
                                                      style:UIAlertActionStyleDefault
                                                    handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
            break;
        case PHAuthorizationStatusNotDetermined: {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:@"Photo auth status deny or restricted,please auth before" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"Confirm"
                                                              style:UIAlertActionStyleDefault
                                                            handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                    return;
                }
                else if(status == PHAuthorizationStatusAuthorized) {
                    [self reloadData];
                }
            }];
        }
            break;
        default:
            break;
    }
    
}

- (void)resetCachedAssets {
    
    /** Reset selected assets */
    [_allPhotos enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.preSelectedAssets containsObject:obj.localIdentifier]) {
            SelectAsset *selectAsset = [[SelectAsset alloc]init];
            selectAsset.asset = obj;
            [self.selectedAddsets setObject:selectAsset forKey:obj.localIdentifier];
        }
    }];
    
    NSMutableArray *assets = [NSMutableArray array];
    [self.selectedAddsets.allValues enumerateObjectsUsingBlock:^(SelectAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [assets addObject:obj.asset];
    }];
    
    [self.imageManager stopCachingImagesForAllAssets];
    
    /** Cache & Request selected assets */
    [self.imageManager startCachingImagesForAssets:assets targetSize:_thumbnailSize contentMode:PHImageContentModeAspectFit options:nil];
    [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.imageManager requestImageForAsset:obj targetSize:_thumbnailSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                SelectAsset *selectAsset = [self.selectedAddsets objectForKey:obj.localIdentifier];
                selectAsset.image = result;
            }];
    }];
    
    _selectedCount = self.selectedAddsets.count;
}

- (void)updateCachedAssets {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusDenied
        || status == PHAuthorizationStatusRestricted
        || status == PHAuthorizationStatusNotDetermined) {
        return;
    }
    
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x,
                                    self.collectionView.contentOffset.y,
                                    self.collectionView.bounds.size.width,
                                    self.collectionView.bounds.size.height);
    CGRect preheatRect = CGRectInset(visibleRect, 0,-0.5 * visibleRect.size.height);
    CGFloat delta = fabs(CGRectGetMidY(preheatRect) - CGRectGetMidY(_previousPreheatRect));
    if (delta <= self.view.bounds.size.height / 3.0) {
        return;
    }
    
    NSArray *rectsArray = [self differencesBetweenRects:_previousPreheatRect
                                                    new:preheatRect];
    NSArray *addedRects = [rectsArray objectAtIndex:0];
    NSArray *removedRects = [rectsArray objectAtIndex:1];
    
    NSMutableArray *addedAssets = [NSMutableArray array];
    NSMutableArray *removedAssets = [NSMutableArray array];
    
    [addedRects enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = [obj CGRectValue];
        NSArray <UICollectionViewLayoutAttributes*> *array = [self.collectionView.collectionViewLayout layoutAttributesForElementsInRect:rect];
        [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // becaues first item is an take photo item or take video item
            if (obj.indexPath.row >= 1) {
                [addedAssets addObject:[self.allPhotos objectAtIndex:obj.indexPath.row - 1]];
            }
        }];
    }];
    
    [removedRects enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect rect = [obj CGRectValue];
        NSArray <UICollectionViewLayoutAttributes*> *array = [self.collectionView.collectionViewLayout layoutAttributesForElementsInRect:rect];
        [array enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // becaues first item is an take photo item or take video item
            if (obj.indexPath.row >= 1) {
                [removedAssets addObject:[self.allPhotos objectAtIndex:obj.indexPath.row - 1]];
            }
        }];
    }];
    
    [self.imageManager startCachingImagesForAssets:addedAssets targetSize:_thumbnailSize contentMode:PHImageContentModeAspectFit options:nil];
    [self.imageManager stopCachingImagesForAssets:removedAssets targetSize:_thumbnailSize contentMode:PHImageContentModeAspectFit options:nil];
    _previousPreheatRect = preheatRect;
    
}

- (NSArray *)differencesBetweenRects:(CGRect)old new:(CGRect)new {
    if (CGRectIntersectsRect(old, new)) {
        
        NSMutableArray *addedArray = [NSMutableArray array];
        if (CGRectGetMaxY(new) > CGRectGetMaxY(old)) {
            CGRect added = CGRectMake(new.origin.x,CGRectGetMaxY(old),
                                      new.size.width,
                                      CGRectGetMaxY(new) - CGRectGetMaxY(old));
            [addedArray addObject:[NSValue valueWithCGRect:added]];
        }
        if (CGRectGetMinY(old) > CGRectGetMinY(new)) {
            CGRect added = CGRectMake(new.origin.x,
                                      CGRectGetMinY(new),new.size.width,
                                      CGRectGetMinY(old) - CGRectGetMinY(new));
            [addedArray addObject:[NSValue valueWithCGRect:added]];
        }
        
        NSMutableArray *removedArray = [NSMutableArray array];
        if (CGRectGetMaxY(new) < CGRectGetMaxY(old)) {
            CGRect removed = CGRectMake(new.origin.x,CGRectGetMaxY(new),new.size.width,
                                        CGRectGetMaxY(old) - CGRectGetMaxY(new));
            [removedArray addObject:[NSValue valueWithCGRect:removed]];
        }
        if (CGRectGetMinY(old) < CGRectGetMinY(new)) {
            CGRect removed = CGRectMake(new.origin.x,CGRectGetMinY(old),new.size.width,
                                        CGRectGetMinY(new) - CGRectGetMinY(old));
            [removedArray addObject:[NSValue valueWithCGRect:removed]];
        }
        
        return @[addedArray,removedArray];
    }
    return @[@[[NSValue valueWithCGRect:new]],@[[NSValue valueWithCGRect:old]]];
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
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat height = ([UIScreen mainScreen].bounds.size.width - 10.0 * 5) / 4.0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero
                                            collectionViewLayout:[self flowLayout:10.0 paddingRight:10.0 paddingTop:10.0 paddingBottom:10.0 cellHeight:height cellSpacing:10.0 cellCount:0]];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[GLPickPicVidViewCollectionViewCell class] forCellWithReuseIdentifier:kGLPickPicVidViewCollectionViewCellIdentifier];
    }
    return _collectionView;
}

- (NSMutableDictionary *)selectedAddsets {
    if (!_selectedAddsets) {
        _selectedAddsets = [NSMutableDictionary dictionary];
    }
    return _selectedAddsets;
}

- (PHCachingImageManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [[PHCachingImageManager alloc]init];
    }
    return _imageManager;
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
