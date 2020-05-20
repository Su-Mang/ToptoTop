//
//  TTJumpCtrManager.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/27.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTJumpCtrManager.h"
#import <UIKit/UIKit.h>
#import "TTQAndAViewController.h"
#import "TTAboutUsViewController.h"
#import "TTFeedBackViewController.h"
#import "TTBaseViewController.h"
#import "TTClearCacheViewController.h"
#import "TTFileListViewController.h"


@implementation TTJumpCtrManager
+ (TTBaseViewController *)getVCFromText:(NSString *)text {
    
    NSDictionary *vcDic = [self dicForTextAndVC];
    NSString *vcStr = [vcDic objectForKey:text];
    
    if (!vcStr) {
        return nil;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([text isEqualToString:g_afr_pic] || [text isEqualToString:g_afr_video]) {
        [dic setObject:@(YES) forKey:@"isPicOrVideo"];
    }
    else {
        [dic setObject:@(NO) forKey:@"isPicOrVideo"];
    }
    
    if ([text isEqualToString:g_afr_down]) {
        [dic setObject:@(YES) forKey:@"isShowDownDir"];
    }
    else {
        [dic setObject:@(NO) forKey:@"isShowDownDir"];
    }
    
    if ([text isEqualToString:g_afr_remotedevice]) {
        [dic setObject:@(YES) forKey:@"isRemoteDevice"];
        [dic setObject:@"this PC" forKey:@"remotePath"];
    }
    else {
        [dic setObject:@(NO) forKey:@"isRemoteDevice"];
    }
    Class vcClass = NSClassFromString(vcStr);
    TTBaseViewController *vc = (TTBaseViewController *)[vcClass new];
    vc.title = text;
    [vc decodeParamWithDic:dic];
    
    return vc;
}
+ (NSDictionary *)dicForTextAndVC {
    
    return @{g_afr_remotedevice      : @"TTFileListViewController",
             g_afr_pic              : @"TTFileListViewController",
             g_afr_music            : @"TTFileListViewController",
             g_afr_video            : @"TTFileListViewController",
             g_afr_doc              : @"TTFileListViewController",
             g_afr_down             : @"TTFileListViewController",
             g_afr_mouse            : @"AFRMouseCtrViewController",
             g_afr_voice            : @"AFRVoiceViewController",
             g_afr_volum            : @"AFRVALViewController",
             g_afr_power            : @"AFRPowerViewController",
             g_afr_light            : @"AFRVALViewController",
             g_afr_remotestart      : @"AFRRemoteCtrViewController",
             g_afr_screenshot       : @"AFRScreenShotViewController",
             g_afr_qustion          : @"TTQAndAViewController",
             g_afr_clearcache       : @"TTClearCacheViewController",
             g_afr_feedback         : @"TTFeedBackViewController",
             g_afr_aboutus          : @"TTAboutUsViewController"
             };
}

@end
