//
//  HHJMediaObj.h
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/9/28.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef NS_ENUM(NSUInteger, HHJMediaObjType) {
    ///图片类型
    HHJMediaObjType_Image = 0,
    ///视频类型
    HHJMediaObjType_Video = 1,
    ///UIImage类型
    HHJMediaObjType_UIImage = 2,
};

@interface HHJMediaObj : NSObject

/**
 相册选择的数据(图片/视频)
 */
@property (nonatomic, assign) PHAsset *asset;


/**
 asset的内存地址
 */
@property (nonatomic, strong) NSString *address_asset;

/**
 展示的图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 网络展示数据 ：NSString/NSURL
 */
@property (nonatomic, strong) id netWorkObjUrl;

/**
 数据类型
 */
@property (nonatomic, assign) HHJMediaObjType mediaObjType;

@end
