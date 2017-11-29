//
//  HHJShowImageCollectionView.m
//  HHJShowImage_VideoList
//
//  Created by 哼哈匠 on 2017/9/28.
//  Copyright © 2017年 NameWzz. All rights reserved.
//

#import "HHJShowImageCollectionView.h"
#import "HHJShowImageCell.h"
#import "HHJImagePickerViewController.h"
#import <UIColor+YYAdd.h>
#import "TZAssetModel+Wave.h"
#import "TZImagePickerController+Wave.h"

@interface HHJShowImageCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>{
    
    NSMutableArray *addressArray;
    NSMutableArray *HHJNetWorkArray;
}

@property (nonatomic, strong) NSMutableArray *ChangeArray;

@property (nonatomic, strong) NSMutableArray *AssetsArray;

@property (nonatomic, strong) NSMutableArray *PhotosArray;

@end

@implementation HHJShowImageCollectionView

-(instancetype)initWithFrame:(CGRect)frame customizationBlock:( void (^)(HHJShowImageCollectionView *hhjcollectinview,LxGridViewFlowLayout *layout) )customizationblock ComFinishedBlock:( void (^)(void) )comfinishedblock{
    
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    layout.itemSize = CGSizeMake(frame.size.height, frame.size.height);
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _MediaObjArray = [@[] mutableCopy];
        self.OnlyShow = NO;
        self.NetWorkObjArray = nil;
        self.dataSource = self;
        self.delegate = self;
        self.imagecontentmode = UIViewContentModeScaleAspectFit;
        if (customizationblock) {
            customizationblock(self,layout);
            self.collectionViewLayout = layout;
        }
        if (!_MediaObjArray.count) {
            
            NSAssert(_MediaObjArray, @"数据源数组被置nil了！");
        }
        if (_NetWorkObjArray.count) {
            for (NSInteger i = 0; i < _NetWorkObjArray.count; i++) {
                id networkobj = _NetWorkObjArray[i];
                if ([networkobj isKindOfClass:[HHJMediaObj class]]) {
                    [_MediaObjArray addObject:networkobj];
                }else{
                    if ([networkobj isKindOfClass:[NSString class]]||[networkobj isKindOfClass:[NSURL class]]) {
                        HHJMediaObj *hhjmediaobj = [HHJMediaObj new];
                        hhjmediaobj.netWorkObjUrl = networkobj;
                        hhjmediaobj.mediaObjType = HHJMediaObjType_Image;
                        [_MediaObjArray addObject:hhjmediaobj];
                    }else{
                       NSAssert([networkobj isKindOfClass:[NSURL class]]||[networkobj isKindOfClass:[NSString class]], @"请检查数据类型");
                    }
  
                }
            }
        }
        
        [self registerClass:[HHJShowImageCell class] forCellWithReuseIdentifier:@"HHJShowImageCell"];
        if (comfinishedblock) {
            comfinishedblock();
        }
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self reloadData];
}

