//
//  TZPhotoPreviewView+Wave.m
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/10/19.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import "TZPhotoPreviewView+Wave.h"
#import <Photos/Photos.h>
#import <TZImageManager.h>
#import <TZProgressView.h>
#import "TZAssetModel+Wave.h"
#import "UIImageView+HHJWZZ.h"

@implementation TZPhotoPreviewView (Wave)



-(void)setAsset:(id)asset{
    
    if (self.asset && self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    
    [self setValue:asset forKey:@"_asset"];
    if (!asset) {
        
        if (self.model.image) {
            self.imageView.image = self.model.image;
            [self recoverSubviews];
            
            return;
        }
        
        if (self.model.netWorkObjUrl) {
            
            __weak typeof(self) weakself = self;
            
            [self.imageView setImageStr:self.model.netWorkObjUrl placeholderImage:nil ImageType_Options:ImageType_HHJ_imageslim ViewSize:CGSizeZero Progress:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                if (stage == YYWebImageStageFinished) {
                    [weakself recoverSubviews];
                }
            }];
        }
        
        
        return;
    }
    self.imageRequestID = [[TZImageManager manager] getPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (![asset isEqual:self.asset]) return;
        self.imageView.image = photo;
        [self recoverSubviews];
        
        self.progressView.hidden = YES;
        if (self.imageProgressUpdateBlock) {
            self.imageProgressUpdateBlock(1);
        }
        if (!isDegraded) {
            self.imageRequestID = 0;
        }
    } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        if (![asset isEqual:self.asset]) return;
        self.progressView.hidden = NO;
        [self bringSubviewToFront:self.progressView];
        progress = progress > 0.02 ? progress : 0.02;
        self.progressView.progress = progress;
        if (self.imageProgressUpdateBlock && progress < 1) {
            self.imageProgressUpdateBlock(progress);
        }
        
        if (progress >= 1) {
            self.progressView.hidden = YES;
            self.imageRequestID = 0;
        }
    } networkAccessAllowed:YES];
}

@end
