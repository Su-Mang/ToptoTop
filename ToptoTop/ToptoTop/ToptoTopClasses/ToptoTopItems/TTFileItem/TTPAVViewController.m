//
//  TTPAVViewController.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/5/4.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTPAVViewController.h"
#import "TTPAVCollectionViewCell.h"
#import "TTDefaultModel.h"
#import "TTFileModel.h"
#import <Photos/Photos.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
typedef void(^TTAuthorCallBack)(BOOL isAuthor);
static NSString * const kTTPAVCollectionCell = @"kTTPAVCollectionCell";
@interface TTPAVViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource> {
    BOOL _isiPhoneData;
    
}
@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) NSMutableArray    *dataArray;
@property (nonatomic, assign) BOOL              isPic;
@property (nonatomic, assign) NSInteger         indexRow;


@end

@implementation TTPAVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupCollection];
    [self initData];
}

- (void)setupCollection {
    
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navRect = self.navigationController.navigationBar.frame;
    CGRect collectionRect = CGRectMake(0, 0, g_afr_viewWidth, g_afr_viewHeight - (statusRect.size.height + navRect.size.height));
    
    // collection
    UICollectionViewFlowLayout *flowLayout  = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView                     = [[UICollectionView alloc] initWithFrame:collectionRect
                                                                 collectionViewLayout:flowLayout];
    self.collectionView.dataSource          = self;
    self.collectionView.delegate            = self;
    self.collectionView.backgroundColor     = [UIColor groupTableViewBackgroundColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    //注册UICollectionViewCell
//    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([AFRPAVCollectionViewCell class]) bundle:nil]
//          forCellWithReuseIdentifier:kAFRPAVCollectionCell];
    [self.collectionView registerClass:[TTPAVCollectionViewCell class] forCellWithReuseIdentifier:kTTPAVCollectionCell];
    [self.view addSubview:self.collectionView];
}
- (void)initData {
    if (_isiPhoneData) {
        __weak typeof(self) weakSelf = self;
        [self requestAuthorization:^(BOOL isAuthor) {
            if (isAuthor) {
                if (weakSelf.isPic) {
                    [weakSelf getPhotoDatas];
                }
                else {
                    [weakSelf getVideoDatas];
                }
            }
        }];
    }
    else {
        [self getLocalDatas];
    }
}

- (void)requestAuthorization:(TTAuthorCallBack)callback {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                callback(YES);
            }
            else {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 照片 - AirFree_iPhone] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
                callback(NO);
            }
        }];
    }
    else {
        callback(YES);
    }
}

- (void)getPhotoDatas {
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    PHFetchResult *assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.synchronous = NO;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    typeof(self)weakSelf = self;
    for (PHAsset *asset in assets) {
        
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:CGSizeMake(screenSize.width*scale, screenSize.height*scale)
                                                  contentMode:PHImageContentModeAspectFit
                                                      options:option
                                                resultHandler:
         ^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
             
             TTFileModel *model = [[TTFileModel alloc] init];
             model.fileType = TTFileTypePic;
             model.fileImage = result;
             model.fileName = [asset valueForKey:@"filename"];
             [weakSelf.dataArray addObject:model];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakSelf.collectionView reloadData];
             });
             
         }];
    }
}

- (void)getVideoDatas {
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    PHFetchResult *assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
    // 视频信息
    PHVideoRequestOptions *options2 = [[PHVideoRequestOptions alloc] init];
    options2.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    [options2 setNetworkAccessAllowed:true];
    
    // 视频缩略图
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.synchronous = NO;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    typeof(self)weakSelf = self;
    for (PHAsset *asset in assets) {
        
        PHAsset *imageAsset = asset;
        // 获取视频URL
        [[PHImageManager defaultManager] requestAVAssetForVideo:asset
                                                        options:options2
                                                  resultHandler:
         ^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
             [[PHImageManager defaultManager] requestImageForAsset:imageAsset
                                                        targetSize:CGSizeMake(screenSize.width*scale, screenSize.height*scale)
                                                       contentMode:PHImageContentModeAspectFit
                                                           options:option
                                                     resultHandler:
              ^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                  
                  TTFileModel *model = [[TTFileModel alloc] init];
                  model.fileImage = result;
                  model.fileType = TTFileTypeVideo;
                  model.fileName = [imageAsset valueForKey:@"filename"];
                  model.fileUrl = ((AVURLAsset*)asset).URL;
                  [weakSelf.dataArray addObject:model];
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [weakSelf.collectionView reloadData];
                  });
                  
              }];
         }];
        
    }
}
- (void)getLocalDatas {
    
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
   TTPAVCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTTPAVCollectionCell
                                                                               forIndexPath:indexPath];
    
    TTFileModel *model = self.dataArray[indexPath.row];
    cell.cellImageView.image = model.fileImage;
    cell.picNameLabel.text = model.fileName;
   
        if (model.fileType == TTFileTypePic) {
            cell.videoStartImage.hidden = YES;
        }
        else {
            cell.videoStartImage.hidden = NO;
        }
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((int)(g_afr_viewWidth / 2.2), (int)(g_afr_viewWidth / 2.2));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择操作"
                                                             preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *alertOK = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf lookUpOperationWithRow:indexPath.row];
    }];
    UIAlertAction * alertFirst = [UIAlertAction actionWithTitle:@"上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.indexRow = indexPath.row;
        [strongSelf sendCmdMessageWithRow:indexPath.row];
    }];
    
    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    [alertC addAction:alertOK];
    [alertC addAction:alertFirst];
    [alertC addAction:alertCancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
}


