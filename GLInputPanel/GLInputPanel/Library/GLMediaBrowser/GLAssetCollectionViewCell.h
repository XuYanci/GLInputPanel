//
//  GLAssetCollectionViewCell.h
//  GLAssetGridViewController
//
//  Created by Yanci on 17/5/18.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger {
    AssetCollectionViewCellType_Pic,
    AssetCollectionViewCellType_Vid,
} AssetCollectionViewCellType;

@interface GLAssetCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView *imageView;
//@property (nonatomic,strong)NSURL *videoUrl;
@property (nonatomic,strong)AVAsset *playAsset;
@property (nonatomic,assign)AssetCollectionViewCellType cellType;

- (void)stopPlay;
@end
