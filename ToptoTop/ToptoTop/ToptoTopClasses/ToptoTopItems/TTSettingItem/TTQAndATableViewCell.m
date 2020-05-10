//
//  TTQAndATableViewCell.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/27.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTQAndATableViewCell.h"

@implementation TTQAndATableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
   
}
- (void)setupView {
    _titleLabel  = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_descLabel];
    [self addSubview:_titleLabel];
    _descLabel = [[UILabel alloc] init];
    _descLabel.numberOfLines = 0;
    _descLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_descLabel];
}
@end
