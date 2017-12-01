//
//  TZAssetModel+Wave.m
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/10/17.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import "TZAssetModel+Wave.h"
#import <TZImagePickerController/TZImageManager.h>
#import "HHJMediaObj.h"
#import <objc/runtime.h>

@implementation TZAssetModel (Wave)

static char image_TZAssetModel;
static char netWorkObjUrl_TZAssetModel;

-(void)setImage:(UIImage *)image{
    objc_setAssociatedObject(self, &image_TZAssetModel, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIImage *)image{
    return objc_getAssociatedObject(self, &image_TZAssetModel);
}

-(void)setNetWorkObjUrl:(id)netWorkObjUrl{
    objc_setAssociatedObject(self, &netWorkObjUrl_TZAssetModel, netWorkObjUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(id)netWorkObjUrl{
    return objc_getAssociatedObject(self, &netWorkObjUrl_TZAssetModel);
}

+ (instancetype)ChangeModeToHHJMediaObj:(HHJMediaObj *)hhjmediaobj{
  
    TZAssetModel *model = nil;
    
    if (hhjmediaobj.address_asset) {
        
        model = [self modelWithAsset:hhjmediaobj.asset type:[[TZImageManager manager] getAssetType:hhjmediaobj.asset]];
        model.isSelected = YES;
    }else{
        model = [[TZAssetModel alloc]init];
        model.image = hhjmediaobj.image;
        model.netWorkObjUrl = hhjmediaobj.netWorkObjUrl;
        
        TZAssetModelMediaType type = TZAssetModelMediaTypePhoto;
        
        if (hhjmediaobj.mediaObjType == HHJMediaObjType_Video) {
            type = TZAssetModelMediaTypeVideo;
        }

        model.type = type;
    }
    
    return model;
}

@end
