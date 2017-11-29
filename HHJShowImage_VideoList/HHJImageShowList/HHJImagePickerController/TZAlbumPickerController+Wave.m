//
//  TZAlbumPickerController+Wave.m
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/10/13.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import "TZAlbumPickerController+Wave.h"
#import "HHJPhotoPickerController.h"

@implementation TZAlbumPickerController (Wave)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选择中了");
    
    NSArray *showalbumArr = nil;
    
//    unsigned int count = 0;
//    objc_property_t *PropertyList = class_copyPropertyList([TZAlbumPickerController class], &count);
//    for (int i = 0; i < count; i++)
//    {
//        objc_property_t property = PropertyList[i];
//        NSString *propertyName = [[NSString alloc]initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
//        if (![propertyName isEqualToString:@"albumArr"]) {
//            continue;
//        }
//
//    }
    id propertyValue = [self valueForKey:@"albumArr"];
    
    showalbumArr = propertyValue;
    if (!showalbumArr.count) {
        return;
    }
    HHJPhotoPickerController *photoPickerVc = [[HHJPhotoPickerController alloc] init];
    photoPickerVc.columnNumber = self.columnNumber;
    TZAlbumModel *model = showalbumArr[indexPath.row];
    photoPickerVc.model = model;
    [self.navigationController pushViewController:photoPickerVc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

@end
