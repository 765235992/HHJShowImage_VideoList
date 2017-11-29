//
//  HHJImagePickerViewController.m
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/10/11.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import "HHJImagePickerViewController.h"
#import "HHJPhotoPreviewController.h"
#import <UIView+Layout.h>
#import <TZImageManager.h>
#import "HHJPhotoPickerController.h"
#import <UIColor+YYAdd.h>
#import "TZImagePickerController+Wave.h"

@interface HHJImagePickerViewController (){
    BOOL _didHHJPushPhotoPickerVc;
    BOOL _HHJpushPhotoPickerVc;
}


@property (nonatomic, assign) NSInteger HHJcolumnNumber;

@end

@implementation HHJImagePickerViewController

-(instancetype)initWithSelectedAssets:(NSMutableArray *)selectedAssets selectedPhotos:(NSMutableArray *)selectedPhotos index:(NSInteger)index{
    
    HHJPhotoPreviewController *previewVc = [[HHJPhotoPreviewController alloc] init];
    self = [super initWithRootViewController:previewVc];
    if (self) {
        
        self.selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
        self.allowPickingOriginalPhoto = self.allowPickingOriginalPhoto;
        [self configDefaultSetting];
        
        previewVc.photos = [NSMutableArray arrayWithArray:selectedPhotos];
        previewVc.currentIndex = index;
        __weak typeof(self) weakSelf = self;
        [previewVc setDoneButtonClickBlockWithPreviewType:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                if (weakSelf.didFinishPickingPhotosHandle) {
                    weakSelf.didFinishPickingPhotosHandle(photos,assets,isSelectOriginalPhoto);
                }
            }];
        }];
    }
    
    return self;
}

-(instancetype)initWithSelectedModels:(NSMutableArray *)selectedModels index:(NSInteger)index{
    HHJPhotoPreviewController *previewVc = [[HHJPhotoPreviewController alloc] init];
    self = [super initWithRootViewController:previewVc];
    if (self) {
        
        
        self.allowPickingOriginalPhoto = self.allowPickingOriginalPhoto;
        [self configDefaultSetting];
        self.selectedModels = [NSMutableArray arrayWithArray:selectedModels];
        previewVc.models = [NSMutableArray arrayWithArray:selectedModels];
        previewVc.currentIndex = index;
        
        __weak typeof(self) weakSelf = self;
        /*
        [previewVc setDoneButtonClickBlockWithPreviewType:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                if (weakSelf.didFinishPickingPhotosHandle) {
                    weakSelf.didFinishPickingPhotosHandle(photos,assets,isSelectOriginalPhoto);
                }
            }];
        }];
        */
        [previewVc setDoneButtonClickBlockWithPreviewType:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                if (weakSelf.didFinishPickingPhotoModelsHandle) {
                    weakSelf.didFinishPickingPhotoModelsHandle(weakSelf.selectedModels, isSelectOriginalPhoto);
                }
            }];
        }];
        
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHexString:@"d9d9d9"];
    line.frame = CGRectMake(0, self.navigationBar.tz_height-0.5, self.view.tz_width, 0.5);
    [self.navigationBar addSubview:line];
    self.oKButtonTitleColorNormal = [UIColor colorWithHexString:@"ffa200"];
    self.oKButtonTitleColorDisabled = [UIColor colorWithHexString:@"ffa200"];
}



- (void)configDefaultSetting {
    self.timeout = 15;
    self.photoWidth = 828.0;
    self.photoPreviewMaxWidth = 600;
    self.naviTitleColor = [UIColor whiteColor];
    self.naviTitleFont = [UIFont systemFontOfSize:17];
    self.barItemTextFont = [UIFont systemFontOfSize:15];
    self.barItemTextColor = [UIColor whiteColor];
    self.allowPreview = YES;
    
    [self configDefaultImageName];
    [self configDefaultBtnTitle];
    
    CGFloat cropViewWH = MIN(self.view.tz_width, self.view.tz_height) / 3 * 2;
    self.cropRect = CGRectMake((self.view.tz_width - cropViewWH) / 2, (self.view.tz_height - cropViewWH) / 2, cropViewWH, cropViewWH);
}

- (void)configDefaultImageName {
    self.takePictureImageName = @"takePicture";
    self.photoSelImageName = @"photo_sel_photoPickerVc_hhj";
    self.photoDefImageName = @"photo_def_photoPickerVc";
    self.photoNumberIconImageName = @"photo_number_icon_hhj";
    self.photoPreviewOriginDefImageName = @"preview_original_def";
    self.photoOriginDefImageName = @"photo_original_def";
    self.photoOriginSelImageName = @"photo_original_sel_hhj";
}

- (void)configDefaultBtnTitle {
    self.doneBtnTitleStr = [NSBundle tz_localizedStringForKey:@"Done"];
    self.cancelBtnTitleStr = [NSBundle tz_localizedStringForKey:@"Cancel"];
    self.previewBtnTitleStr = [NSBundle tz_localizedStringForKey:@"Preview"];
    self.fullImageBtnTitleStr = [NSBundle tz_localizedStringForKey:@"Full image"];
    self.settingBtnTitleStr = [NSBundle tz_localizedStringForKey:@"Setting"];
    self.processHintStr = [NSBundle tz_localizedStringForKey:@"Processing..."];
}


- (void)pushPhotoPickerVc {

    /**/
    _didHHJPushPhotoPickerVc = NO;
    _HHJpushPhotoPickerVc = [self valueForKey:@"_pushPhotoPickerVc"];
    // 1.6.8 判断是否需要push到照片选择页，如果_pushPhotoPickerVc为NO,则不push
    if (!_didHHJPushPhotoPickerVc && _HHJpushPhotoPickerVc) {
        
        HHJPhotoPickerController *photoPickerVc = [[HHJPhotoPickerController alloc] init];
        photoPickerVc.isFirstAppear = YES;
        photoPickerVc.columnNumber = 4;
        [[TZImageManager manager] getCameraRollAlbum:self.allowPickingVideo allowPickingImage:self.allowPickingImage completion:^(TZAlbumModel *model) {
            photoPickerVc.model = model;
            [self pushViewController:photoPickerVc animated:YES];
            _didHHJPushPhotoPickerVc = YES;
        }];
    }
    
    TZAlbumPickerController *albumPickerVc = (TZAlbumPickerController *)self.visibleViewController;
    if ([albumPickerVc isKindOfClass:[TZAlbumPickerController class]]) {
        [albumPickerVc configTableView];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
