//
//  TTHomeViewController.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/21.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTHomeViewController.h"
#import "TTChildViewController.h"
#import "TTConfig.h"
#import "MBProgressHUD.h"
#import "TTResourceManager.h"

static CGFloat const kTTTitleH = 44;
static int const kLineHeight = 5;
#define kButtonWidth g_afr_viewWidth / 3.0
#define kLineWidth g_afr_viewWidth / 3.0
@interface TTHomeViewController ()<UIScrollViewDelegate> {
NSUInteger  _currentX;
    BOOL _isConnect;
    
}
@property (nonatomic, strong) UIScrollView                  *titleScroller;
@property (nonatomic, strong) UIScrollView                  *containScroller;
@property (nonatomic, strong) UIButton                      *selectButton;
@property (nonatomic, strong) UIView                        *bottomLine;
@property (nonatomic, strong) NSMutableArray <UIButton *>    *titleButtons;
@property (nonatomic, strong) NSMutableDictionary            *lineWidthCache;
@property (nonatomic, strong) UIButton                      *connectBtn;

@end

@implementation TTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTitleScroller];
    [self setupContainScroller];
    [self setupChildViewController];
    [self setupTitle];
    [self setupConnectBtn];
}

- (void)setupTitleScroller {
    
    self.titleScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, g_afr_viewWidth, kTTTitleH)];
    self.titleScroller.backgroundColor = g_rgba(68, 120, 214, 1);
    self.titleScroller.scrollEnabled = NO;
    self.navigationItem.titleView = self.titleScroller;
    
    [self.titleScroller addSubview:self.bottomLine];
}
- (void)setupContainScroller {
    
    self.containScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, g_afr_viewWidth, g_afr_viewHeight)];
    self.containScroller.backgroundColor = [UIColor whiteColor];
    self.containScroller.delegate = self;
    self.containScroller.pagingEnabled = YES;
    self.containScroller.showsHorizontalScrollIndicator = NO;
    self.containScroller.showsVerticalScrollIndicator = NO;
    self.containScroller.bounces = NO;
    [self.view addSubview:self.containScroller];
}

- (void)setupChildViewController {
    
    TTResourceManager *manager = [TTResourceManager shareInstance];
    
    TTChildViewController *firstVC = [[TTChildViewController alloc] init];
    firstVC.title = @"文件";
    firstVC.cloudImage = [UIImage imageNamed:@"ic_main_cloud_left"];
    firstVC.view.backgroundColor = g_rgba(96, 155, 243, 1);
    firstVC.titleArray = [manager getFileTexts];
    firstVC.iconNameArray = [manager getFileIcons];
    [self addChildViewController:firstVC];
    
    TTChildViewController *secondVC = [[TTChildViewController alloc] init];
    secondVC.title = @"遥控";
    secondVC.cloudImage = [UIImage imageNamed:@"ic_main_cloud_middle"];
    secondVC.view.backgroundColor = g_rgba(96, 155, 243, 1);
    secondVC.titleArray = [manager getControlTexts];
    secondVC.iconNameArray = [manager getControlIcons];
    [self addChildViewController:secondVC];
    
    TTChildViewController *thirdVC = [[TTChildViewController alloc] init];
    thirdVC.title = @"设置";
    thirdVC.cloudImage = [UIImage imageNamed:@"ic_main_cloud_right"];
    thirdVC.view.backgroundColor = g_rgba(96, 155, 243, 1);
    thirdVC.titleArray = [manager getSettingTexts];
    thirdVC.iconNameArray = [manager getSettingIcons];
    [self addChildViewController:thirdVC];
    
    for (int index = 0; index < self.childViewControllers.count; index++) {
        UIViewController *vc = self.childViewControllers[index];
        vc.view.frame = CGRectMake(index * g_afr_viewWidth, 0, g_afr_viewWidth, g_afr_viewHeight);
        [self.containScroller addSubview:vc.view];
    }
    
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navRect = self.navigationController.navigationBar.frame;
    self.containScroller.contentSize = CGSizeMake(g_afr_viewWidth * self.childViewControllers.count,
                                                  self.view.frame.size.height - (statusRect.size.height + navRect.size.height));
}
- (void)setupTitle {
    NSUInteger icount = self.childViewControllers.count;
    
    CGFloat currentX = 0;
    CGFloat width = kButtonWidth;
    CGFloat height = kTTTitleH;
    
    for (int index = 0; index < icount; index++) {
        UIViewController *vc = self.childViewControllers[index];
        currentX = index * width;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(currentX, 0, width, height);
        button.tag = index;
        
        [button setTitle:vc.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18.f];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleScroller addSubview:button];
        [self.titleButtons addObject:button];
        
        if (index == 0) {
            [self buttonAction:button];
        }
        
    }
    
    self.titleScroller.contentSize = CGSizeMake(icount * width, 0);
    self.titleScroller.showsHorizontalScrollIndicator = NO;
    
}
- (void)setupConnectBtn {
    
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navRect = self.navigationController.navigationBar.frame;
    CGFloat originY = g_afr_viewHeight / 4.0 - g_width_6(100) / 2.0 - (statusRect.size.height + navRect.size.height);
    self.connectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.connectBtn.frame = CGRectMake(g_afr_viewWidth / 2.0 - g_width_6(100) / 2.0,
                                       originY,
                                       g_width_6(100), g_width_6(100));
    [self.connectBtn setTitle:@"建立链接" forState:UIControlStateNormal];
    [self.connectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.connectBtn.layer.cornerRadius = g_width_6(100) / 2.0;
    self.connectBtn.layer.borderWidth = 3.f;
    self.connectBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:self.connectBtn];
    
    [self.connectBtn addTarget:self action:@selector(connectServer) forControlEvents:UIControlEventTouchUpInside];
}
- (void)buttonAction:(UIButton *)sender {
    [self selectButton:sender];
    
    NSUInteger index = sender.tag;
    _currentX = index;
    
    self.containScroller.contentOffset = CGPointMake(index * g_afr_viewWidth, 0);
}
-(void)selectButton:(UIButton *)button {
    
    //添加按钮下面线的移动动画
    CGFloat x = button.center.x - (kLineWidth / 2.0);
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bottomLine.frame = CGRectMake(x, self.bottomLine.frame.origin.y, kLineWidth, self.bottomLine.frame.size.height);
    } completion:nil];
    
    self.selectButton = button;
}

- (void)connectResult:(BOOL)isConnect {
    
    _isConnect = isConnect;
    if (isConnect) {
        [self.connectBtn setTitle:@"已连接" forState:UIControlStateNormal];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger i = self.containScroller.contentOffset.x / self.view.frame.size.width;
    [self selectButton:self.titleButtons[i]];
    _currentX = i;
}

#pragma mark - Lazy Load
- (NSMutableArray <UIButton *> *)titleButtons {
    if (_titleButtons == nil) {
        _titleButtons = [NSMutableArray array];
        
    }
    return _titleButtons;
}

- (NSMutableDictionary *)lineWidthCache {
    if (_lineWidthCache == nil) {
        _lineWidthCache = [NSMutableDictionary dictionary];
    }
    return _lineWidthCache;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, kTTTitleH - kLineHeight, kLineWidth, kLineHeight)];
        _bottomLine.backgroundColor = g_rgba(77, 158, 247, 1);
        
    }
    return _bottomLine;
}
@end
