//
//  TTResourceManager.h
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/21.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTResourceManager : NSObject
+ (instancetype)shareInstance;

// 文件部分资源
- (NSArray<NSString *> *)getFileTexts;
- (NSArray<NSString *> *)getFileIcons;

// 控制部分资源
- (NSArray<NSString *> *)getControlTexts;
- (NSArray<NSString *> *)getControlIcons;

// 设置部分资源
- (NSArray<NSString *> *)getSettingTexts;
- (NSArray<NSString *> *)getSettingIcons;

@end

NS_ASSUME_NONNULL_END
