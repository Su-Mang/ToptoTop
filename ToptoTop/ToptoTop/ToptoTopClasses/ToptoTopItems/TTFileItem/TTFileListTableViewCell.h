//
//  TTFileListTableViewCell.h
//  ToptoTop
//
//  Created by Sumang on 2020/5/19.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTFileListTableViewCell : UITableViewCell
@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *fileNameLabel;
@property (strong, nonatomic)  UILabel *fileDetailLabel;
@end

NS_ASSUME_NONNULL_END
