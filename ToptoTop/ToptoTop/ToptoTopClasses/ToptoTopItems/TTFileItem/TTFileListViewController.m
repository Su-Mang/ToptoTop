//
//  TTRFileListViewController.m
//  ToptoTop
//
//  Created by Sumang on 2020/5/19.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTFileListViewController.h"
#import "TTWatchPicViewController.h"
#import "TTPAVViewController.h"
#import "TTFileListTableViewCell.h"
#import "TTFileLookUpViewController.h"
#import "TTFileSectionHeader.h"
#import "TTLocaCacheManager.h"
#import "TTDefaultModel.h"
#import "TTFileModel.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#define g_toolView_height       54
#define afr_file_cmd_tag        102021
#define afr_file_upload_tag     2022022


static NSString * const kTTFileCell = @"kTTFileCell";



@interface TTFileListViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
BOOL _isAllSelect;
   UISearchBar *_searchBar;
   NSString *_pathStr;
}

@property (nonatomic, strong) UITableView           *tableView;
@property (nonatomic, strong) NSMutableArray        *listData;
@property (nonatomic, strong) NSMutableArray        *searchList;
@property (nonatomic, strong) TTFileSectionHeader  *sectionHeader;
//@property (nonatomic, strong) AFRSocketManager      *socketManager;

@property (nonatomic, assign) BOOL                  isRemoteDevice;
@property (nonatomic, assign) BOOL                  isPicOrVideo;
@property (nonatomic, assign) BOOL                  isDownLoadPicOrVideo;
//@property (nonatomic, assign) BOOL                  isDownLoad;
@property (nonatomic, assign) BOOL                  isShowDownLoadDir;

@property (nonatomic, assign) NSInteger             indexRow;
@property (nonatomic, assign) NSInteger             uploadRow;


@end

@implementation TTFileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
      
      [self setupTableView];
}


- (void)setupTableView {
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navRect = self.navigationController.navigationBar.frame;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, g_afr_viewWidth,
                                                                   g_afr_viewHeight - (statusRect.size.height + navRect.size.height))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionFooterHeight = 5.f;
    self.tableView.rowHeight = 80;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:self.tableView];
    
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier: kTTFileCell];
  
    
    //去掉底部线条
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, g_afr_viewWidth, 44.f)];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入";
    self.tableView.tableHeaderView = _searchBar;
    
    self.sectionHeader.pathLabel.text = _pathStr;
}

#pragma mark - 不同界面数据整理
- (void)picAndVideoData {
    
    [self.listData removeAllObjects];
    [self.searchList removeAllObjects];
    
    TTFileModel *model = [[TTFileModel alloc] init];
    model.fileType = TTFileTypeFloder;
    model.fileIcon = @"ic_fm_icon_folder";
    model.fileName = @"本地存储";
    model.fileDetail = @"iPhone本机存储的文件";
    [self.listData addObject:model];
    
    TTFileModel *downModel = [[TTFileModel alloc] init];
    downModel.fileType = TTFileTypeFloder;
    downModel.fileIcon = @"ic_fm_icon_folder";
    downModel.fileName = @"下载";
    downModel.fileDetail = @"下载保存在APP中的文件";
    [self.listData addObject:downModel];
    self.searchList = [NSMutableArray arrayWithArray:self.listData];
}

- (void)downLoadViewData {
    
    [self.listData removeAllObjects];
    [self.searchList removeAllObjects];
    
    TTFileModel *model = [[TTFileModel alloc] init];
    model.fileType = TTFileTypeFloder;
    model.fileIcon = @"ic_fm_icon_folder";
    model.fileName = @"任务列表";
    model.fileDetail = @"还在后台上传或下载的任务列表";
    [self.listData addObject:model];
    
    TTFileModel *downModel = [[TTFileModel alloc] init];
    downModel.fileType = TTFileTypeFloder;
    downModel.fileIcon = @"ic_fm_icon_folder";
    downModel.fileName = @"已下载";
    downModel.fileDetail = @"已下载完成的任务";
    [self.listData addObject:downModel];
    self.searchList = [NSMutableArray arrayWithArray:self.listData];
}

