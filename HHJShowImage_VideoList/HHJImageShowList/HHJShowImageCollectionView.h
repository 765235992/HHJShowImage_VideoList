//
//  HHJShowImageCollectionView.h
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/9/28.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "HHJMediaObj.h"
#import "LxGridViewFlowLayout.h"


typedef NS_ENUM(NSUInteger, HHJImagePickerType) {
    ///列表展示、相册只包含图片
    HHJImagePickerType_Image = 0,
    ///列表展示、相册只包含视频
    HHJImagePickerType_Video = 1,
    ///列表展示、相册包含图片、视频
    HHJImagePickerType_Image_Video = 2,
    ///外部控制选择图片/视频，以及展示图片/视频
    HHJImagePickerType_NotAuto = 3
};



@interface HHJShowImageCollectionView : UICollectionView
///最大选中数量，为0或NSIntegerMax 为不显示选择数量大小，默认：0
@property (nonatomic, assign) NSInteger Maxnum;

///只做展示，不能去相册选择视频、图片,不做删除视频、图片，默认：NO
@property (nonatomic, assign) BOOL OnlyShow;

@property (nonatomic, assign) HHJImagePickerType imagepickertype;

/**
 图片布局类型 UIViewContentMode
 */
@property (nonatomic, assign) UIViewContentMode imagecontentmode;

///预填充的展示云端数据
/*   1、HHJMediaObj HHJMediaObj *hhjmediaobj = [HHJMediaObj new];
     hhjmediaobj.netWorkObjUrl = networkobj;
     hhjmediaobj.mediaObjType = HHJMediaObjType_Image;
     2、NSString/NSURL类型->仅支持加载图片类型，不支持视频。加载视频请选择第1种方式
     3、不支持其他类型
 */
@property (nonatomic, strong) NSArray *NetWorkObjArray;

/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray *MediaObjArray;

-(instancetype)initWithFrame:(CGRect)frame customizationBlock:( void (^)(HHJShowImageCollectionView *hhjcollectinview,LxGridViewFlowLayout *layout) )customizationblock ComFinishedBlock:( void (^)(void) )comfinishedblock;


/**
 数量发生改变是执行
 */
@property (nonatomic, copy) void (^progressBlock)(NSArray <HHJMediaObj*>*SubMediaObjArray);

/**
 添加图片或视频执行：默认不实现，由控件内部实现添加图片或视频
 */
@property (nonatomic, copy) void (^clickAddObjBlock)(NSArray <HHJMediaObj*>*SubMediaObjArray);

/**
 点击图片或视频执行：默认不实现，由控件内部实现预览图片或视频
 */
@property (nonatomic, copy) void (^clickItemObjBlock)(NSArray <HHJMediaObj*>*SubMediaObjArray, NSInteger index);

@end


