//
//  TTClearCacheViewController.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/5/2.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTClearCacheViewController.h"
#import "TTLocaCacheManager.h"
#import "MBProgressHUD.h"


@interface TTClearCacheViewController ()
@property (nonatomic, strong) UIImageView       *cloudView;
@property (nonatomic, strong) UIView            *bgView;
@property (nonatomic, strong) UILabel           *cacheLabel;
@property (nonatomic, strong) UIButton          *managerButton;
@property (nonatomic, strong) UIButton          *clearButton;
@property (nonatomic, strong) MBProgressHUD     *hud;
@end

@implementation TTClearCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = g_rgba(96, 155, 243, 1);
    
    [self setupView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 开始计算缓存大小时隐藏两个button
    [self startProgressWithInfo:@"正在计算缓存大小..."];
    [self calculateSizeOfCache];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupView {
    
    CGFloat imageHeight = g_height_6(90 / 2.0);
    self.cloudView = [[UIImageView alloc] initWithFrame:CGRectMake(0, g_afr_viewHeight / 3.0 - imageHeight,
                                                                   g_afr_viewWidth, imageHeight)];
    self.cloudView.image = [UIImage imageNamed:@"ic_main_cloud_middle"];
    [self.view addSubview:self.cloudView];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, g_afr_viewHeight / 3.0,
                                                           g_afr_viewWidth, g_afr_viewHeight / 3.0 * 2)];
    self.bgView.backgroundColor = g_rgba(252, 252, 252, 1);
    [self.view addSubview:self.bgView];
    
    UILabel *useLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, g_afr_viewWidth, g_width_6(25))];
    useLabel.text = @"AirFree 已用空间";
    useLabel.textAlignment = NSTextAlignmentCenter;
    useLabel.textColor = [UIColor grayColor];
    useLabel.font = [UIFont systemFontOfSize:14.f];
    [self.bgView addSubview:useLabel];
    
    UIView *activityBgView = [[UIView alloc] initWithFrame:CGRectMake(g_afr_viewWidth / 6.0, 10,
                                                                      g_afr_viewWidth / 3.0 * 2, g_afr_viewWidth / 2.0)];
    activityBgView.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:activityBgView];
    
    CGFloat cacheOriginY = useLabel.frame.origin.y + useLabel.frame.size.height + 25;
    self.cacheLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, cacheOriginY, g_afr_viewWidth, g_width_6(60))];
    self.cacheLabel.textColor = [UIColor blackColor];
    self.cacheLabel.textAlignment = NSTextAlignmentCenter;
    self.cacheLabel.font = [UIFont systemFontOfSize:32.f];
    self.cacheLabel.text = @"";
    [self.bgView addSubview:self.cacheLabel];
    
    CGFloat managerBtnY = self.cacheLabel.frame.size.height + self.cacheLabel.frame.origin.y + 25;
    self.managerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.managerButton.frame = CGRectMake(g_afr_viewWidth / 4.0, managerBtnY,
                                          g_afr_viewWidth / 2.0, 40);
    [self.managerButton setTitle:@"管理缓存数据" forState:UIControlStateNormal];
    [self.managerButton setTintColor:[UIColor whiteColor]];
    self.managerButton.backgroundColor = g_rgba(96, 155, 243, 1);
    [self.managerButton addTarget:self action:@selector(pushToFileListController) forControlEvents:UIControlEventTouchUpInside];
    self.managerButton.layer.cornerRadius = 5.f;
    [self.bgView addSubview:self.managerButton];
    
    CGFloat clearBtnY = managerBtnY + self.managerButton.frame.size.height + 15;
    self.clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.clearButton.frame = CGRectMake(g_afr_viewWidth / 4.0, clearBtnY,
                                        g_afr_viewWidth / 2.0, 40);
    [self.clearButton setTitle:@"清理所有缓存" forState:UIControlStateNormal];
    [self.clearButton setTintColor:[UIColor blackColor]];
    self.clearButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.clearButton addTarget:self action:@selector(clearCache) forControlEvents:UIControlEventTouchUpInside];
    self.clearButton.layer.cornerRadius = 5.f;
    [self.bgView addSubview:self.clearButton];
    
    // initWithHUD
    self.hud = [[MBProgressHUD alloc] initWithView:activityBgView];
    self.hud.bezelView.color = g_rgba(252, 252, 252, 1);
    self.hud.detailsLabel.textColor = [UIColor grayColor];
    self.hud.detailsLabel.font = [UIFont systemFontOfSize:13.f];
    [activityBgView addSubview:self.hud];
}

- (void)startProgressWithInfo:(NSString *)info {
    
    self.cacheLabel.text = @"";
    self.managerButton.hidden = YES;
    self.clearButton.hidden = YES;
    
    self.hud.detailsLabel.text = info;
    [self.hud showAnimated:YES];
}

- (void)calculateSizeOfCache {
    NSString *dataSizze = [[TTLocaCacheManager shareInstance] getCacheDataSize];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.hud hideAnimated:YES];
        weakSelf.cacheLabel.text = dataSizze;
        weakSelf.managerButton.hidden = NO;
        weakSelf.clearButton.hidden = NO;
    });
}

//- (void)pushToFileListController {
//
//    AFRFileListViewController *vc = [[AFRFileListViewController alloc] init];
//    vc.title = @"本地缓存";
//    NSDictionary *dic = @{@"isShowDownDir" : @(YES)};
//    [vc decodeParamWithDic:dic];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)clearCache {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"确定清空所有缓存？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                              // 执行清理缓存任务
                                                              [self doClearCacheTask];
                                                          }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)doClearCacheTask {
    [self startProgressWithInfo:@"正在清理所有缓存..."];
    [[TTLocaCacheManager shareInstance] clearCacheData];
    NSString *dataSize = [[TTLocaCacheManager shareInstance] getCacheDataSize];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 清理缓存操作
        [weakSelf.hud hideAnimated:YES];
        weakSelf.cacheLabel.text = dataSize;
        weakSelf.managerButton.hidden = NO;
        weakSelf.clearButton.hidden = NO;
    });
}

@end
