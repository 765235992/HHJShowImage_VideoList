//
//  TZImagePickerController+Wave.h
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/10/18.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import <TZImagePickerController/TZImagePickerController.h>

@interface TZImagePickerController (Wave)

@property (nonatomic, copy) void (^didFinishPickingPhotoModelsHandle)(NSArray<TZAssetModel *> *photoModels,BOOL isSelectOriginalPhoto);

/**
 选中时直接完成(主要用于图片搜索)
 */
@property (nonatomic, assign) BOOL NeedSelect2Done;

@end
