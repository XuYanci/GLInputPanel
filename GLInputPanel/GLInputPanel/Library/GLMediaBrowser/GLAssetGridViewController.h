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

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

////////////////////////// Select Asset  //////////////////////////

@interface SelectAsset:NSObject
@property (nonatomic,strong)PHAsset *asset;
@property (nonatomic,strong)UIImage *image;
@end


typedef enum : NSUInteger {
    GLAssetGridType_Picture,
    GLAssetGridType_Video,
} GLAssetGridType;


@protocol GLAssetGridViewControllerDataSource <NSObject>
@end

@protocol GLAssetGridViewControllerDelegate <NSObject>
- (void)glAssetGridViewController:(id)sender didPickAssets:(NSMutableDictionary *)dictionary;
@end

/*!
 @class GLMediaPickerViewController
 @brief The UIViewController class
 @discussion   媒体库挑选器
 @superclass SuperClass: UIViewController\n
 @classdesign    No special design is applied here.
 @coclass    No coclass
 @helps It helps no other classes.
 @helper    No helper exists for this class.
 */
@interface GLAssetGridViewController : UIViewController
@property (nonatomic,assign) GLAssetGridType pickerType;
@property (nonatomic,weak) id <GLAssetGridViewControllerDataSource>dataSource;
@property (nonatomic,weak) id <GLAssetGridViewControllerDelegate>delegate;

- (id)initWithSelectedAssets:(NSArray *)assets;
- (void)reloadData;
@end
