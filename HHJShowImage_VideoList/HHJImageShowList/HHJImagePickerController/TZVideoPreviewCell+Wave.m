//
//  TZVideoPreviewCell+Wave.m
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/10/23.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import "TZVideoPreviewCell+Wave.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "TZAssetModel+Wave.h"
#import <TZImageManager.h>
#import <YYImageCache.h>
#import <UIView+YYAdd.h>

@implementation TZVideoPreviewCell (Wave)

- (void)configMoviePlayer {
   
    NSLog(@"开挂的人生");
    
    if (self.player) {
        [self.playerLayer removeFromSuperlayer];
        self.playerLayer = nil;
        [self.player pause];
        self.player = nil;
    }
    
    
    if (self.model.asset) {
        [[TZImageManager manager] getPhotoWithAsset:self.model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            self.cover = photo;
        }];
        [[TZImageManager manager] getVideoWithAsset:self.model.asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.player = [AVPlayer playerWithPlayerItem:playerItem];
                self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
                self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
                self.playerLayer.frame = self.bounds;
                [self.layer addSublayer:self.playerLayer];
                [self configPlayButton];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlayToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
            });
        }];
        
        
        
        return;
    }
    id netWorkObjUrl = self.model.netWorkObjUrl;
    if ([netWorkObjUrl isKindOfClass:[NSString class]]) {
        
        if ([netWorkObjUrl hasPrefix:@"file:"]) {
            netWorkObjUrl = [NSURL fileURLWithPath:netWorkObjUrl];
        }else{
            netWorkObjUrl = [NSURL URLWithString:netWorkObjUrl];
        }
        
    }else if ([netWorkObjUrl isKindOfClass:[NSURL class]]){
        
    }else{
        netWorkObjUrl = nil;
    }
    if (!netWorkObjUrl) {
        return;
    }
    UIImage *image = [self thumbnailImageForVideo:netWorkObjUrl atTime:0.1];
    self.cover = image;
    
    NSString *cacheKey = [netWorkObjUrl lastPathComponent];
    
    
    AVURLAsset *avurlasset = [[self VideoDic] objectForKey:cacheKey];
    AVPlayerItem *playerItem = nil;
    if (avurlasset) {
        playerItem = [[AVPlayerItem alloc]initWithAsset:avurlasset];
    }
    if (!playerItem) {
        playerItem = [[AVPlayerItem alloc]initWithURL:netWorkObjUrl];
        
    }
    
    
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    self.playerLayer.frame = self.bounds;
    [self.layer addSublayer:self.playerLayer];
    [self configPlayButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PlayToEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
}


- (void)PlayToEnd{
    
    [self.player pause];
    [self.playButton setImage:[UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlay"] forState:UIControlStateNormal];
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

- (void)configPlayButton {
    if (self.playButton) {
        [self.playButton removeFromSuperview];
    }
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setImage:[UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlay"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlayHL"] forState:UIControlStateHighlighted];
    [self.playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playButton];
}

- (void)playButtonClick {
    
    if ([[self.viewController valueForKey:@"isHideNaviBar"] boolValue]) {
        if (self.player.rate != 0.0) {
            [self.player pause];
        }
        [self.playButton setImage:[UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlay"] forState:UIControlStateNormal];
        if (self.singleTapGestureBlock) {
            self.singleTapGestureBlock();
        }
        
        return;
    }
    
    CMTime currentTime = self.player.currentItem.currentTime;
    CMTime durationTime = self.player.currentItem.duration;
    if (self.player.rate == 0.0f) {
        if (currentTime.value == durationTime.value) [self.player.currentItem seekToTime:CMTimeMake(0, 1)];
        [self.player play];
        [self.playButton setImage:nil forState:UIControlStateNormal];
        if (!TZ_showStatusBarInitial && iOS7Later) {
            [UIApplication sharedApplication].statusBarHidden = YES;
        }
        if (self.singleTapGestureBlock) {
            self.singleTapGestureBlock();
        }
    } else {
        [self pausePlayerAndShowNaviBar];
    }
}

-(UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    NSString *cacheKey = videoURL.lastPathComponent;
    UIImage *image = [[YYImageCache sharedCache] getImageForKey:cacheKey];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    if (![[self VideoDic] objectForKey:cacheKey]) {
        [[self VideoDic] setObject:asset forKey:cacheKey];
    }
    
    if (image) {
        return image;
    }
    
    
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}


- (NSMutableDictionary *)VideoDic{
    
    static NSMutableDictionary *videpDic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videpDic = [NSMutableDictionary dictionary];
    });
    
    return videpDic;
}

@end
