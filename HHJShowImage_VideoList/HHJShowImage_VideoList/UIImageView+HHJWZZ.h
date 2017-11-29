//
//  UIImageView+HHJWZZ.h
//  HengHa
//
//  Created by 哼哈匠 on 2017/9/27.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ENUM_HHJ.h"
#import <UIImageView+YYWebImage.h>

@interface UIImageView (HHJWZZ)


/**
 用于显示文字水印的文字，只要显示文字水印同步显示图片水印->图片水印居于图片右下角,文字居于图片中间
 */
@property (nonatomic, strong) NSString *WaterText;

- (void)setImageStr:(NSString*)imagestr placeholderImage:(UIImage*)placeholderImage ImageType_Options:(ImageType_HHJ)imagetype_options ViewSize:(CGSize)viewsize;

- (void)setImageStr:(NSString*)imagestr placeholderImage:(UIImage*)placeholderImage ImageType_Options:(ImageType_HHJ)imagetype_options ViewSize:(CGSize)viewsize Progress:(YYWebImageProgressBlock)progress completion:(YYWebImageCompletionBlock)completion;

@end

