//
//  TTResourceManager.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/21.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTResourceManager.h"
#import "TTConfig.h"
static TTResourceManager * manager = nil;
@implementation TTResourceManager
+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
    });
    return manager;
    
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self shareInstance];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

// 文件部分资源
- (NSArray<NSString *> *)getFileTexts {
    
    //    return @[@"远程设备", @"内部存储", @"图片", @"音乐", @"视频", @"文档", @"下载"];
    return @[g_afr_remotedevice, g_afr_pic, g_afr_music, g_afr_video, g_afr_doc, g_afr_down];
    
}
- (NSArray<NSString *> *)getFileIcons {
    //    return @[@"ic_transfer_pc",
    //             @"ic_file_category_device",
    //             @"ic_file_category_image",
    //             @"ic_file_category_music",
    //             @"ic_file_category_video",
    //             @"ic_file_category_doc",
    //             @"ic_file_category_download"];
    
    return @[@"ic_transfer_pc",
             @"ic_file_category_image",
             @"ic_file_category_music",
             @"ic_file_category_video",
             @"ic_file_category_doc",
             @"ic_file_category_download"];
}

// 控制部分资源
- (NSArray<NSString *> *)getControlTexts {
    
    return @[g_afr_mouse, g_afr_voice, g_afr_volum, g_afr_power, g_afr_light, g_afr_remotestart, g_afr_screenshot];
}
- (NSArray<NSString *> *)getControlIcons {
    
    return @[@"ic_mouse_control",
             @"ic_voice_control",
             @"ic_volume_control",
             @"ic_power_control",
             @"ic_bright_control",
             @"ic_screen_contorl",
             @"ic_shot_control"];
}

// 设置部分资源
- (NSArray<NSString *> *)getSettingTexts {
    
    return @[g_afr_qustion, g_afr_clearcache, g_afr_feedback, g_afr_aboutus];
}
- (NSArray<NSString *> *)getSettingIcons {
    
    return @[@"ic_common_problem",
             @"ic_regedit_control",
             @"ic_feedback",
             @"ic_about_us"];
}

@end
