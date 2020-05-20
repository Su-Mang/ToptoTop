//
//  TTFileListTableViewCell.m
//  ToptoTop
//
//  Created by Sumang on 2020/5/19.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTFileListTableViewCell.h"
#import <Masonry.h>
@implementation TTFileListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImage = [[UIImageView alloc] init];
        [self addSubview:self.iconImage];
        
        self.fileNameLabel = [[UILabel alloc] init];
              [self addSubview:self.fileNameLabel];
        
        self.fileDetailLabel = [[UILabel alloc] init];
              [self addSubview:self.fileDetailLabel];
        self.fileDetailLabel.textColor = [UIColor grayColor];
        self.fileDetailLabel.font = [UIFont systemFontOfSize:12];
}
    return self;
    
};

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(5);
        make.top.mas_equalTo(self).offset(10);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(54);
             
    }];
    
    [self.fileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self->_iconImage.mas_right).mas_offset(10);
         make.right.mas_equalTo(self).mas_offset(-10);
        make.top.mas_equalTo(self->_iconImage);
        make.height.mas_equalTo(27);
    }];
    
    [self.fileDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(self->_iconImage.mas_right).mas_offset(10);
            make.right.mas_equalTo(self).mas_offset(-10);
        make.top.mas_equalTo(self->_iconImage).offset(27);
           make.height.mas_equalTo(27);
       }];
       
    
}
@end
