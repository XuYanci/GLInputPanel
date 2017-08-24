//
//  GLPickPictureViewCollectionView.h
//  66GoodLook
//
//  Created by Yanci on 17/4/28.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLPickPicVidViewCollectionViewCellDataSource <NSObject>
- (NSUInteger)glPickPicVideViewCVCNumberOfSelectedItems;
@end

@protocol GLPickPicVidViewCollectionViewCellDelegate <NSObject>
- (void)glPickPicVidViewCVCDidSelected:(id)sender;
- (void)glPickPicVidViewCVCDidUnSelected:(id)sender;
@end

typedef enum : NSUInteger {
    GLPickPicVidCVType_Pic,
    GLPickPicVidCVType_Vid,
    GLPickPicVidCVType_TakePic,
    GLPickPicVidCVType_TakeVid,
} GLPickPicVidCVType;

@interface GLPickPicVidViewCollectionViewCell : UICollectionViewCell {
}
@property (nonatomic,assign) id<GLPickPicVidViewCollectionViewCellDelegate>delegate;
@property (nonatomic,assign) id<GLPickPicVidViewCollectionViewCellDataSource>dataSource;
@property (nonatomic,assign) GLPickPicVidCVType pickPicVidCVType;
@property (nonatomic,strong) UIImage *image;

- (void)setTickBtnSelected:(BOOL)selected;
@end
