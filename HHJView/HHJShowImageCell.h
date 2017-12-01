//
//  HHJShowImageCell.h
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/9/28.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HHJMediaObj;

@interface HHJShowImageCell : UICollectionViewCell

@property (nonatomic, readonly, strong) HHJMediaObj *hhjmediaobj;

@property (nonatomic, assign) UIViewContentMode imagecontentmode;

///只做展示，不能去相册选择视频、图片,不做删除视频、图片，默认：NO
@property (nonatomic, assign) BOOL OnlyShow;

@property (nonatomic, copy) void (^clickDeleteBtBlock)(HHJShowImageCell *SubCell, UIButton *deletebt);

- (void) updateConstraintsWithObj:(HHJMediaObj*)hhjmediaobj;

- (UIView *)snapshotView;

@end