- (void)otherDownLoadDirData {
    
    [self.listData removeAllObjects];
    [self.searchList removeAllObjects];
    
    TTFileModel *model = [[TTFileModel alloc] init];
    model.fileType = TTFileTypeFloder;
    model.fileIcon = @"ic_fm_icon_folder";
    model.fileName = @"图片";
    model.fileDetail = @"已下载的图片";
    [self.listData addObject:model];
    
    TTFileModel *downModel = [[TTFileModel alloc] init];
    downModel.fileType = TTFileTypeFloder;
    downModel.fileIcon = @"ic_fm_icon_folder";
    downModel.fileName = @"音乐";
    downModel.fileDetail = @"已下载的音乐";
    [self.listData addObject:downModel];
    
    TTFileModel *videoModel = [[TTFileModel alloc] init];
    videoModel.fileType = TTFileTypeFloder;
    videoModel.fileIcon = @"ic_fm_icon_folder";
    videoModel.fileName = @"视频";
    videoModel.fileDetail = @"已下载的视频";
    [self.listData addObject:videoModel];
    
    TTFileModel *docModel = [[TTFileModel alloc] init];
    docModel.fileType = TTFileTypeFloder;
    docModel.fileIcon = @"ic_fm_icon_folder";
    docModel.fileName = @"文档";
    docModel.fileDetail = @"已下载的文档";
    [self.listData addObject:docModel];
    
    TTFileModel *otherFileModel = [[TTFileModel alloc] init];
    otherFileModel.fileType = TTFileTypeFloder;
    otherFileModel.fileIcon = @"ic_fm_icon_folder";
    otherFileModel.fileName = @"文件";
    otherFileModel.fileDetail = @"已下载的文件";
    [self.listData addObject:otherFileModel];
    
    self.searchList = [NSMutableArray arrayWithArray:self.listData];
}

