//
//  GLPickPictureCollectionView.h
//  66GoodLook
//
//  Created by Yanci on 17/4/20.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLChatInputAbleView.h"
#import "GLChatInputBaseView.h"
#import <Photos/Photos.h>

typedef enum : NSUInteger {
    GLPickPicVidType_Pic,
    GLPickPicVidType_Vid,
} GLPickPicVidType;

@protocol GLPickPicVidViewDataSource <NSObject>
@end

@protocol GLPickPicVidViewDelegate <NSObject>

/**
 delegate - pick picture video callback

 @param sender GLPickPictureVideoView
 @param pictureAsset pick picture video asset
 */
- (void)glPickPictureCollectionView:(id)sender didPickAsset:(PHAsset *)pictureAsset  thumbnailImage:(UIImage *)image assetType:(GLPickPicVidType) type;
- (void)glPickPictureCollectionView:(id)sender didUnPickAsset:(PHAsset *)pictureAsset  thumbnailImage:(UIImage *)image assetType:(GLPickPicVidType) type;
- (void)glPickPictureCollectionViewdidPickMore:(id)sender assetType:(GLPickPicVidType) type;
@end

/*!
 @class GLPickPictureVideoView
 
 @brief The UIView class
 
 @discussion    图片选择器
 
 @superclass SuperClass: UIView\n
 @classdesign    No special design is applied here.
 @coclass    None
 @helps It helps no other classes.
 @helper    No helper exists for this class.
 */
@interface GLPickPictureVideoView : UIView

@property (nonatomic,weak) id <GLPickPicVidViewDelegate> delegate;
@property (nonatomic,weak) id <GLPickPicVidViewDataSource> dataSource;
@property (nonatomic,assign) GLPickPicVidType type;


/**
 设置选择的Asset
 @param selectedAssets 选择的Asset
 */
- (void)setSelAssets:(NSArray *)selectedAssets;

/**
 重载数据
 */
- (void)reloadData;


@end
