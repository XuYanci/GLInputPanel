//
//  GLChatInputPanel.m
//  66GoodLook
//
//  Created by Yanci on 17/4/20.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import "GLChatInputPanel.h"
#import "GLChatInputAbleView.h"
#import "GLChatInputToolBar.h"
#import "GLPickPictureVideoView.h"
#import "GLPickPictureVideoView.h"
#import "GLPickPicVidThumbnailCollectionView.h"
#import "GLPickEmojView.h"
#import "GLAssetViewBrowser.h"
#import "GLAssetGridViewController.h"
#import <Masonry/Masonry.h>


@interface GLChatInputPanel()<GLChatInputToolBarDelegate,
                                GLChatInputToolBarDataSource,
                                GLPickPicVidViewDelegate,
                                GLChatInputAbleViewDelegate,
                                GLPickPicVidViewDataSource,GLPickPicVidThumbnailCollectionViewDataSource,GLPickPicVidThumbnailCollectionViewDelegate,GLAssetGridViewControllerDelegate,GLAssetGridViewControllerDataSource>
/** 工具栏 */
@property (nonatomic,strong) GLChatInputToolBar *toolbar;
/** 当前面板 */
@property (nonatomic,weak)  UIView<GLChatInputAbleView> *panel;
/** 视频选择器,作为Pannel */
@property (nonatomic,strong) GLPickPictureVideoView *pickVideoCollectionView;
/** 图片选择器,作为Pannel */
@property (nonatomic,strong) GLPickPictureVideoView *pickPictureCollectionView;
/** 表情选择器,作为Pannel */
//@property (nonatomic,strong) UIView<GLChatInputAbleView> *pickEmojView;
@property (nonatomic,strong) GLPickPicVidThumbnailCollectionView *pickPicVidThumbnailCollectionView;
/** **/
@property (nonatomic,strong) UIView *maskView;
/** 面板类型 */
@property (nonatomic,assign) GLChatInputPanelType panelType;
@property (nonatomic,strong) NSMutableDictionary *pickPicVidDictionary;

@end

@implementation GLChatInputPanel {
    BOOL _needsReload;  /*! 需要重载 */
    struct {
    }_datasourceHas;    /*! 数据源存在标识 */
    struct {
    }_delegateHas;      /*! 数据委托存在标识 */
    
    BOOL needProcessingKeyBoardNotif;
    GLChatInputToolBarType _toolbarType;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - life cycle


- (id)initWithPanelType:(GLChatInputPanelType)panelType {
    if (self = [super init]) {
        _panelType = panelType;
        self.frame = [UIScreen mainScreen].bounds;
        [self commonInit];
        [self setNeedsReload];
    }
    return self;
}

- (void)setPanelType:(GLChatInputPanelType)panelType {
    
    
    if (_panelType != panelType
        && _panelType == GLChatInputPanelType_Video) {
        [self.pickPicVidDictionary removeAllObjects];
        self.pickVideoCollectionView = nil;
        self.pickPictureCollectionView = nil;
        [self.pickPicVidThumbnailCollectionView reloadData];
    }
    
    if (_panelType != panelType
        && _panelType == GLChatInputPanelType_Image
        && panelType == GLChatInputPanelType_Video) {
        [self.pickPicVidDictionary removeAllObjects];
        self.pickVideoCollectionView = nil;
        self.pickPictureCollectionView = nil;
        [self.pickPicVidThumbnailCollectionView reloadData];
    }
    
    if (_panelType != panelType
        && panelType == GLChatInputPanelType_Video
        && _panelType == GLChatInputPanelType_Text) {
        [self.pickPicVidDictionary removeAllObjects];
        self.pickVideoCollectionView = nil;
        self.pickPictureCollectionView = nil;
        [self.pickPicVidThumbnailCollectionView reloadData];
    }
    
    _panelType = panelType;
    [self setNeedsReload];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _panelType = GLChatInputPanelType_Text;
        self.frame = [UIScreen mainScreen].bounds;
        [self commonInit];
        [self setNeedsReload];
    }
    return self;
}

- (void)layoutSubviews {
    [self _reloadDataIfNeeded];
    [super layoutSubviews];
}

#pragma mark - datasource

- (NSUInteger)glPickPicVidThumbnailCollectionViewNumberOfItems:(id)sender {
    return self.pickPicVidDictionary.count;
}

