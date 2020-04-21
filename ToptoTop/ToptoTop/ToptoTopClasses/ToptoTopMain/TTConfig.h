//
//  TTConfig.h
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/21.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#ifndef TTConfig_h
#define TTConfig_h
#define g_afr_viewWidth [UIScreen mainScreen].bounds.size.width
#define g_afr_viewHeight [UIScreen mainScreen].bounds.size.height

#define g_rgba(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]

#define g_width_6(x) (x / 375.0) * g_afr_viewWidth

#define g_height_6(y) (y / 667.0) * g_afr_viewHeight

#define g_afr_remotedevice  @"远程设备"
#define g_afr_pic           @"图片"
#define g_afr_video         @"视频"
#define g_afr_music         @"音乐"
#define g_afr_doc           @"文档"
#define g_afr_down          @"下载"
#define g_afr_mouse         @"鼠标控制"
#define g_afr_voice         @"语音控制"
#define g_afr_volum         @"音量调节"
#define g_afr_power         @"电源选项"
#define g_afr_light         @"亮度调节"
#define g_afr_remotestart   @"远程启动"
#define g_afr_screenshot    @"屏幕抓取"
#define g_afr_qustion       @"常见问题"
#define g_afr_clearcache    @"缓存清除"
#define g_afr_feedback      @"意见反馈"
#define g_afr_aboutus       @"关于我们"

// 科大讯飞语音
#define g_appid_value       @"5adda923"


#endif /* TTConfig_h */