#pragma mark - UICollectionViewDataSource &&UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (_OnlyShow) {
        return _MediaObjArray.count;
    }
    if (_Maxnum == 0||_Maxnum == NSIntegerMax) {
        return _MediaObjArray.count+1;
    }
    
    if (_MediaObjArray.count == _Maxnum) {
        return _MediaObjArray.count;
    }
    
    return _MediaObjArray.count+1;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HHJShowImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HHJShowImageCell" forIndexPath:indexPath];
    cell.imagecontentmode = _imagecontentmode;
    cell.OnlyShow = _OnlyShow;
    __weak typeof(self) weakself = self;
    if (!cell.clickDeleteBtBlock) {
        
        [cell setClickDeleteBtBlock:^(HHJShowImageCell *SubCell, UIButton *deletebt) {
            
            NSIndexPath *subIndexPath = [collectionView indexPathForItemAtPoint:SubCell.frame.origin];
            [weakself DeleteBtClickWithIndexPath:subIndexPath];
            
        }];
    }
    if (indexPath.item >= _MediaObjArray.count) {
        
        if (!_OnlyShow) {
            [cell updateConstraintsWithObj:nil];
        }
        
        return cell;
    }
    
    HHJMediaObj *mediaobj = _MediaObjArray[indexPath.item];
    
    [cell updateConstraintsWithObj:mediaobj];
    
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)collectionViewLayout;
    
    return layout.itemSize;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) weakself = self;
    
    BOOL allowPickingVideo = _imagepickertype != HHJImagePickerType_Image;
    BOOL allowPickingImage = _imagepickertype != HHJMediaObjType_Video;
    
    if (indexPath.item == _MediaObjArray.count) {
        
        if (self.clickAddObjBlock) {
            self.clickAddObjBlock(_MediaObjArray);
            return;
        }
        
        HHJImagePickerViewController *hhjpicker = [[HHJImagePickerViewController alloc]initWithMaxImagesCount:_Maxnum columnNumber:4 delegate:nil];
        hhjpicker.allowPickingOriginalPhoto = YES;
        hhjpicker.selectedAssets = self.AssetsArray;
        hhjpicker.showSelectBtn = YES;
        hhjpicker.allowCrop = NO;
        hhjpicker.allowPickingVideo = allowPickingVideo;
        hhjpicker.allowPickingImage = allowPickingImage;
        hhjpicker.allowPickingMultipleVideo = YES;
        hhjpicker.sortAscendingByModificationDate = NO;
        hhjpicker.alwaysEnableDoneBtn = YES;
        hhjpicker.isStatusBarDefault = YES;
        hhjpicker.naviBgColor = [UIColor whiteColor];
        hhjpicker.naviTitleColor = [UIColor colorWithHexString:@"333333"];
        hhjpicker.barItemTextColor = [UIColor colorWithHexString:@"333333"];
//        hhjpicker.NetWorkObjArray = _NetWorkObjArray;
        
        hhjpicker.NeedSelect2Done = YES;
        
        [hhjpicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [weakself ChangeMediaArrayWithAssets:assets Photos:photos];
        }];
        [[self LocationViewController] presentViewController:hhjpicker animated:YES completion:nil];
        
        return;
    }
    
    if (self.clickItemObjBlock) {
        self.clickItemObjBlock(_MediaObjArray, indexPath.item);
        return;
    }
    
    NSMutableArray *modearray = [NSMutableArray array];
    for (NSInteger i = 0; i < _MediaObjArray.count; i++) {
        HHJMediaObj *hhjmediaobj = _MediaObjArray[i];
        TZAssetModel *model = [TZAssetModel ChangeModeToHHJMediaObj:hhjmediaobj];
        model.isSelected = YES;
        [modearray addObject:model];
    }
    
    HHJImagePickerViewController *hhjpicker = nil;//[[HHJImagePickerViewController alloc]initWithSelectedAssets:self.AssetsArray selectedPhotos:self.PhotosArray index:indexPath.item];
    hhjpicker = [[HHJImagePickerViewController alloc]initWithSelectedModels:modearray index:indexPath.item];
    hhjpicker.allowPickingVideo = allowPickingVideo;
    hhjpicker.allowPickingImage = allowPickingImage;
    hhjpicker.allowPickingMultipleVideo = YES;
    hhjpicker.maxImagesCount = _Maxnum;
    hhjpicker.allowPickingOriginalPhoto = YES;
    hhjpicker.isStatusBarDefault = YES;
    /*
    [hhjpicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [weakself ChangeMediaArrayWithAssets:assets Photos:photos];
    }];
    */
    [hhjpicker setDidFinishPickingPhotoModelsHandle:^(NSArray<TZAssetModel *> *photoModels, BOOL isSelectOriginalPhoto) {
        [weakself ChangeArrayWithTZAssetModelsArray:photoModels];
    }];
    
    [[self LocationViewController] presentViewController:hhjpicker animated:YES completion:nil];
    
}

