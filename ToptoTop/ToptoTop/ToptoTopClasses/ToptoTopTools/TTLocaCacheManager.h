//
//  TTLocaCacheManager.h
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/5/1.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTLocaCacheManager : NSObject

+ (instancetype)shareInstance;

// 获取路径方法
- (NSString *)getCacheDirPath;
- (NSString *)getPhotoDirPath;
- (NSString *)getVideoDirPath;
- (NSString *)getMusicDirPath;
- (NSString *)getDocDirPath;
- (NSString *)getOtherFileDirPath;

// 获取路径内的文件名称数组
- (NSArray *)getDirContentsWithPath:(NSString *)path;

- (NSString *)getDirPathWithFileName:(NSString *)fileName;

- (BOOL)writeFileFromData:(NSData *)data toPath:(NSString *)filePath;

// 获取缓存数据大小
- (NSString *)getCacheDataSize;

// 清理缓存数据
- (void)clearCacheData;

@end

NS_ASSUME_NONNULL_END
