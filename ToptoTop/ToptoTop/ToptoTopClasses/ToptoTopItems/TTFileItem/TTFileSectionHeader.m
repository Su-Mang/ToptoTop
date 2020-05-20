//
//  TTFileSectionHeader.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/5/1.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTFileSectionHeader.h"

@implementation TTFileSectionHeader
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setView];
    }
    return self;
}

- (void)setView {
    
    self.pathLabel = [[UILabel alloc] initWithFrame:CGRectMake(g_width_6(15), self.frame.size.height / 2.0 - g_height_6(25 / 2.0),
                                                               self.frame.size.width - g_width_6(30), g_height_6(25))];
    self.pathLabel.textColor = [UIColor grayColor];
    
    self.pathLabel.font = [UIFont systemFontOfSize:g_width_6(13.f)];
   // self.pathLabel.backgroundColor = [UIColor redColor];
    [self addSubview:self.pathLabel];
}

@end
