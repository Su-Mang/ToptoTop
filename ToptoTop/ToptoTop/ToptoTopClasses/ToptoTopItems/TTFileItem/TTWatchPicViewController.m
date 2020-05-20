//
//  TTWatchPicViewController.m
//  ToptoTop
//
//  Created by Sumang on 2020/5/20.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTWatchPicViewController.h"

@interface TTWatchPicViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView  *scrollerView;
@property (nonatomic, strong) UIImageView   *imageView;

@end

@implementation TTWatchPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       self.view.backgroundColor = [UIColor blackColor];
     [self setupView];
}

- (void)setupView {
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navRect = self.navigationController.navigationBar.frame;
    
    CGFloat originY = g_afr_viewHeight - (statusRect.size.height + navRect.size.height);
    self.scrollerView = [[UIScrollView alloc] init];
    self.scrollerView.frame = CGRectMake(0, 0, g_afr_viewWidth, originY);
    self.scrollerView.minimumZoomScale = 0.5;
    self.scrollerView.maximumZoomScale = 3.0;
    self.scrollerView.showsVerticalScrollIndicator = NO;
    self.scrollerView.showsHorizontalScrollIndicator = NO;
    
    self.scrollerView.delegate = self;
    [self.view addSubview:self.scrollerView];
    
    UIImageView *textimage = [[UIImageView alloc] initWithImage:self.picImage];
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.frame = [self setImage:textimage];
    self.imageView.image = self.picImage;
    [self.scrollerView addSubview:self.imageView];
    
    //设置scroll的contentsize的frame
    self.scrollerView.contentSize = self.imageView.frame.size;
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}


//控制缩放是在中心
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
}


//根据不同的比例设置尺寸
- (CGRect)setImage:(UIImageView *)imageView {
    
    CGFloat imageX = imageView.frame.size.width;
    CGFloat imageY = imageView.frame.size.height;
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navRect = self.navigationController.navigationBar.frame;
    CGFloat viewHeight = g_afr_viewHeight - (statusRect.size.height + navRect.size.height);
    CGRect imgfram;
    CGFloat CGscale;
    BOOL flx =  (g_afr_viewWidth / viewHeight) > (imageX / imageY);
    
    if(flx) {
        CGscale = g_afr_viewHeight / imageY;
        imageX = imageX * CGscale;
        imgfram = CGRectMake((g_afr_viewWidth - imageX) / 2.3, 0, imageX, g_afr_viewHeight);
        return imgfram;
    }
    else {
        CGscale = g_afr_viewWidth / imageX;
        imageY = imageY * CGscale;
        imgfram = CGRectMake(0, (g_afr_viewHeight - imageY) / 2.2, g_afr_viewWidth, imageY);
        return imgfram;
    }
}

@end
