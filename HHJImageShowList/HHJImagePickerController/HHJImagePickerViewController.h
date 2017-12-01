//
//  HHJImagePickerViewController.h
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/10/11.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import <TZImagePickerController/TZImagePickerController.h>
#import "TZImagePickerController+Wave.h"

@interface HHJImagePickerViewController : TZImagePickerController

/**
 已填充图片数据数组
 */
@property (nonatomic, strong) NSArray *NetWorkObjArray;


-(instancetype)initWithSelectedModels:(NSMutableArray *)selectedModels index:(NSInteger)index;

@end
