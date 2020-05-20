//
//  TTPAVCollectionViewCell.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/5/4.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTPAVCollectionViewCell.h"
#import <Masonry.h>
@implementation TTPAVCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _cellImageView = [[UIImageView alloc] init];
    [self addSubview:_cellImageView];
    
    _picNameLabel = [[UILabel alloc] init];
    [self addSubview:_picNameLabel];
                      
    _videoStartImage = [[UIImageView alloc] init];
    [self addSubview:_videoStartImage];
}
- (void)layoutSubviews {
    [super  layoutSubviews];
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self).offset(10);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(self).offset(-20);
    
    }];
    _cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_picNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self->_cellImageView.mas_bottom);
        make.left.right.mas_equalTo(self->_cellImageView);
        make.height.mas_equalTo(25);
    }];
    
    _picNameLabel.backgroundColor = g_rgba(108, 108, 108, 0.8);
    _picNameLabel.textColor = [UIColor blackColor];
    _picNameLabel.font = [UIFont systemFontOfSize:12];
    _picNameLabel.layer.cornerRadius = 2;
    _picNameLabel.layer.masksToBounds = YES;
   
    
    [_videoStartImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self->_cellImageView);
        make.width.height.mas_equalTo(40);
    }];
    
    
}
@end
