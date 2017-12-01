//
//  HHJPhotoPreviewController.h
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/10/12.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import <TZImagePickerController/TZPhotoPreviewController.h>
@class TZAssetModel;

@interface HHJPhotoPreviewController : TZPhotoPreviewController

@property (nonatomic, copy) void (^doneButtonClickBlockWithModelsPreviewType)(NSArray<TZAssetModel *> *photoModels,BOOL isSelectOriginalPhoto);

@end
