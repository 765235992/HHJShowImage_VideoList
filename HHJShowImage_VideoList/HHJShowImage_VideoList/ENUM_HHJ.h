//
//  ENUM_HHJ.h
//  HengHa
//
//  Created by 哼哈匠 on 2017/9/27.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#ifndef ENUM_HHJ_h
#define ENUM_HHJ_h
///加载网络图片类型
typedef NS_ENUM(NSUInteger, ImageType_HHJ) {
    ///改完图片网址链接，根据图片控件大小四倍大小获取居中裁剪图片
    ImageType_HHJ_imageviewFramefill = 0,
    ///改完图片网址链接，根据图片控件大小四倍大小获取缩略图片
    ImageType_HHJ_imageviewFramefit = 1,
    ///改完图片网址链接，获取瘦身后的图片
    ImageType_HHJ_imageslim = 2,
    ///改完图片网址链接，根据自定义大小获取居中裁剪图片
    ImageType_HHJ_frame_fill_diy = 98,
    ///改完图片网址链接，根据自定义大小获取缩略图片
    ImageType_HHJ_frame_fit_diy = 99,
    ///不改变图片链接，原图访问
    ImageType_HHJ_default = 100,
};

#endif /* ENUM_HHJ_h */
