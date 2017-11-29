//
//  HHJShowImageCell.m
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/9/28.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import "HHJShowImageCell.h"
#import "HHJMediaObj.h"
#import <TZImageManager.h>
#import "UIImageView+HHJWZZ.h"


NSString *const icon_deleteImageName = @"icon_shanchu";//删除图片的imagename
const NSInteger deleteImagew_h = 30;//删除图标的宽和高
NSString *const icon_addImageName = @"icon_tianjia";//添加图片的imagename
NSString *const icon_play_normal = @"icon_play_normal";//添加图片的imagename

@interface HHJShowImageCell (){
    CGFloat TZScreenWidth;
    CGFloat TZScreenScale;
}

@property (nonatomic, strong) NSString *representedAssetIdentifier;

@property (nonatomic, assign) int32_t imageRequestID;

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic) dispatch_queue_t load_queue;
/**
 承载图片/视频的控件
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 显示删除按钮
 */
@property (nonatomic, strong) UIButton *deletebt;

/**
 显示视频标签
 */
@property (nonatomic, strong) UIImageView *playvideoiv;

@end

@implementation HHJShowImageCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.contentView.clipsToBounds = YES;
        
        _imageView = [[UIImageView alloc]init];
        _imageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imageView];
        
        _playvideoiv = [[UIImageView alloc]init];
        _playvideoiv.contentMode = UIViewContentModeScaleAspectFit;
        _playvideoiv.hidden = YES;
        _playvideoiv.image = [UIImage imageNamed:icon_play_normal];
        
        [self.contentView addSubview:_playvideoiv];
        
        _deletebt = [UIButton buttonWithType:0];
//        _deletebt.frame = CGRectMake(0, 0, deleteImagew_h, deleteImagew_h);cg
        [_deletebt setImage:[UIImage imageNamed:icon_deleteImageName] forState:0];
        [_deletebt setImageEdgeInsets:UIEdgeInsetsMake(-7, 7, 0, 0)];
        [self.contentView addSubview:_deletebt];
        [_deletebt addTarget:self action:@selector(deletebtClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self layoutIfNeeded];
    }
    return self;
}

- (void) updateConstraintsWithObj:(HHJMediaObj *)hhjmediaobj{
    _hhjmediaobj = hhjmediaobj;
    
    [self setNeedsLayout];
}

- (void)deletebtClick{
    if (self.clickDeleteBtBlock) {
        self.clickDeleteBtBlock(self, _deletebt);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    
    _imageView.frame = self.bounds;
    
    _imageView.contentMode = _imagecontentmode;

    _deletebt.hidden = _OnlyShow;
    
    if (CGSizeEqualToSize(_deletebt.bounds.size, CGSizeZero)) {
        _deletebt.frame = CGRectMake(self.bounds.size.width-deleteImagew_h, 0, deleteImagew_h, deleteImagew_h);
    }
    
    if (CGSizeEqualToSize(_playvideoiv.bounds.size, CGSizeZero)) {
        _playvideoiv.frame = CGRectMake((self.bounds.size.width-35)/2, (self.bounds.size.height-35)/2, 35, 35);
    }
    
    if (!_hhjmediaobj) {
        UIImage *image = [UIImage imageNamed:icon_addImageName];
        _imageView.image = image;
        _playvideoiv.hidden = YES;
        _deletebt.hidden = YES;
        return;
    }
    
    if (_hhjmediaobj.asset) {
        
        _playvideoiv.hidden = _hhjmediaobj.asset.mediaType == PHAssetMediaTypeImage;
        
        [self HHJMediaObjToSetImage];
    }else if (_hhjmediaobj.netWorkObjUrl){
        
        _playvideoiv.hidden = _hhjmediaobj.mediaObjType == HHJMediaObjType_Image;
        
        [self HHJMediaObjToSetNetWorkImage];
        
    }

}

- (void)HHJMediaObjToSetNetWorkImage{
    
    id networkobjurl = _hhjmediaobj.netWorkObjUrl;
    
    if ([networkobjurl isKindOfClass:[NSURL class]]){
        if ([networkobjurl fileURL]) {
            networkobjurl = [networkobjurl path];
        }else{
            networkobjurl = [networkobjurl absoluteString];
        }
        
    }
    if (_hhjmediaobj.mediaObjType == HHJMediaObjType_Video) {
        NSURL *videourl = nil;
        if ([networkobjurl hasPrefix:@"file:"]) {
            videourl = [NSURL fileURLWithPath:networkobjurl];
        }else{
            videourl = [NSURL URLWithString:networkobjurl];
        }
        UIImage *image = [self thumbnailImageForVideo:videourl atTime:0.1];
        if (image) {
            [[YYImageCache sharedCache] setImage:image forKey:videourl.lastPathComponent];
        }
        _imageView.image = image;
        
    }else{
      [_imageView setImageStr:networkobjurl placeholderImage:nil ImageType_Options:ImageType_HHJ_imageviewFramefit ViewSize:CGSizeZero];
    }
    
}


- (void)HHJMediaObjToSetImage{
    
    UIImage *image = _hhjmediaobj.image;
    PHAsset *phasset = _hhjmediaobj.asset;
    if (image) {
        _imageView.image = image;
        return;
    }
    if (!(phasset&&[phasset isKindOfClass:[PHAsset class]])) {
        return;
    }
    if (_asset && self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    
    if ([phasset isEqual:_asset]) {
        return;
    }
    _asset = phasset;

    dispatch_async(self.load_queue, ^{
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        self.imageRequestID = [[PHImageManager defaultManager] requestImageDataForAsset:phasset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            UIImage *phassetimage = [UIImage imageWithData:imageData];
            if ([NSThread isMainThread]) {
                self.imageView.image = phassetimage;
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = phassetimage;
                });
            }
        }];
    });
    
}

- (dispatch_queue_t)load_queue{
    
    if (_load_queue) {
        return _load_queue;
    }
    
    static dispatch_queue_t loadqueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadqueue = dispatch_queue_create("loadqueue_cell", NULL);
    });
    _load_queue = loadqueue;
    return loadqueue;
}


- (UIView *)snapshotView {
    UIView *snapshotView = [[UIView alloc]init];
    
    UIView *cellSnapshotView = nil;
    
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        cellSnapshotView = [self snapshotViewAfterScreenUpdates:NO];
    } else {
        CGSize size = CGSizeMake(self.bounds.size.width + 20, self.bounds.size.height + 20);
        UIGraphicsBeginImageContextWithOptions(size, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cellSnapshotView = [[UIImageView alloc]initWithImage:cellSnapshotImage];
    }
    
    snapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    cellSnapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    
    [snapshotView addSubview:cellSnapshotView];
    return snapshotView;
}

-(UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    UIImage *image = [[YYImageCache sharedCache] getImageForKey:videoURL.lastPathComponent];
    
    if (image) {
        return image;
    }
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
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

@end