- (void)fileListDataWithPath:(NSString *)path {
    
    [self.listData removeAllObjects];
    [self.searchList removeAllObjects];
    
    NSArray *array = [[TTLocaCacheManager shareInstance] getDirContentsWithPath:path];
    if (array != nil) {
        self.listData = [NSMutableArray arrayWithArray:array];
        self.searchList = [NSMutableArray arrayWithArray:array];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTFileListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTTFileCell];
    if (cell == nil) {
        cell =  [[TTFileListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTTFileCell];
    }
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    TTFileModel *model = self.searchList[indexPath.row];
    cell.iconImage.image = [UIImage imageNamed:model.fileIcon];
    
    NSArray *fileNames = [model.fileName componentsSeparatedByString:@"\\"];
    NSString *fileStr = [fileNames lastObject];
    if ([fileStr isEqualToString:@""]) {
        cell.fileNameLabel.text = [fileNames firstObject];
    
    }
    else {
        cell.fileNameLabel.text = fileStr;
    }
    
    cell.fileDetailLabel.text = model.fileDetail;
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.isEditing) {
        return ;
    }
    
    TTFileModel *model = self.searchList[indexPath.row];
    if (self.isPicOrVideo) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (indexPath.row == 0) {
            [dic setObject:@(YES) forKey:@"isiPhoneData"];
        }
        else {
            [dic setObject:@(NO) forKey:@"isiPhoneData"];
        }
        if ([self.title isEqualToString:g_afr_pic]) {
            [dic setObject:@(YES) forKey:@"isPic"];
        }
        else {
            [dic setObject:@(NO) forKey:@"isPic"];
        }
        if (indexPath.row == 0) {
            TTPAVViewController *vc = [[TTPAVViewController alloc] init];
            vc.title = model.fileName;
            [vc decodeParamWithDic:dic];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            TTFileListViewController *fileVC = [[TTFileListViewController alloc] init];
            fileVC.title = model.fileName;
            [dic setObject:@(YES) forKey:@"isDownLoadPicOrVideo"];
            [fileVC decodeParamWithDic:dic];
            [self.navigationController pushViewController:fileVC animated:YES];
        }
    }
    else {
        if (model.fileType == TTFileTypeFloder) {
            TTFileListViewController *vc = [[TTFileListViewController alloc] init];
            NSDictionary *dic = @{@"titlePath" : [NSString stringWithFormat:@"%@/%@", _pathStr, model.fileName],
                                  @"isRemoteDevice" : @(self.isRemoteDevice),
                                  @"remotePath" : model.fileName
                                  };
            vc.title = model.fileName;
            [vc decodeParamWithDic:dic];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            
            __weak typeof(self) weakSelf = self;
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择操作"
                                                                     preferredStyle:(UIAlertControllerStyleActionSheet)];
            
            UIAlertAction *alertOK = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
               // [strongSelf lookUpOperationWithRow:indexPath.row];
            }];
            UIAlertAction *alertFirst = nil;
            if (self.isRemoteDevice) {
                alertFirst = [UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                   // [strongSelf downLoadOperationWithRow:indexPath.row];
                }];
            }
            else {
                alertFirst = [UIAlertAction actionWithTitle:@"上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                  //  [strongSelf uploadOperationWithRow:indexPath.row];
                }];
            }
            
            UIAlertAction *alertDelete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
             //   [strongSelf deleteOperationWithRow:indexPath.row];
            }];
            
            UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
            
            [alertC addAction:alertOK];
            [alertC addAction:alertFirst];
            if (self.isRemoteDevice == NO) {
                [alertC addAction:alertDelete];
            }
            [alertC addAction:alertCancel];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}

#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchText isEqualToString:@""]) {
        [self filterBySubString:searchText];
    }
    else {
        self.searchList = [NSMutableArray arrayWithArray:self.listData];
        [self.tableView reloadData];
    }
}

- (void)filterBySubString:(NSString *)searchStr {
    NSString *predicStr = [NSString stringWithFormat:@"fileName contains[cd] '%@'", searchStr];
    NSPredicate *prediction = [NSPredicate predicateWithFormat:predicStr];
    if (self.searchList != nil) {
        [self.searchList removeAllObjects];
    }
    self.searchList = [NSMutableArray arrayWithArray:self.listData];
    [self.searchList filterUsingPredicate:prediction];
    [self.tableView reloadData];
}

#pragma mark - File Operation

//- (void)lookUpOperationWithRow:(NSInteger)row {
//    
//    TTFileModel *model = self.searchList[row];
//    NSArray *fileNames = [model.fileName componentsSeparatedByString:@"\\"];
//    NSString *fileStr = [fileNames lastObject];
//    NSString *dirPath = [[TTLocaCacheManager shareInstance] getDirPathWithFileName:fileStr];
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@", dirPath, fileStr];
//    
//    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
//    if (isExist) {
//        filePath = [filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        TTLocaCacheManager *locaManager = [TTLocaCacheManager shareInstance];
//        if ([dirPath isEqualToString:[locaManager getVideoDirPath]] || [dirPath isEqualToString:[locaManager getMusicDirPath]]) {
//            // 加载视频播放
//            AVPlayerViewController *playerVC = [[AVPlayerViewController alloc] init];
//            playerVC.player = [AVPlayer playerWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@", filePath]]];
//            [self presentViewController:playerVC animated:YES completion:^{
//                // 打开自动播放
//                [playerVC.player play];
//            }];
//        }
//        else if ([dirPath isEqualToString:[locaManager getPhotoDirPath]]) {
////            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
////            TTWatchPicViewController *vc = [[AFRWatchPicViewController alloc] init];
////            vc.picImage = image;
////            [self.navigationController pushViewController:vc animated:YES];
//        }
//        else {
//            TTFileLookUpViewController *fileVC = [[TTFileLookUpViewController alloc] init];
//            fileVC.title = fileStr;
//            NSDictionary *dic = @{@"lookUpFilePath" : filePath};
//            [fileVC decodeParamWithDic:dic];
//            [self.navigationController pushViewController:fileVC animated:YES];
//        }
//        
//    }
//    else {
//        __weak typeof(self) weakSelf = self;
//        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"本地没有此文件，是否下载?" preferredStyle:(UIAlertControllerStyleAlert)];
//        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
//            // 调用下载进行下载
//            __strong typeof(self) strongSelf = weakSelf;
//            [strongSelf downLoadOperationWithRow:row];
//        }];
//        UIAlertAction *alertB = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
//        
//        [alertC addAction:alertB];
//        [alertC addAction:alertA];
//        [self presentViewController:alertC animated:YES completion:nil];
//    }
//}

