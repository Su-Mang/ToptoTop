//
//  TTBaseViewController.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/21.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTBaseViewController.h"
#import "SVProgressHUD.h"
@interface TTBaseViewController ()

@end

@implementation TTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD setDefaultAnimationType:(SVProgressHUDAnimationTypeNative)];
    [SVProgressHUD setAnimationDuration:1.f];
    [SVProgressHUD setDefaultMaskType:(SVProgressHUDMaskTypeClear)];
}
- (void)decodeParamWithDic:(NSDictionary *)dic {
    
    // 子类实现
}


@end
