//
//  TZAssetModel+Wave.h
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/10/17.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import <TZImagePickerController/TZImagePickerController.h>
@class HHJMediaObj;

@interface TZAssetModel (Wave)

/**
 展示的图片
 */
@property (nonatomic, strong) UIImage *image;

/**
 网络展示数据 ：NSString/NSURL
 */
@property (nonatomic, strong) id netWorkObjUrl;

+ (instancetype)ChangeModeToHHJMediaObj:(HHJMediaObj*)hhjmediaobj;

@end
