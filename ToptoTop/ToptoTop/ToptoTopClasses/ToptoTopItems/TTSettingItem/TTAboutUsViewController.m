//
//  TTAboutUsViewController.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/30.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTAboutUsViewController.h"

#define open_url @"https://mobile.xupt.edu.cn"

@interface TTAboutUsViewController ()

@property (nonatomic, strong) UIImageView       *cloudView;
@property (nonatomic, strong) UIView            *bgView;
@property (nonatomic, strong) UIButton          *urlBtn;

@end

@implementation TTAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = g_rgba(96, 155, 243, 1);
    
    [self createIcon];
}

- (void)createIcon {
    
    CGFloat imageHeight = g_height_6(90 / 2.0);
    self.cloudView = [[UIImageView alloc] initWithFrame:CGRectMake(0, g_afr_viewHeight / 3.0 - imageHeight,
                                                                   g_afr_viewWidth, imageHeight)];
    self.cloudView.image = [UIImage imageNamed:@"ic_main_cloud_middle"];
    [self.view addSubview:self.cloudView];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, g_afr_viewHeight / 3.0,
                                                           g_afr_viewWidth, g_afr_viewHeight / 3.0 * 2)];
    self.bgView.backgroundColor = g_rgba(252, 252, 252, 1);
    [self.view addSubview:self.bgView];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.bgView.frame.size.width / 2.0 - 50, 20, 100, 100)];
    iconImage.image = [UIImage imageNamed:@"3glogo"];
    iconImage.layer.cornerRadius = 50;
    [self.bgView addSubview:iconImage];
    
    UILabel *updateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImage.frame.size.height + iconImage.frame.origin.y + 20,
                                                                     g_afr_viewWidth, 30)];
    updateLabel.textColor = [UIColor grayColor];
    updateLabel.text = @"ToptoTop v1.0.0";
    updateLabel.textAlignment = NSTextAlignmentCenter;
    updateLabel.font = [UIFont systemFontOfSize:g_width_6(18.f)];
    [self.bgView addSubview:updateLabel];
    
    UILabel *ownerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bgView.frame.size.height - g_width_6(120),
                                                                    g_afr_viewWidth, 30)];
    ownerLabel.textColor = [UIColor grayColor];
    ownerLabel.text = @"Copyright ©  西邮移动应用开发实验室iOS组";
    ownerLabel.textAlignment = NSTextAlignmentCenter;
    ownerLabel.font = [UIFont systemFontOfSize:g_width_6(14.f)];
    [self.bgView addSubview:ownerLabel];
    
    CGFloat updateBottomY = updateLabel.frame.origin.y + updateLabel.frame.size.height;
    CGFloat originY = updateBottomY + 20;
    self.urlBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.urlBtn.frame = CGRectMake(0, originY, g_afr_viewWidth, 30);
    [self.urlBtn setTitle:@"访问我们" forState:UIControlStateNormal];
    [self.urlBtn setTintColor:g_rgba(96, 155, 243, 1)];
    [self.urlBtn addTarget:self action:@selector(openMobileUrl:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.urlBtn];
    
}
- (void)openMobileUrl:(UIButton *)sender {
    
    // 跳转Safari
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:open_url]];
    
}
@end
