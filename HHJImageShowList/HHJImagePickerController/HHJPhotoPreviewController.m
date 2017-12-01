//
//  HHJPhotoPreviewController.m
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/10/12.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import "HHJPhotoPreviewController.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import <TZImagePickerController/TZImageManager.h>
#import <TZImagePickerController/UIView+Layout.h>

#import <TZImagePickerController/TZPhotoPreviewCell.h>
#import "TZAssetModel+Wave.h"


@interface HHJPhotoPreviewController (){
    UILabel *_HHJnumberLabel;
    UIImageView *_HHJnumberImageView;
    UILabel *_HHJoriginalPhotoLabel;
}

@end

@implementation HHJPhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _HHJnumberLabel = [self valueForKey:@"_numberLabel"];
    /**/
    if (_HHJnumberLabel) {
        [_HHJnumberLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
        [_HHJnumberLabel addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    _HHJnumberImageView = [self valueForKey:@"_numberImageView"];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"keyPath==%@  object===%@  change==%@",keyPath,object,change);
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    NSArray *NetWorkObjArray = nil;
    if ([NSStringFromClass(_tzImagePickerVc.class) isEqualToString:@"HHJImagePickerViewController"]) {
        
        NetWorkObjArray = [_tzImagePickerVc valueForKey:@"NetWorkObjArray"];
    }
    if ([keyPath isEqualToString:@"text"]) {
        NSString *text = [change valueForKey:NSKeyValueChangeNewKey];
        
        if (text.integerValue != _tzImagePickerVc.selectedModels.count+NetWorkObjArray.count) {
            _HHJnumberLabel.text = [NSString stringWithFormat:@"%zd",_tzImagePickerVc.selectedModels.count+NetWorkObjArray.count];
        }
        return;
    }
    
    if ([keyPath isEqualToString:@"hidden"]) {
        BOOL hidden = [[change valueForKey:NSKeyValueChangeNewKey] boolValue];
        BOOL numhidden = _tzImagePickerVc.selectedModels.count+NetWorkObjArray.count > 0 ? NO : YES;
        if (hidden != numhidden) {
            _HHJnumberLabel.hidden = numhidden;
            _HHJnumberImageView.hidden = numhidden;
        }
        
    }
 
}

#pragma mark - Click Event

- (void)select:(UIButton *)selectButton {
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    TZAssetModel *model = self.models[self.currentIndex];
    
    NSArray *_HHJassetsTemp = [self valueForKey:@"_assetsTemp"];
    NSArray *_HHJphotosTemp = [self valueForKey:@"_photosTemp"];
    
    if (!selectButton.isSelected) {
        
        NSArray *NetWorkObjArray = nil;
        if ([NSStringFromClass(_tzImagePickerVc.class) isEqualToString:@"HHJImagePickerViewController"]) {
            
            NetWorkObjArray = [_tzImagePickerVc valueForKey:@"NetWorkObjArray"];
        }
        
        // 1. select:check if over the maxImagesCount / 选择照片,检查是否超过了最大个数的限制
        if (_tzImagePickerVc.selectedModels.count+NetWorkObjArray.count >= _tzImagePickerVc.maxImagesCount) {
            NSString *title = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Select a maximum of %zd photos"], _tzImagePickerVc.maxImagesCount];
            [_tzImagePickerVc showAlertWithTitle:title];
            return;
            // 2. if not over the maxImagesCount / 如果没有超过最大个数限制
        } else {
            [_tzImagePickerVc.selectedModels addObject:model];
            if (self.photos) {
                [_tzImagePickerVc.selectedAssets addObject:_HHJassetsTemp[self.currentIndex]];
                [self.photos addObject:_HHJphotosTemp[self.currentIndex]];
            }
            if (model.type == TZAssetModelMediaTypeVideo && !_tzImagePickerVc.allowPickingMultipleVideo) {
                [_tzImagePickerVc showAlertWithTitle:[NSBundle tz_localizedStringForKey:@"Select the video when in multi state, we will handle the video as a photo"]];
            }
        }
    } else {
        NSArray *selectedModels = [NSArray arrayWithArray:_tzImagePickerVc.selectedModels];
        for (TZAssetModel *model_item in selectedModels) {
            if ([[[TZImageManager manager] getAssetIdentifier:model.asset] isEqualToString:[[TZImageManager manager] getAssetIdentifier:model_item.asset]]) {
                // 1.6.7版本更新:防止有多个一样的model,一次性被移除了
                NSArray *selectedModelsTmp = [NSArray arrayWithArray:_tzImagePickerVc.selectedModels];
                for (NSInteger i = 0; i < selectedModelsTmp.count; i++) {
                    TZAssetModel *model = selectedModelsTmp[i];
                    if ([model isEqual:model_item]) {
                        [_tzImagePickerVc.selectedModels removeObjectAtIndex:i];
                        break;
                    }
                }
                // [_tzImagePickerVc.selectedModels removeObject:model_item];
                if (self.photos) {
                    // 1.6.7版本更新:防止有多个一样的asset,一次性被移除了
                    NSArray *selectedAssetsTmp = [NSArray arrayWithArray:_tzImagePickerVc.selectedAssets];
                    for (NSInteger i = 0; i < selectedAssetsTmp.count; i++) {
                        id asset = selectedAssetsTmp[i];
                        if ([asset isEqual:_HHJassetsTemp[self.currentIndex]]) {
                            [_tzImagePickerVc.selectedAssets removeObjectAtIndex:i];
                            break;
                        }
                    }
                    // [_tzImagePickerVc.selectedAssets removeObject:_assetsTemp[_currentIndex]];
                    [self.photos removeObject:_HHJphotosTemp[self.currentIndex]];
                }
                break;
            }
        }
    }
    model.isSelected = !selectButton.isSelected;
    [self refreshNaviBarAndBottomBarState];
    if (model.isSelected) {
        [UIView showOscillatoryAnimationWithLayer:selectButton.imageView.layer type:TZOscillatoryAnimationToBigger];
    }
    UIImageView *_HHJnumberImageView = [self valueForKey:@"_numberImageView"];
    [UIView showOscillatoryAnimationWithLayer:_HHJnumberImageView.layer type:TZOscillatoryAnimationToSmaller];
}

- (void)refreshNaviBarAndBottomBarState {
    TZImagePickerController *_tzImagePickerVc = (TZImagePickerController *)self.navigationController;
    TZAssetModel *model = self.models[self.currentIndex];
    
    UIButton *_HHJselectButton = [self valueForKey:@"_selectButton"];
//    UILabel *_HHJnumberLabel = [self valueForKey:@"_numberLabel"];
//    UIImageView *_HHJnumberImageView = [self valueForKey:@"_numberImageView"];
    
    _HHJselectButton.selected = model.isSelected;
    _HHJnumberLabel.text = [NSString stringWithFormat:@"%zd",_tzImagePickerVc.selectedModels.count];
    
    BOOL _HHJisHideNaviBar = [[self valueForKey:@"isHideNaviBar"] boolValue];
    
    _HHJnumberImageView.hidden = (_tzImagePickerVc.selectedModels.count <= 0 || _HHJisHideNaviBar || self.isCropImage);
    _HHJnumberLabel.hidden = (_tzImagePickerVc.selectedModels.count <= 0 || _HHJisHideNaviBar || self.isCropImage);
    UIButton *_HHJoriginalPhotoButton = [self valueForKey:@"_originalPhotoButton"];
    _HHJoriginalPhotoLabel = [self valueForKey:@"_originalPhotoLabel"];
    
    _HHJoriginalPhotoButton.selected = self.isSelectOriginalPhoto;
    _HHJoriginalPhotoLabel.hidden = !_HHJoriginalPhotoButton.isSelected;
    if (self.isSelectOriginalPhoto) [self showPhotoBytes];
    
    // If is previewing video, hide original photo button
    // 如果正在预览的是视频，隐藏原图按钮
    if (!_HHJisHideNaviBar) {
        if (model.type == TZAssetModelMediaTypeVideo) {
            _HHJoriginalPhotoButton.hidden = YES;
            _HHJoriginalPhotoLabel.hidden = YES;
        } else {
            _HHJoriginalPhotoButton.hidden = NO;
            if (self.isSelectOriginalPhoto)  {
                _HHJoriginalPhotoLabel.hidden = NO;
            }
            
            if (!model.asset) {
                _HHJoriginalPhotoButton.hidden = YES;
                _HHJoriginalPhotoLabel.hidden = YES;
            }
            
        }
    }
    
    UIButton *_HHJdoneButton = [self valueForKey:@"_doneButton"];
    
    _HHJdoneButton.hidden = NO;
    _HHJselectButton.hidden = !_tzImagePickerVc.showSelectBtn;
    // 让宽度/高度小于 最小可选照片尺寸 的图片不能选中
    if (![[TZImageManager manager] isPhotoSelectableWithAsset:model.asset]) {
        _HHJnumberLabel.hidden = YES;
        _HHJnumberImageView.hidden = YES;
        _HHJselectButton.hidden = YES;
        _HHJoriginalPhotoButton.hidden = YES;
        _HHJoriginalPhotoLabel.hidden = YES;
        _HHJdoneButton.hidden = YES;
    }
}

- (void)showPhotoBytes {
    [[TZImageManager manager] getPhotosBytesWithArray:@[self.models[self.currentIndex]] completion:^(NSString *totalBytes) {
        _HHJoriginalPhotoLabel.text = [NSString stringWithFormat:@"(%@)",totalBytes];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [_HHJnumberLabel removeObserver:self forKeyPath:@"text"];
    [_HHJnumberLabel removeObserver:self forKeyPath:@"hidden"];
    
    UILabel *releaseLabel = _HHJnumberLabel;
    UIImageView *releaseImageView = _HHJnumberImageView;
    
    _HHJnumberLabel = nil;
    _HHJnumberImageView = nil;
    dispatch_queue_t queue_release = dispatch_queue_create("ReleaseQueue", NULL);
    dispatch_async(queue_release, ^{
        [releaseLabel class];
        [releaseImageView class];
    });
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
