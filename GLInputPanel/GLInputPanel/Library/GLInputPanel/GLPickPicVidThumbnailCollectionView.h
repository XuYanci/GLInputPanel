//
//  GLPickPicVidThumbnailCollectionView.h
//  66GoodLook
//
//  Created by Yanci on 17/5/1.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLPickPicVidThumbnailCollectionViewDataSource <NSObject>
- (NSUInteger)glPickPicVidThumbnailCollectionViewNumberOfItems:(id)sender;
- (UIImage *)glPickPicVidThumbnailCollectionView:(id)sender imageForIndex:(NSUInteger)index;
@end

@protocol GLPickPicVidThumbnailCollectionViewDelegate <NSObject>
- (void)glPickPicVidThumbnailCollectionView:(id)sender didSelectAtIndex:(NSUInteger)index;

@end


@interface GLPickPicVidThumbnailCollectionView : UIView
@property (nonatomic,weak) id <GLPickPicVidThumbnailCollectionViewDataSource> dataSource;
@property (nonatomic,weak) id <GLPickPicVidThumbnailCollectionViewDelegate> delegate;

- (void)reloadData;
- (void)reset;
@end
