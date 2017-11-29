//
//  TZAssetPreviewCell+Wave.m
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/10/19.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import "TZAssetPreviewCell+Wave.h"

@implementation TZAssetPreviewCell (Wave)

-(void)setModel:(TZAssetModel *)model{
    [self setValue:model forKey:@"_model"];
    
    if ([NSStringFromClass(self.class) isEqualToString:@"TZPhotoPreviewCell"]) {
       id previewViewValue =  [self valueForKey:@"previewView"];
        if (previewViewValue) {
           [previewViewValue setValue:model forKey:@"model"];
        }  
    }
    
}



@end
