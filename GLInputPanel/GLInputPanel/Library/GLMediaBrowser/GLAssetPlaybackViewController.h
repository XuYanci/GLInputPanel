//
//  GLAssetPlaybackViewController.h
//  GLAssetGridViewController
//
//  Created by Yanci on 17/5/16.
//  Copyright © 2017年 Yanci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLAssetPlayBackView.h"
@protocol GLAssetPlaybackViewControllerDataSource <NSObject>

@end

@protocol GLAssetPlaybackViewControllerDelegate <NSObject>

@end

@class GLAssetPlaybackContainer;
@interface GLAssetPlaybackViewController : UIViewController {
    float mRestoreAfterScrubbingRate;
    BOOL seekToZeroBeforePlay;
    id mTimeObserver;
    BOOL isSeeking;
    
    NSURL* mURL;
    AVPlayer* mPlayer;
    AVPlayerItem * mPlayerItem;
    AVAsset *mPlayAsset;
    GLAssetPlayBackView* mPlaybackView;
}
@property (nonatomic,strong)UIButton *playBtn;
@property (nonatomic,strong)UISlider *timeSlider;
@property (nonatomic,strong)UILabel *currentTimeLabel;
@property (nonatomic,strong)UILabel *leftTimeLabel;
@property (nonatomic,strong)UIButton *fullScreenBtn;
@property (nonatomic,strong)UIButton *startPlayBtn;
@property (nonatomic,strong)GLAssetPlayBackView *container;
@property (nonatomic,strong)GLAssetPlaybackContainer *toolbar;
@property (nonatomic,strong)GLAssetPlayBackView *mPlaybackView;
@property (nonatomic,strong)UIImageView *defaultImageView;
@property (nonatomic, copy) NSURL* URL;
@property (readwrite, strong, setter=setPlayer:, getter=player) AVPlayer* mPlayer;
@property (nonatomic,strong) AVAsset* mPlayAsset;
@property (nonatomic,strong) AVPlayerItem *mPlayerItem;

@property (nonatomic,weak)id<GLAssetPlaybackViewControllerDataSource>dataSource;
@property (nonatomic,weak)id<GLAssetPlaybackViewControllerDelegate>delegate;

- (void)stop;

@end

@interface GLAssetPlaybackViewController (Player)
- (void)removePlayerTimeObserver;
- (CMTime)playerItemDuration;
- (BOOL)isPlaying;
- (void)playerItemDidReachEnd:(NSNotification *)notification ;
- (void)observeValueForKeyPath:(NSString*) path ofObject:(id)object change:(NSDictionary*)change context:(void*)context;
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys;
@end

