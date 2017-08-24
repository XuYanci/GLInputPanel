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
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger {
    GLAssetType_Picture,
    GLAssetType_Video,
    GLAssetType_Both,
} GLAssetType;


typedef void(^GLAssetViewImageAsyncCallback)(UIImage *image);
typedef void(^GLAssetViewVideoAsyncCallback)(AVAsset *playAsset);

@class GLAssetViewBrowser;
@protocol GLAssetViewControllerDataSource <NSObject>
@required
- (NSUInteger)numberOfItemsInGLAssetViewController:(GLAssetViewBrowser *)assetViewController;
@optional
- (UIImage *)imageForItemInGLAssetViewControllerAtIndex:(NSUInteger)itemIndex;
- (void)asyncImageForItemInGLAssetViewControllerAtIndex:(NSUInteger)itemIndex
                                     imageAsyncCallback:(GLAssetViewImageAsyncCallback)callback;
- (void)asyncVideoForItemInGLAssetViewControllerAtIndex:(NSUInteger)itemIndex
                                     videoAsyncCallback:(GLAssetViewVideoAsyncCallback)callback;
@end

@protocol GLAssetViewControllerDelegate <NSObject>
- (void)glAssetViewController:(id)sender didClickOnItemAtIndex:(NSUInteger)itemIndex;
- (CGRect)imageRectForItemInGLAssetViewControllerAtIndex:(NSUInteger)itemIndex;
@end


/*!
 @class GLMediaBrowserViewController
 @brief The UIViewController class
 @discussion   媒体库浏览器
 @superclass SuperClass: UIViewController\n
 @classdesign    No special design is applied here.
 @coclass    No coclass
 @helps It helps no other classes.
 @helper    No helper exists for this class.
 */
@interface GLAssetViewBrowser : UIView
@property (nonatomic,assign) GLAssetType type;
@property (nonatomic,weak) id<GLAssetViewControllerDataSource>dataSource;
@property (nonatomic,weak) id<GLAssetViewControllerDelegate>delegate;



/**
 reload data , this will reload data source
 */
- (void)reloadData;

/**
 show browser
 */
- (void)show;

/**
 dismiss browser
 */
- (void)dismiss;


/**
 Show from origin rect with animations

 @param originRect animation origin rect
 @param thumbnail animation origin thumbnail
 @param originIndex origin item index
 */
- (void)showFromOriginRect:(CGRect)originRect
                 thumbnail:(UIImage *)thumbnail
                 withIndex:(NSUInteger)originIndex;

/**
 Dismiss to orgin rect with animations 
 @discussion 
    because browser can scroll to item index, it will dismiss to the origin rect of item index,
    if origin rect of item index is not visiable , it will dismiss centrally.
 */
//- (void)dismissToOriginRect;
@end