- (void)ChangeArrayWithTZAssetModelsArray:(NSArray <TZAssetModel*>*)modelsarray{
    
    
    if (_MediaObjArray.count >= modelsarray.count) {
        [_MediaObjArray removeObjectsInRange:NSMakeRange(modelsarray.count, _MediaObjArray.count-modelsarray.count)];
    }
    
    [self.AssetsArray removeAllObjects];
    for (NSInteger i = 0; i < modelsarray.count; i++) {
        
        TZAssetModel *model = modelsarray[i];
        
        HHJMediaObj *mediaobj = nil;
        if (i < _MediaObjArray.count) {
            mediaobj = _MediaObjArray[i];
            mediaobj = [self ChangeHHJMediaObj:mediaobj WithTZAssetModel:model];
            
            [_MediaObjArray replaceObjectAtIndex:i withObject:mediaobj];
        }else{
            mediaobj = [HHJMediaObj new];
            mediaobj = [self ChangeHHJMediaObj:mediaobj WithTZAssetModel:model];
            [_MediaObjArray addObject:mediaobj];
        }
        
        if (mediaobj.asset) {
            [self.AssetsArray addObject:mediaobj.asset];
        }
        
    }
    
    if (self.progressBlock) {
        self.progressBlock(_MediaObjArray);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView setAnimationsEnabled:NO];
        [self reloadData];
        [UIView setAnimationsEnabled:YES];
    });
    
}

-(HHJMediaObj*)ChangeHHJMediaObj:(HHJMediaObj*)hhjmediaobj WithTZAssetModel:(TZAssetModel*)model {
    hhjmediaobj.image = model.image;
    hhjmediaobj.netWorkObjUrl = model.netWorkObjUrl;
    hhjmediaobj.asset = model.asset;
    if (hhjmediaobj.asset) {
        hhjmediaobj.address_asset = [NSString stringWithFormat:@"%p",hhjmediaobj.asset];
    }
    
    HHJMediaObjType mediatype = HHJMediaObjType_Image;
    
    if (model.type == TZAssetModelMediaTypeVideo) {
        mediatype = HHJMediaObjType_Video;
    }
    
    hhjmediaobj.mediaObjType = mediatype;
    
    return hhjmediaobj;
}

- (void)ChangeArrayWithModelsArray:(NSArray<HHJMediaObj*>*)modelsarray{
    
    [_MediaObjArray removeAllObjects];
    [_MediaObjArray addObjectsFromArray:modelsarray];
    
    if (self.progressBlock) {
        self.progressBlock(_MediaObjArray);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView setAnimationsEnabled:NO];
        [self reloadData];
        [UIView setAnimationsEnabled:YES];
    });
    
}

-(NSMutableArray *)AssetsArray{
    if (!_AssetsArray) {
        _AssetsArray = [@[] mutableCopy];
    }
    return _AssetsArray;
}

-(NSMutableArray *)PhotosArray{
    if (!_PhotosArray) {
        _PhotosArray = [@[] mutableCopy];
    }
    return _PhotosArray;
}

-(void)ChangeMediaArrayWithAssets:(NSArray*)assets Photos:(NSArray*)photos{
    NSAssert(assets.count == photos.count, @"数据数量不一致");
    
    if (!self.ChangeArray) {
       self.ChangeArray = [@[] mutableCopy];
    }
    [self.ChangeArray removeAllObjects];
    
  
    [self.AssetsArray removeAllObjects];
    [self.AssetsArray addObjectsFromArray:assets];
    
    [self.PhotosArray removeAllObjects];
    [self.PhotosArray addObjectsFromArray:photos];
    if (!addressArray) {
        addressArray = [@[] mutableCopy];
    }
    [addressArray removeAllObjects];
    
    for (NSInteger i = 0; i < assets.count; i++) {
        [addressArray addObject:[NSString stringWithFormat:@"%p",assets[i]]];
    }
    
    NSInteger index = 0;
    
    for (NSInteger i = 0; i < _MediaObjArray.count; i++) {
        HHJMediaObj *mediaobj = _MediaObjArray[i];
        
            if (mediaobj.address_asset) {
                if (index >= assets.count) {
                    continue;
                }
                
                NSString *address_asset = mediaobj.address_asset;

                if (![addressArray containsObject:address_asset]) {
                    continue;
                }

                mediaobj.asset = assets[index];
                mediaobj.image = photos[index];
                [_ChangeArray addObject:mediaobj];
                index += 1;
            }else{
                [_ChangeArray addObject:mediaobj];
            }
    }
    
    
    for (NSInteger i = index; i < assets.count; i++) {
        HHJMediaObj *mediaobj = [HHJMediaObj new];
        mediaobj.asset = assets[i];
        mediaobj.address_asset = [NSString stringWithFormat:@"%p",assets[i]];
        mediaobj.image = photos[i];
        [_ChangeArray addObject:mediaobj];
    }
    
    [_MediaObjArray removeAllObjects];
    [_MediaObjArray addObjectsFromArray:_ChangeArray];
    [_ChangeArray removeAllObjects];
    [addressArray removeAllObjects];
    
    if (self.progressBlock) {
        self.progressBlock(_MediaObjArray);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView setAnimationsEnabled:NO];
        [self reloadData];
        [UIView setAnimationsEnabled:YES];
    });
}