- (void)sendCmdMessageWithRow:(NSInteger)row {
    
//    if ([self.socketManager isCmdSocketConnected] == NO) {
//        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"还未连接Server，请先连接Server再操作" preferredStyle:(UIAlertControllerStyleAlert)];
//        UIAlertAction *alertB = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
//        [alertC addAction:alertB];
//        [self presentViewController:alertC animated:YES completion:nil];
//        return ;
//    }
//
//    [SVProgressHUD showWithStatus:@"正在上传..."];
//    AFRFileModel *fileModel = self.dataArray[row];
//    AFRDefaultModel *model = [[AFRDefaultModel alloc] initWithCommand:@"file" parameter:fileModel.fileName];
//    NSString *jsonStr = [model toJSONString];
//    [self.socketManager sendCMDMessage:jsonStr withTag:1001101];
}
- (void)lookUpOperationWithRow:(NSInteger)row {
    TTFileModel *model = self.dataArray[row];
    if (self.isPic) {
//        AFRWatchPicViewController *vc = [[AFRWatchPicViewController alloc] init];
//        vc.picImage = model.fileImage;
//        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        // 加载视频播放
        AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
        playerVC.player = [AVPlayer playerWithURL:model.fileUrl];
        [self presentViewController:playerVC animated:YES completion:^{
            // 打开自动播放
            [playerVC.player play];
        }];
    }
}

- (void)uploadOperationWithRow:(NSInteger)row {
    
   TTFileModel *model = self.dataArray[row];
    NSData *fileData = nil;
    if (self.isPic) {
        if ([model.fileName hasSuffix:@".PNG"]) {
            fileData = UIImagePNGRepresentation(model.fileImage);
        }
        else if ([model.fileName hasSuffix:@".JPG"]){
            fileData = UIImageJPEGRepresentation(model.fileImage, 1);
        }
        [self doUploadFileWithData:fileData];
    }
    else {
        
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        
        PHFetchResult *assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:nil];
        // 视频信息
        PHVideoRequestOptions *options2 = [[PHVideoRequestOptions alloc] init];
        options2.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        [options2 setNetworkAccessAllowed:true];
        
        typeof(self)weakSelf = self;
        for (PHAsset *asset in assets) {
            // 获取视频URL
            [[PHImageManager defaultManager] requestAVAssetForVideo:asset
                                                            options:options2
                                                      resultHandler:
             ^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                 NSURL *url = ((AVURLAsset*)asset).URL;
                 if ([[model.fileUrl absoluteString] isEqualToString:[url absoluteString]]) {
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         NSData *data = [NSData dataWithContentsOfURL:url];
                         [weakSelf doUploadFileWithData:data];
                     });
                 }
             }];
        }
    }
    
}

- (void)doUploadFileWithData:(NSData *)fileData {
//    if (fileData == nil) {
//        [SVProgressHUD showErrorWithStatus:@"上传失败"];
//    }
//    else {
//        [[AFRSocketManager socketManager] uploadFileSocketWithData:fileData callBack:^(BOOL isSuccess, NSError *error) {
//            if (isSuccess) {
//                NSLog(@"Upload File Success");
//                [SVProgressHUD showSuccessWithStatus:@"上传成功"];
//            }
//            else {
//                if (error != nil) {
//                    NSLog(@"Upload File Error : %@", error);
//                    [SVProgressHUD showErrorWithStatus:@"上传失败"];
//                }
//            }
//            [SVProgressHUD dismissWithDelay:0.5f];
//        }];
//    }
}

- (void)cmdSendMessageSuccessWithTag:(long)tag {
    if (tag == 1001101) {
        [self uploadOperationWithRow:self.indexRow];
    }
}
- (void)decodeParamWithDic:(NSDictionary *)dic {
    
    NSNumber *isPhoneData = [dic objectForKey:@"isiPhoneData"];
    NSNumber *isPhoto = [dic objectForKey:@"isPic"];
    
    if (isPhoneData == nil) {
        _isiPhoneData = NO;
    }
    else {
        _isiPhoneData = [isPhoneData boolValue];
    }
    
    if (isPhoto == nil) {
        self.isPic = NO;
    }
    else {
        self.isPic = [isPhoto boolValue];
    }
}

- (NSMutableArray *)dataArray {
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
