//
//  TTChildCollectionViewCell.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/21.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTChildCollectionViewCell.h"
#import "TTConfig.h"
@implementation TTChildCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    CGFloat imageWidth = self.frame.size.height / 3.0 * 2 > self.frame.size.width ? self.frame.size.width: self.frame.size.height / 3.0 * 2;
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 - imageWidth / 2.0,
                                                                   0, imageWidth, imageWidth)];
    [self.contentView addSubview:self.iconImage];
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.iconImage.frame.size.height,
                                                               self.frame.size.width,
                                                               self.frame.size.height / 3.0)];
    self.textLabel.textColor = g_rgba(123, 123, 123, 1);
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.textLabel];
    
}

@end