- (void)DeleteBtClickWithIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger item = indexPath.item;
    if (item >= _MediaObjArray.count) {
        return;
    }
    
    HHJMediaObj *mediaobj = _MediaObjArray[item];
    if (mediaobj.asset) {
        if ([self.AssetsArray containsObject:mediaobj.asset]) {
            [self.AssetsArray removeObject:mediaobj.asset];
        }
        if ([self.PhotosArray containsObject:mediaobj.image]) {
            [self.PhotosArray removeObject:mediaobj.image];
        }
    }
    
    
    if (mediaobj.netWorkObjUrl) {
        if (!HHJNetWorkArray) {
            HHJNetWorkArray = [@[] mutableCopy];
        }
        [HHJNetWorkArray removeAllObjects];
        [HHJNetWorkArray addObjectsFromArray:_NetWorkObjArray];
        if ([_NetWorkObjArray containsObject:mediaobj.netWorkObjUrl]) {
            [HHJNetWorkArray removeObject:mediaobj.netWorkObjUrl];
            _NetWorkObjArray = HHJNetWorkArray;
        }else if ([_NetWorkObjArray containsObject:mediaobj]){
            [HHJNetWorkArray removeObject:mediaobj];
            _NetWorkObjArray = HHJNetWorkArray;
        }
    }
    
    [_MediaObjArray removeObject:mediaobj];
    if (self.progressBlock) {
        self.progressBlock(_MediaObjArray);
    }
    
//    if (!_MediaObjArray.count) {
//        [self reloadData];
//        return;
//    }

    
    NSIndexPath *insertIndexPath = [NSIndexPath indexPathForItem:_MediaObjArray.count inSection:indexPath.section];
    
        [self performBatchUpdates:^{
            [self deleteItemsAtIndexPaths:@[indexPath]];
            if (_MediaObjArray.count+1 == _Maxnum&&_Maxnum != 0) {
               [self insertItemsAtIndexPaths:@[insertIndexPath]];
            }
            
        } completion:^(BOOL finished) {
//            [self reloadData];
        }];
 
    
}

 
#pragma mark - 长按排序
/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_OnlyShow) {
        return NO;
    }
    if (_MediaObjArray.count == 1) {
        return NO;
    }
    return indexPath.item < _MediaObjArray.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (_OnlyShow) {
        return NO;
    }
    if (_MediaObjArray.count == 1) {
        return NO;
    }
    return (sourceIndexPath.item < _MediaObjArray.count && destinationIndexPath.item < _MediaObjArray.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    
    id mediaobj = _MediaObjArray[sourceIndexPath.item];
    [_MediaObjArray removeObjectAtIndex:sourceIndexPath.item];
    [_MediaObjArray insertObject:mediaobj atIndex:destinationIndexPath.item];
    
    [UIView setAnimationsEnabled:NO];
    [self reloadData];
    [UIView setAnimationsEnabled:YES];
}


- (UIViewController*)LocationViewController {
    
    UIView *nextview = self;
    
    while (nextview) {
        
        if ([nextview.nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextview.nextResponder;
        }
        nextview = nextview.superview;
    }
    return nil;
}

@end


