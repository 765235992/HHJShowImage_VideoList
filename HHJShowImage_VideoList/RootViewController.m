//
//  RootViewController.m
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/9/27.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import "RootViewController.h"
#import "HHJShowImageCollectionView.h"

@interface RootViewController ()


@end

@implementation RootViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"HHJShowImage_VideoList";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    HHJShowImageCollectionView *imagecoll = [[HHJShowImageCollectionView alloc]initWithFrame:CGRectMake(0, 64+50, self.view.bounds.size.width, 120) customizationBlock:^(HHJShowImageCollectionView *hhjcollectinview, LxGridViewFlowLayout *layout) {
        //@"https://i.henghajiang.com/bbc664ee-1b3a-11e7-b3a0-00163e0677f9.jpg"
        hhjcollectinview.Maxnum = 5;
        HHJMediaObj *mediaobj = [HHJMediaObj new];
        mediaobj.netWorkObjUrl = @"http://shortvideo.pdex-service.com/short_video_20171023154340.mp4";
        mediaobj.mediaObjType = HHJMediaObjType_Video;
        hhjcollectinview.NetWorkObjArray = @[mediaobj];
        hhjcollectinview.imagepickertype = HHJImagePickerType_Image_Video;
        hhjcollectinview.imagecontentmode = UIViewContentModeScaleAspectFill;
        
        
    } ComFinishedBlock:nil];
    [self.view addSubview:imagecoll];
 
    
    
    NSArray *dataarray =
  @[
  @[@1,@2],
  @[@1,@2,@4],
  @[@1,@2,@5],
  @[@1]
  ];
    
    NSMutableArray *dataarray1 = [
  @[@[@1,@2],
  @[@1,@2],
  @[@1,@2,@4],
  @[@1,@2,@5],
  @[@1]] mutableCopy];
    

    

    NSMutableArray *marray = [@[] mutableCopy];
    
    NSInteger sectins = [dataarray1 count];
    
    
    for (NSInteger i = 0; i<dataarray.count; i++ ) {
        
        NSArray *subarray = dataarray[i];
        NSArray *subarray1 = dataarray1[i];
        NSInteger rows = [subarray1 count];
        
        if (subarray.count == rows) {
            if ([subarray1 isEqualToArray:subarray]) {
                continue;
            }
            
            BOOL ishave = [subarray1 containsObject: subarray.firstObject];
            
            if (ishave) {
                NSInteger row = [subarray1 indexOfObject:@""];
                NSInteger section = i;
                
                [marray removeAllObjects];
                [marray addObjectsFromArray:subarray1];
                
                [marray removeObjectsInArray:subarray];
                
                for (NSInteger index = 0; index < marray.count; index++) {
                    id obj = marray[index];
                    row = [subarray1 indexOfObject:obj];
                }
                
            }else{
                NSInteger section = i;//remove
            }
        }
        
    }
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