//- (void)uploadOperationWithRow:(NSInteger)row {
//    if ([self.socketManager isCmdSocketConnected] == NO) {
//        [self showAlertWithTitle:@"还未连接Server，请先连接Server再操作"];
//        return ;
//    }
//    
//    [SVProgressHUD showWithStatus:@"正在上传..."];
//    
//    self.uploadRow = row;
//    AFRFileModel *fileModel = self.searchList[row];
//    NSArray *fileNames = [fileModel.fileName componentsSeparatedByString:@"\\"];
//    NSString *fileStr = [fileNames lastObject];
//    AFRDefaultModel *model = [[AFRDefaultModel alloc] initWithCommand:@"file" parameter:fileStr];
//    NSString *jsonStr = [model toJSONString];
//    [self.socketManager sendCMDMessage:jsonStr withTag:afr_file_upload_tag];
//}
//
//- (void)downLoadOperationWithRow:(NSInteger)row {
//    if ([self.socketManager isCmdSocketConnected] == NO) {
//        [self showAlertWithTitle:@"还未连接Server，请先连接Server再操作"];
//        return ;
//    }
//    
//    self.indexRow = row;
//    AFRFileModel *model = self.searchList[row];
//    NSArray *fileNames = [model.fileName componentsSeparatedByString:@"\\"];
//    NSString *fileStr = [fileNames lastObject];
//    NSString *dirPath = [[AFRLocaCacheManager shareInstance] getDirPathWithFileName:fileStr];
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@", dirPath, fileStr];
//    
//    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
//    if (isExist) {
//        [self showAlertWithTitle:@"该文件已下载，请直接查看即可"];
//    }
//    else {
//        [SVProgressHUD showWithStatus:@"正在下载..."];
//        AFRDefaultModel *defaultModel = [[AFRDefaultModel alloc] initWithCommand:@"computer"
//                                                                       parameter:[NSString stringWithFormat:@"iwanna:%@", model.fileName]];
//        NSString *modelJson = [defaultModel toJSONString];
//        [self.socketManager sendCMDMessage:modelJson withTag:afr_file_cmd_tag];
//    }
//}
//
//- (void)deleteOperationWithRow:(NSInteger)row {
//    
//    AFRFileModel *model = self.searchList[row];
//    NSArray *fileNames = [model.fileName componentsSeparatedByString:@"\\"];
//    NSString *fileStr = [fileNames lastObject];
//    NSString *dirPath = [[AFRLocaCacheManager shareInstance] getDirPathWithFileName:fileStr];
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@", dirPath, fileStr];
//    
//    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
//    if (isExist) {
//        NSError *error = nil;
//        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
//        if (error != nil) {
//            NSLog(@"%s Delete File Error : %@", __func__, error);
//            [self showAlertWithTitle:@"删除文件失败"];
//        }
//        else {
//            [self.searchList removeObjectAtIndex:row];
//            [self.listData removeObjectAtIndex:row];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            
//        }
//    }
//    else {
//        [self showAlertWithTitle:@"本地没有此文件"];
//    }
//}
#pragma mark - Decode Param
- (void)decodeParamWithDic:(NSDictionary *)dic {
    
    // 图片和视频
    NSNumber *isPAV = [dic objectForKey:@"isPicOrVideo"];
    if (isPAV != nil) {
        self.isPicOrVideo = [isPAV boolValue];
        if (self.isPicOrVideo == YES) {
            [self picAndVideoData];
        }
    }
    else {
        self.isPicOrVideo = NO;
    }
    
    NSNumber *isShowDownDir = [dic objectForKey:@"isShowDownDir"];
    if (isShowDownDir != nil) {
        self.isShowDownLoadDir = [isShowDownDir boolValue];
        if (self.isShowDownLoadDir == YES) {
            [self otherDownLoadDirData];
        }
    }
    else {
        self.isShowDownLoadDir = NO;
    }
    
    NSNumber *isDownLoadPOrV = [dic objectForKey:@"isDownLoadPicOrVideo"];
    if (isDownLoadPOrV != nil) {
        self.isDownLoadPicOrVideo = [isDownLoadPOrV boolValue];
        if (self.isDownLoadPicOrVideo == YES) {
            NSNumber *isPic = [dic objectForKey:@"isPic"];
            if ([isPic boolValue] == YES) {
                [self fileListDataWithPath:[[TTLocaCacheManager shareInstance] getPhotoDirPath]];
            }
            else {
                [self fileListDataWithPath:[[TTLocaCacheManager shareInstance] getVideoDirPath]];
            }
        }
    }
    else {
        self.isDownLoadPicOrVideo = NO;
    }
    
    NSNumber *isRemoteDevice = [dic objectForKey:@"isRemoteDevice"];
    if (isRemoteDevice != nil) {
        self.isRemoteDevice = [isRemoteDevice boolValue];
        if (self.isRemoteDevice) {
            // 请求数据
            NSString *remotePath = [dic objectForKey:@"remotePath"];
//[self initDataWithPath:remotePath];
        }
    }
    
    if ([self.title isEqualToString:g_afr_music]) {
        [self fileListDataWithPath:[[TTLocaCacheManager shareInstance] getMusicDirPath]];
    }
    else if ([self.title isEqualToString:g_afr_doc]) {
        [self fileListDataWithPath:[[TTLocaCacheManager shareInstance] getDocDirPath]];
    }
    else if ([self.title isEqualToString:g_afr_pic] && self.isPicOrVideo == NO) {
        [self fileListDataWithPath:[[TTLocaCacheManager shareInstance] getPhotoDirPath]];
    }
    else if ([self.title isEqualToString:g_afr_video] && self.isPicOrVideo == NO){
        [self fileListDataWithPath:[[TTLocaCacheManager shareInstance] getVideoDirPath]];
    }
    else if ([self.title isEqualToString:@"文件"]) {
        [self fileListDataWithPath:[[TTLocaCacheManager shareInstance] getOtherFileDirPath]];
    }
    
    NSString *path = [dic objectForKey:@"titlePath"];
    if (path != nil) {
        _pathStr = path;
    }
    else {
        _pathStr = self.title;
    }
}
#pragma mark - Lazy Load
- (NSMutableArray *)listData {
    
    if (_listData == nil) {
        _listData = [NSMutableArray array];
    }
    return _listData;
}

- (NSMutableArray *)searchList {
    
    if (_searchList == nil) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}

- (TTFileSectionHeader *)sectionHeader {
    if (_sectionHeader == nil) {
        _sectionHeader = [[TTFileSectionHeader alloc] initWithFrame:CGRectMake(0, 0, g_afr_viewWidth, 44.f)];
        _sectionHeader.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _sectionHeader;
}


@end
