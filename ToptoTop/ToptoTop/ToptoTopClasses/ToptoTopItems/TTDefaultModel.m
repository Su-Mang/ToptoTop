//
//  TTDefaultModel.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/21.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTDefaultModel.h"

@implementation TTDefaultModel

- (instancetype)initWithCommand:(NSString *)command parameter:(NSString *)parameter {
    self = [super init];
    if (self) {
        self.command = command;
        self.parameter = parameter;
    }
    return self;
}

- (void)setCommand:(NSString *)command parameter:(NSString *)parameter {
    self.command = command;
    self.parameter = parameter;
}


@end
