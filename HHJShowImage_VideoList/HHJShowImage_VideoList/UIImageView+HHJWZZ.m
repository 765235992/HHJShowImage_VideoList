//
//  UIImageView+HHJWZZ.m
//  HengHa
//
//  Created by 哼哈匠 on 2017/9/27.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import "UIImageView+HHJWZZ.h"

#import <objc/runtime.h>
#import <NSString+YYAdd.h>

@implementation UIImageView (HHJWZZ)

static char ShowWaterText;

-(void)setWaterText:(NSString *)WaterText{
    
    objc_setAssociatedObject(self, &ShowWaterText, WaterText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)WaterText{
    return objc_getAssociatedObject(self, &ShowWaterText);
}

- (void)setImageStr:(NSString*)imagestr placeholderImage:(UIImage*)placeholderImage ImageType_Options:(ImageType_HHJ)imagetype_options ViewSize:(CGSize)viewsize{
    
    [self cancelCurrentImageRequest];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!imagestr.length) {
            self.image = placeholderImage;
            return;
        }
        
        if ([imagestr hasPrefix:@"file:"]) {
            
            self.image = [UIImage imageWithContentsOfFile:imagestr];
            
            return;
        }
    });
    
    NSURL *imageChangeUrl = [self ImageStrWithImageType:imagetype_options ImageStr:imagestr ViewSize:viewsize];
    
    
    [self setImageWithURL:imageChangeUrl placeholder:placeholderImage options:YYWebImageOptionAllowInvalidSSLCertificates|kNilOptions completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        NSLog(@"error===%@ image===%@",error.localizedDescription,image);
    }];
    
}

- (void)setImageStr:(NSString*)imagestr placeholderImage:(UIImage*)placeholderImage ImageType_Options:(ImageType_HHJ)imagetype_options ViewSize:(CGSize)viewsize Progress:(YYWebImageProgressBlock)progress completion:(YYWebImageCompletionBlock)completion{
    [self cancelCurrentImageRequest];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!imagestr.length) {
            self.image = placeholderImage;
            if (completion) {
                completion(placeholderImage,[NSURL URLWithString:imagestr],0,YYWebImageStageFinished,nil);
            }
            return;
        }
        
        if ([imagestr hasPrefix:@"file:"]) {
            
            UIImage * image = [UIImage imageWithContentsOfFile:imagestr];
            if (image) {
                self.image = image;
            }else{
                image = placeholderImage;
            }
            
            
            if (completion) {
                completion(image,[NSURL fileURLWithPath:imagestr],0,YYWebImageStageFinished,nil);
            }
            
            return;
        }
    });
    
    NSURL *imageChangeUrl = [self ImageStrWithImageType:imagetype_options ImageStr:imagestr ViewSize:viewsize];
    
    [self setImageWithURL:imageChangeUrl placeholder:placeholderImage options:YYWebImageOptionAllowInvalidSSLCertificates|kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (progress) {
            progress(receivedSize,expectedSize);
        }
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (completion) {
            completion(image,url,from,stage,error);
        }
    }];
    
}

/*********************************************************************************************/
- (NSURL *)ImageStrWithImageType:(ImageType_HHJ)imagetype_options ImageStr:(NSString*)imagestr ViewSize:(CGSize)viewsize{
    
    switch (imagetype_options) {
        case ImageType_HHJ_imageviewFramefill:
        {
            if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
                NSAssert(CGSizeEqualToSize(self.bounds.size, CGSizeZero), @"请给控件赋值frame");
            }
            
            imagestr = [imagestr stringByAppendingFormat:@"?imageView2/1/w/%ld/h/%ld/format/webp",(NSInteger)self.bounds.size.width*4,(NSInteger)self.bounds.size.height*4];
            
        }
            break;
        case ImageType_HHJ_imageviewFramefit:
        {
            if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
                NSAssert(CGSizeEqualToSize(self.bounds.size, CGSizeZero), @"请给控件赋值frame");
            }
            imagestr = [imagestr stringByAppendingFormat:@"?imageView2/2/w/%ld/h/%ld/format/webp",(NSInteger)self.bounds.size.width*4,(NSInteger)self.bounds.size.height*4];
        }
            break;
        case ImageType_HHJ_imageslim:
        {
            imagestr = [imagestr stringByAppendingString:@"?imageslim"];
            if (self.WaterText.length) {
                NSString *namebase64str = self.WaterText;
                namebase64str = [namebase64str base64EncodedString];
                namebase64str = [namebase64str stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
                namebase64str = [namebase64str stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
                
                imagestr = [imagestr stringByAppendingFormat:@"|watermark/3/image/aHR0cHM6Ly9pLmhlbmdoYWppYW5nLmNvbS9pY29uX3NodWl5aW4ucG5n/gravity/SouthEast/text/%@/gravity/Center/fontsize/480/fill/IzY2NjY2Ng==",namebase64str];
            }
        }
            break;
        case ImageType_HHJ_frame_fill_diy:
        {
            if (CGSizeEqualToSize(viewsize, CGSizeZero)) {
                NSAssert(CGSizeEqualToSize(viewsize, CGSizeZero), @"请设置子自定义的Size");
            }
            
            imagestr = [imagestr stringByAppendingFormat:@"?imageView2/1/w/%ld/h/%ld/format/webp",(NSInteger)viewsize.width,(NSInteger)viewsize.height];
        }
            
            break;
        case ImageType_HHJ_frame_fit_diy:
        {
            if (CGSizeEqualToSize(viewsize, CGSizeZero)) {
                NSAssert(CGSizeEqualToSize(viewsize, CGSizeZero), @"请设置子自定义的Size");
            }
            imagestr = [imagestr stringByAppendingFormat:@"?imageView2/2/w/%ld/h/%ld/format/webp",(NSInteger)viewsize.width,(NSInteger)viewsize.height];
        }
            break;
        case ImageType_HHJ_default:
        {
            
        }
            break;
        default:
            break;
    }
    
    imagestr = [imagestr stringByReplacingOccurrencesOfString:@"http://ol3kbnsgc.bkt.clouddn.com" withString:@"https://i.henghajiang.com"];
    imagestr = [imagestr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *imageurl = [NSURL URLWithString:imagestr];
    
    return imageurl;
}

@end

