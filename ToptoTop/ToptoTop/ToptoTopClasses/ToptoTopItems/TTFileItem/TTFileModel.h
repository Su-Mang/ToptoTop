//
//  TTFileModel.h
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/30.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    TTFileTypeUnknow,
    TTFileTypeFloder,
    TTFileTypeVideo,
    TTFileTypePic,
    TTFileTypeFile,
} TTFileType;
typedef enum : NSUInteger {
    TTFileStatusUpload,
    TTFileStatusDownload,
} TTFileStatus;

@interface TTFileModel : NSObject
@property (nonatomic, assign)   TTFileType     fileType;
@property (nonatomic, assign)   TTFileStatus   filestatus;
@property (nonatomic, copy)     NSString        *fileIcon;
@property (nonatomic, copy)     NSString        *fileName;
@property (nonatomic, copy)     NSString        *fileDetail;
@property (nonatomic, copy)     NSString        *filePath;
@property (nonatomic, assign)   CGFloat         fileProcess;

@property (nonatomic, assign)   NSInteger       fileTag;
@property (nonatomic, strong)   UIImage         *fileImage;
@property (nonatomic, copy)     NSURL           *fileUrl;

- (void)setFileIconWithFileName:(NSString *)fileName;
@end

NS_ASSUME_NONNULL_END