- (UIImage *)glPickPicVidThumbnailCollectionView:(id)sender imageForIndex:(NSUInteger)index {
   return [self.pickPicVidDictionary.allValues objectAtIndex:index];
}


#pragma mark - GLChatInputToolBarDataSource 


#pragma mark - GLAssetGridViewControllerDataSource


#pragma mark - GLAssetGridViewControllerDelegate

- (void)glAssetGridViewController:(id)sende didPickAssets:(NSMutableDictionary <NSString *,SelectAsset*>*)dictionary {
    [self.pickPicVidDictionary removeAllObjects];
    /** FAQ : Because user select pic sequentally , so can not use dictionary here , later verify */
    NSMutableArray *selectedAssets = [NSMutableArray array];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key,
                                                    SelectAsset * _Nonnull obj,
                                                    BOOL * _Nonnull stop) {
        [self.pickPicVidDictionary setObject:obj.image forKey:obj.asset.localIdentifier];
        [selectedAssets addObject:obj.asset];
    }];
    
    if (self.panelType == GLChatInputPanelType_Image || self.panelType == GLChatInputPanelType_Text) {
        [self.pickPictureCollectionView setSelAssets:selectedAssets];
    }
    else if(self.panelType == GLChatInputPanelType_Video) {
        [self.pickVideoCollectionView setSelAssets:selectedAssets];
    }
    
    [self.pickPicVidThumbnailCollectionView reloadData];
    
    self.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    }];
    
}

#pragma mark - delegate
- (void)glPickPicVidThumbnailCollectionView:(id)sender didSelectAtIndex:(NSUInteger)index {
    
}

#pragma mark - GLChatInputToolBarDelegate

- (void)glChatInputToolBar:(id)sender
      didSelectToolBarType:(GLChatInputToolBarType)toolBarType {
    
    
    if (toolBarType == GLChatInputToolBarType_Default) {
        [self.pickPictureCollectionView removeFromSuperview];
        [self.pickVideoCollectionView removeFromSuperview];

        
        /** Add thumbnail collection view */
        [self addSubview:self.pickPicVidThumbnailCollectionView];
        [self.pickPicVidThumbnailCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.height.offset(44.0);
            make.bottom.mas_equalTo(self.toolbar.mas_top).offset(-5.0);
        }];

        [self.pickPicVidThumbnailCollectionView reloadData];
        _toolbarType = toolBarType;
        
    }
    else if(toolBarType == GLChatInputToolBarType_Emoj) {
        [self.pickPictureCollectionView removeFromSuperview];
        [self.pickVideoCollectionView removeFromSuperview];

        /** Add thumbnail collection view */
        [self addSubview:self.pickPicVidThumbnailCollectionView];
        [self.pickPicVidThumbnailCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.height.offset(44.0);
            make.bottom.mas_equalTo(self.toolbar.mas_top).offset(-5.0);
        }];

        [self.pickPicVidThumbnailCollectionView reloadData];
        _toolbarType = toolBarType;
        
    }
    else if(toolBarType == GLChatInputToolBarType_Pic) {
        

        needProcessingKeyBoardNotif = NO;
        [self.toolbar endEditing:YES];
        
        /** Add thumbnail collection view */
        [self addSubview:self.pickPicVidThumbnailCollectionView];
        [self.pickPicVidThumbnailCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.height.offset(44.0);
            make.bottom.mas_equalTo(self.toolbar.mas_top).offset(-5.0);
        }];
        
        [self.pickPicVidThumbnailCollectionView reloadData];
        
        /** Add pick picture collection view */
        [self addSubview:self.pickPictureCollectionView];
        [self.pickPictureCollectionView sizeWith:CGSizeMake([UIScreen mainScreen].bounds.size.width, 200)];
        [self.pickPictureCollectionView alignParentBottom];
    
        NSInteger contentHeight = self.pickPictureCollectionView.frame.size.height + [self.toolbar contentHeight];
        if (_contentHeight != contentHeight)
        {
            CGRect rect = self.toolbar.frame;
            rect.origin.y = self.pickPictureCollectionView.frame.origin.y - [self.toolbar contentHeight];
            
            [UIView animateWithDuration:0.5 animations:^{
                self.toolbar.frame = rect;
                self.contentHeight = contentHeight;
                needProcessingKeyBoardNotif = YES;
            }];
        }
         _toolbarType = toolBarType;
    }
    else if(toolBarType == GLChatInputToolBarType_Video) {
        
        needProcessingKeyBoardNotif = NO;
        [self.toolbar endEditing:YES];
        
        /** Add thumbnail collection view */
        [self addSubview:self.pickPicVidThumbnailCollectionView];
        [self.pickPicVidThumbnailCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(0);
            make.height.offset(44.0);
            make.bottom.mas_equalTo(self.toolbar.mas_top).offset(-5.0);
        }];
        [self.pickPicVidThumbnailCollectionView reloadData];
        
        /** Add pick video collection view */
        [self addSubview:self.pickVideoCollectionView];
        [self.pickVideoCollectionView sizeWith:CGSizeMake([UIScreen mainScreen].bounds.size.width, 200)];
        [self.pickVideoCollectionView alignParentBottom];
        
        NSInteger contentHeight = self.pickVideoCollectionView.frame.size.height + [self.toolbar contentHeight];
        if (_contentHeight != contentHeight)
        {
            CGRect rect = self.toolbar.frame;
            rect.origin.y = self.pickVideoCollectionView.frame.origin.y - [self.toolbar contentHeight];
            
            [UIView animateWithDuration:0.5 animations:^{
                self.toolbar.frame = rect;
                self.contentHeight = contentHeight;
                needProcessingKeyBoardNotif = YES;
            }];
        }
         _toolbarType = toolBarType;

    }
}

