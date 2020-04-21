//
//  TTNavigationViewController.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/21.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTNavigationViewController.h"
#import "TTConfig.h"
@interface TTNavigationViewController ()

@end

@implementation TTNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //关闭高斯模糊
    [UINavigationBar appearance].translucent = NO;
    
    // 适合iOS11及以下
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0) forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setBarTintColor:g_rgba(68, 120, 214, 1)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                          NSFontAttributeName:[UIFont systemFontOfSize:17.f]};
    [[UINavigationBar appearance] setTitleTextAttributes:dic];
    
}



@end
