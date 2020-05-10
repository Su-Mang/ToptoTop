//
//  TTQAndAViewController.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/27.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTQAndAViewController.h"
#import "TTConfig.h"
#import "TTQAndATableViewCell.h"
static NSString * const TTAQCell = @"TTAQCell";
@interface TTQAndAViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, copy)   NSArray       *messArray;
@property (nonatomic, copy)   NSMutableArray      *messHightArray;
@property (nonatomic, copy)   NSMutableArray      *messWidthArray;
@end

@implementation TTQAndAViewController

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
    self.tableView.estimatedRowHeight = 66;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:self.tableView];
    
    
    //去掉底部线条
    self.tableView.tableFooterView = [[UIView alloc] init];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTQAndATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TTAQCell];
    if(!cell ) {
        cell = [[TTQAndATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TTAQCell];
    }
    cell.titleLabel.text = [self.messArray[indexPath.row] objectForKey:@"question"];
    CGSize titleLabelsize = [self size:cell.titleLabel.text font:[UIFont systemFontOfSize:20.0] maxSize:CGSizeMake(g_afr_viewWidth, MAXFLOAT)];
    cell.titleLabel.frame = CGRectMake(0, 0, titleLabelsize.width, titleLabelsize.height);
    cell.descLabel.text = [self.messArray[indexPath.row] objectForKey:@"answer"];
   CGSize descLabelsize = [self size:cell.descLabel.text font:[UIFont systemFontOfSize:20.0] maxSize:CGSizeMake(g_afr_viewWidth, MAXFLOAT)];
    cell.descLabel.frame = CGRectMake( 0,  titleLabelsize.height, descLabelsize.width, descLabelsize.height);
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    return cell;
}
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
      CGSize titleLabelsize = [self size:[self.messArray[indexPath.row] objectForKey:@"question"] font:[UIFont systemFontOfSize:20.0] maxSize:CGSizeMake(g_afr_viewWidth, MAXFLOAT)];
    
    CGSize descLabelsize = [self size:[self.messArray[indexPath.row] objectForKey:@"answer"] font:[UIFont systemFontOfSize:20.0] maxSize:CGSizeMake(g_afr_viewWidth, MAXFLOAT)];
    
    return descLabelsize.height+titleLabelsize.height +20;
    
}
-(CGSize)size:(NSString*)text font:(UIFont*)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName ,nil];
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}
- (NSArray *)messArray {
    if (_messArray == nil) {
        _messArray = @[@{@"question" : @"Q1:我应该如何使用客户端连接服务端呢?", @"answer" : @"你可以点击主界面左上角按钮进入连接界面，输入服务端IP或者扫描二维码链接。连接前请先确认客户端和服务端均连接在同一局域网内。"},
                       @{@"question" : @"Q2:我在无网络或未连接状态下可以使用客户端吗?", @"answer" : @"可以，在无网络或未连接状态下文件管理功能是可以使用的，你可以对客户端所有类型文件进行删除、移动、复制操作，还可以查看内部存储、图片、文档、音乐、视频等。"},
                       @{@"question" : @"Q3:我应该如何上传文件到服务端或者从服务端下载文件?", @"answer" : @"上传文件：在内部存储、图片、视频、音乐、文档、下载中选择你希望上传的文件，点击上传。\n下载文件：在电脑磁盘中选择你希望下载的文件，点击下载。\n上传下载过程中请耐心等待。"},
                       @{@"question" : @"Q4:如果在使用过程中发现问题怎么办?", @"answer" : @"进入意见反馈给我们发邮件反馈问题哦。欢迎给我们提意见哈！"},
                       @{@"question" : @"Q5:如何联系我们呢?", @"answer" : @"我们的联系方式:\n邮箱:792488979@qq.com\n欢迎给我们提供宝贵意见。"}];
    }
    return _messArray;
}


@end