#pragma mark -  GLPickPicVidViewDelegate
- (void)glPickPictureCollectionView:(id)sender
                       didPickAsset:(PHAsset *)pictureAsset
                     thumbnailImage:(UIImage *)image
                          assetType:(GLPickPicVidType) type {
      /** FAQ : Because user select pic sequentally , so can not use dictionary here , later verify */
    NSString *identifier = pictureAsset.localIdentifier;
    [self.pickPicVidDictionary setObject:image forKey:identifier];
    [self.pickPicVidThumbnailCollectionView reloadData];
}


- (void)glPickPictureCollectionView:(id)sender
                     didUnPickAsset:(PHAsset *)pictureAsset
                     thumbnailImage:(UIImage *)image
                          assetType:(GLPickPicVidType) type {
      /** FAQ : Because user select pic sequentally , so can not use dictionary here , later verify */
    NSString *identifier = pictureAsset.localIdentifier;
    [self.pickPicVidDictionary removeObjectForKey:identifier];
    [self.pickPicVidThumbnailCollectionView reloadData];
}

- (void)glPickPictureCollectionViewdidPickMore:(id)sender assetType:(GLPickPicVidType)type {
    
    
    self.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        GLAssetGridViewController *browserViewController = [[GLAssetGridViewController alloc]initWithSelectedAssets:self.pickPicVidDictionary.allKeys];
        [browserViewController setDelegate:self];
        [browserViewController setDataSource:self];
        browserViewController.hidesBottomBarWhenPushed = YES;
        if (type == GLPickPicVidType_Pic) {
            browserViewController.pickerType = GLPickPicVidType_Pic;
        }
        else if(type == GLPickPicVidType_Vid) {
            browserViewController.pickerType = GLPickPicVidType_Vid;
        }
        
        [[AppDelegate shareInstance]presentViewController:
         [[UINavigationController alloc]initWithRootViewController:browserViewController] animated:YES completion:nil];
    });
   
}

#pragma mark - user events
#pragma mark - functions

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    if (_panelType == GLChatInputPanelType_Text) {
        [self.toolbar beginOpenText];
    }
    else if(_panelType == GLChatInputPanelType_Video) {
        [self.toolbar beginOpenVideo];
    }
    else if(_panelType == GLChatInputPanelType_Image) {
        [self.toolbar beginOpenPhoto];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    }];
}

- (void)dismiss {

    [self.pickPicVidThumbnailCollectionView removeFromSuperview];
    [self.pickPictureCollectionView removeFromSuperview];
    [self.pickVideoCollectionView removeFromSuperview];
    [self.toolbar endEditing:YES];
    _contentHeight = 0;
    self.maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    [UIView animateWithDuration:0.5 animations:^{
        self.maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        CGRect frame = self.toolbar.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.toolbar.frame = frame;
    
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)commonInit {
    [self addSubview:self.maskView];
    [self addSubview:self.toolbar];
    [self addSubview:self.pickPicVidThumbnailCollectionView];
    if (self.panelType == GLChatInputPanelType_Text) {
        [self.toolbar setBarType:GLChatInputToolBarType_Default];
    }
    else if(self.panelType == GLChatInputPanelType_Image) {
        [self.toolbar setBarType:GLChatInputToolBarType_Pic];
    }
    else if(self.panelType == GLChatInputPanelType_Video) {
        [self.toolbar setBarType:GLChatInputToolBarType_Video];
    }
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    
    [self.toolbar sizeWith:CGSizeMake([UIScreen mainScreen].bounds.size.width, 44.0)];
    [self.toolbar alignParentBottomWithMargin:-44.0];
    [self.toolbar alignParentRight];
    [self.toolbar alignParentLeft];
    
    [self.pickPicVidThumbnailCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.height.offset(44.0);
        make.bottom.mas_equalTo(self.toolbar.mas_top).offset(-5.0);
    }];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardDidShow:) name:UIKeyboardDidChangeFrameNotification object:nil];

}

