//
//  TTFileLookUpViewController.m
//  ToptoTop
//
//  Created by Sumang on 2020/5/19.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTFileLookUpViewController.h"
#import "TTLocaCacheManager.h"
#import <WebKit/WebKit.h>
@interface TTFileLookUpViewController ()
@property (nonatomic, copy)     NSString        *filePath;
@property (nonatomic, strong)   UIWebView       *webView;
@end

@implementation TTFileLookUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
      
      [self initView];
      [self initWithNavigationBarItem];
      [self initData];
}
- (void)initView {
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
}

    
- (void)initData {
        
        if (self.filePath != nil) {
            NSURL *pathUrl = [NSURL URLWithString:self.filePath];
            NSURLRequest *request = [NSURLRequest requestWithURL:pathUrl];
            [self.webView loadRequest:request];
        }
        else {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"文件路径出错" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertB = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:nil];
            [alertC addAction:alertB];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }

  

- (void)initWithNavigationBarItem {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(shareTapAction:)];
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    rightView.image = [UIImage imageNamed:@"ic_share"];
    rightView.userInteractionEnabled = YES;
    [rightView addGestureRecognizer:tapGesture];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
}


- (void)shareTapAction:(UITapGestureRecognizer *)tap {
    
    NSURL *shareUrl = [NSURL fileURLWithPath:self.filePath];
    NSArray *shareArray = @[shareUrl];
    UIActivityViewController *controller = [[UIActivityViewController alloc]
                                            initWithActivityItems:shareArray applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)decodeParamWithDic:(NSDictionary *)dic {
    
    self.filePath = [dic objectForKey:@"lookUpFilePath"];
}

@end
