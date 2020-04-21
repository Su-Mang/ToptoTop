//
//  TTChildViewController.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/21.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTChildViewController.h"
#import "TTBaseViewController.h"
#import "TTConfig.h"
#import "TTChildCollectionViewCell.h"

static NSString *const TTHomeCellIdentifity = @"TTChildCollectionViewCell";


@interface TTChildViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIImageView       *cloudView;
@property (nonatomic, strong) UIView            *bgView;
@property (nonatomic, strong) UICollectionView  *collectionView;

@end

@implementation TTChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView {
    
    CGFloat imageHeight = g_height_6(90 / 2.0);
    self.cloudView = [[UIImageView alloc] initWithFrame:CGRectMake(0, g_afr_viewHeight / 3.0 - imageHeight,
                                                                   g_afr_viewWidth, imageHeight)];
    self.cloudView.image = self.cloudImage;
    [self.view addSubview:self.cloudView];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, g_afr_viewHeight / 3.0,
                                                           g_afr_viewWidth, g_afr_viewHeight / 3.0 * 2)];
    self.bgView.backgroundColor = g_rgba(252, 252, 252, 1);
    [self.view addSubview:self.bgView];
    
    // collection
    UICollectionViewFlowLayout *flowLayout  = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView                     = [[UICollectionView alloc] initWithFrame:self.bgView.bounds
                                                                 collectionViewLayout:flowLayout];
    self.collectionView.dataSource          = self;
    self.collectionView.delegate            = self;
    self.collectionView.backgroundColor     = g_rgba(252, 252, 252, 1);
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    //注册UICollectionViewCell
    [self.collectionView registerClass:[TTChildCollectionViewCell class] forCellWithReuseIdentifier:TTHomeCellIdentifity];
    
    [self.bgView addSubview:self.collectionView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TTChildCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TTHomeCellIdentifity
                                                                                 forIndexPath:indexPath];
    cell.iconImage.image = [UIImage imageNamed:self.iconNameArray[indexPath.row]];
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
    
}
#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(g_afr_viewWidth / 4.0, g_afr_viewWidth / 4.0);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TTChildCollectionViewCell *cell = (TTChildCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
  // TTBaseViewController *vc = [AFRJumpCtrManager getVCFromText:cell.textLabel.text];
//    if (vc != nil) {
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先与Server建立链接" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:action];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
}

@end