- (void)setDataSource:(id<GLChatInputPanelDataSource>)dataSource {}

- (void)setDelegate:(id<GLChatInputPanelDelegate>)delegate {}

- (void)setNeedsReload {
    _needsReload = YES;
    needProcessingKeyBoardNotif = YES;
    [self setNeedsLayout];
}
- (void)_reloadDataIfNeeded {
    if (_needsReload) {
        [self reloadData];
    }
}
- (void)reloadData {

}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}
#pragma mark - notification
- (void)onKeyboardDidShow:(NSNotification *)notification
{
    if ([self.toolbar isEditing]) {
        NSDictionary *userInfo = notification.userInfo;
        CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        NSInteger contentHeight = endFrame.size.height + [self.toolbar contentHeight];
        
        if (_contentHeight != contentHeight)
        {
            CGRect rect = self.toolbar.frame;
            rect.origin.y = endFrame.origin.y - [self.toolbar contentHeight];
            
            [UIView animateWithDuration:duration animations:^{
                self.toolbar.frame = rect;
                self.contentHeight = contentHeight;
            }];
        }
    }

}

- (void)onKeyboardWillHide:(NSNotification *)notification {
    
    if (needProcessingKeyBoardNotif) {
        NSDictionary* userInfo = [notification userInfo];
        CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        NSInteger contentHeight = [self.toolbar contentHeight] + [self.panel contentHeight];
        
        if (_contentHeight != contentHeight)
        {
            CGRect rect = self.toolbar.frame;
            rect.origin.y = [UIScreen mainScreen].bounds.size.height;
            
            [UIView animateWithDuration:duration animations:^{
                self.toolbar.frame = rect;
                self.contentHeight = contentHeight;
            }];
        }
    }
}

#pragma mark - getter and setter
- (GLChatInputToolBar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[GLChatInputToolBar alloc]initWithBarType:GLChatInputToolBarType_Default];
        _toolbar.backgroundColor = [UIColor whiteColor];
        _toolbar.delegate = self;
        _toolbar.dataSource = self;
        _toolbar.chatDelegate = self;
    }
    return _toolbar;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]init];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [_maskView addGestureRecognizer:tapGR];
    }
    return _maskView;
}

- (GLPickPictureVideoView*)pickVideoCollectionView {
    if (!_pickVideoCollectionView) {
        _pickVideoCollectionView = [[GLPickPictureVideoView alloc]init];
        _pickVideoCollectionView.type = GLPickPicVidType_Vid;
        _pickVideoCollectionView.delegate = self;
        _pickVideoCollectionView.dataSource = self;
    }
    return _pickVideoCollectionView;
}

- (GLPickPictureVideoView *)pickPictureCollectionView {
    if (!_pickPictureCollectionView) {
        _pickPictureCollectionView = [[GLPickPictureVideoView alloc]init];
        _pickPictureCollectionView.type = GLPickPicVidType_Pic;
        _pickPictureCollectionView.delegate = self;
        _pickPictureCollectionView.dataSource = self;
    }
    return _pickPictureCollectionView;
}

- (NSMutableDictionary *)pickPicVidDictionary {
    if (!_pickPicVidDictionary) {
        _pickPicVidDictionary = [NSMutableDictionary dictionary];
    }
    return _pickPicVidDictionary;
}

- (GLPickPicVidThumbnailCollectionView *)pickPicVidThumbnailCollectionView {
    if (!_pickPicVidThumbnailCollectionView) {
        _pickPicVidThumbnailCollectionView = [[GLPickPicVidThumbnailCollectionView alloc]init];
        _pickPicVidThumbnailCollectionView.dataSource = self;
    }
    return _pickPicVidThumbnailCollectionView;
}

@end
