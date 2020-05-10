//
//  TTJumpCtrManager.h
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/27.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class TTBaseViewController;
@interface TTJumpCtrManager : NSObject
+ (TTBaseViewController *)getVCFromText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
