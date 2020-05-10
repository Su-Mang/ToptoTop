//
//  TTFileModel.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/30.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTFileModel.h"

@implementation TTFileModel

- (void)setFileIconWithFileName:(NSString *)fileName {
    
    fileName = [fileName lowercaseString];
    if ([fileName hasSuffix:@".zip"] || [fileName hasSuffix:@".7z"]) {
        self.fileIcon = @"ic_fm_icon_zip";
    }
    else if ([fileName hasSuffix:@".jpg"] ||
             [fileName hasSuffix:@".jpeg"] ||
             [fileName hasSuffix:@".gif"] ||
             [fileName hasSuffix:@".bmp"] ||
             [fileName hasSuffix:@".png"] ||
             [fileName hasSuffix:@".psd"] ||
             [fileName hasSuffix:@".svg"] ||
             [fileName hasSuffix:@".swf"] ||
             (self.fileType == TTFileTypePic)) {
        self.fileIcon = @"ic_fm_icon_pic";
        self.fileType = TTFileTypePic;
    }
    else if ([fileName hasSuffix:@".mp3"] ||
             [fileName hasSuffix:@".mp4"] ||
             [fileName hasSuffix:@".wma"] ||
             [fileName hasSuffix:@".amr"] ||
             [fileName hasSuffix:@".wav"] ) {
        self.fileIcon = @"ic_fm_icon_music";
        self.fileType = TTFileTypeVideo;
    }
    else if ([fileName hasSuffix:@".apk"]) {
        self.fileIcon = @"ic_fm_icon_apk";
        self.fileType = TTFileTypeFile;
    }
    else if ([fileName hasSuffix:@".avi"] ||
             [fileName hasSuffix:@".wmv"] ||
             [fileName hasSuffix:@".mp4"] ||
             [fileName hasSuffix:@".mov"] ||
             [fileName hasSuffix:@".rmvb"] ||
             [fileName hasSuffix:@".flv"] ||
             [fileName hasSuffix:@".mpeg"] ||
             (self.fileType == TTFileTypeVideo)) {
        self.fileIcon = @"ic_fm_icon_video";
        self.fileType = TTFileTypeVideo;
    }
    else if (self.fileType == TTFileTypeFloder) {
        self.fileIcon = @"ic_fm_icon_folder";
        self.fileType = TTFileTypeFloder;
    }
    else {
        self.fileIcon = @"ic_fm_icon_file";
        self.fileType = TTFileTypeFile;
    }
}

@end
