//
//  TTDefaultModel.h
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/21.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTDefaultModel : JSONModel
@property (nonatomic, copy) NSString    *command;
@property (nonatomic, copy) NSString    *parameter;

- (instancetype)initWithCommand:(NSString *)command parameter:(NSString *)parameter;
- (void)setCommand:(NSString *)command parameter:(NSString *)parameter;
@end

NS_ASSUME_NONNULL_END
