//
//  TZImagePickerController+Wave.m
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/10/18.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import "TZImagePickerController+Wave.h"
#import <objc/runtime.h>

@implementation TZImagePickerController (Wave)

static char array_TZAssetModels;
static char NeedSelect2Done_TZAssetModels;

- (void)setDidFinishPickingPhotoModelsHandle:(void (^)(NSArray<TZAssetModel *> *, BOOL))didFinishPickingPhotoModelsHandle{
    objc_setAssociatedObject(self, &array_TZAssetModels, didFinishPickingPhotoModelsHandle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void (^)(NSArray<TZAssetModel *> *, BOOL))didFinishPickingPhotoModelsHandle{
    return objc_getAssociatedObject(self, &array_TZAssetModels);
}

-(void)setNeedSelect2Done:(BOOL)NeedSelect2Done{
    objc_setAssociatedObject(self, &NeedSelect2Done_TZAssetModels, @(NeedSelect2Done), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)NeedSelect2Done{
    
    return [objc_getAssociatedObject(self, &NeedSelect2Done_TZAssetModels) boolValue];
}
@end
