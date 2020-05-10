//
//  TTLocaCacheManager.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/5/1.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTLocaCacheManager.h"
#import "TTFileModel.h"
@interface TTLocaCacheManager ()
@property (nonatomic, copy) NSString    *cachePath;
@property (nonatomic, copy) NSString    *photoPath;
@property (nonatomic, copy) NSString    *videoPath;
@property (nonatomic, copy) NSString    *musicPath;
@property (nonatomic, copy) NSString    *docPath;
@property (nonatomic, copy) NSString    *filePath;

@end
static TTLocaCacheManager *manager = nil;

@implementation TTLocaCacheManager

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

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createFolders];
    }
    return self;
}

// 调用该类时就在单例中创建好所有文件夹
- (void)createFolders {
    //在沙盒中获取完整Documents的完整路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *TTFreeCachePath = [NSString stringWithFormat:@"%@/TTFree_Caches", docPath];
    BOOL isDir;
    //判断文件夹是否存在
    BOOL hasDir = [[NSFileManager defaultManager] fileExistsAtPath:TTFreeCachePath isDirectory:&isDir];
    if (hasDir == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:TTFreeCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    
    NSString *photoPath = [NSString stringWithFormat:@"%@/Photo", TTFreeCachePath];
    NSString *musicPath = [NSString stringWithFormat:@"%@/Music", TTFreeCachePath];
    NSString *videoPath = [NSString stringWithFormat:@"%@/Video", TTFreeCachePath];
    NSString *secondDocPath = [NSString stringWithFormat:@"%@/Document", TTFreeCachePath];
    NSString *otherPath = [NSString stringWithFormat:@"%@/OtherFile", TTFreeCachePath];
    BOOL hasPhotoDir = [[NSFileManager defaultManager] fileExistsAtPath:photoPath];
    BOOL hasMusicDir = [[NSFileManager defaultManager] fileExistsAtPath:musicPath];
    BOOL hasVideoDir = [[NSFileManager defaultManager] fileExistsAtPath:videoPath];
    BOOL hasDocDir = [[NSFileManager defaultManager] fileExistsAtPath:secondDocPath];
    BOOL hasOtherDir = [[NSFileManager defaultManager] fileExistsAtPath:otherPath];
    if (hasPhotoDir == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:photoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (hasMusicDir == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:musicPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (hasVideoDir == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:videoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (hasDocDir == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:secondDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (hasOtherDir == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:otherPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    self.cachePath = TTFreeCachePath;
    self.photoPath = photoPath;
    self.videoPath = videoPath;
    self.musicPath = musicPath;
    self.docPath = secondDocPath;
    self.filePath = otherPath;
}

- (NSString *)getCacheDirPath {
    return self.cachePath;
}

- (NSString *)getPhotoDirPath {
    return self.photoPath;
}

- (NSString *)getVideoDirPath {
    return self.videoPath;
}

- (NSString *)getMusicDirPath {
    return self.musicPath;
}

- (NSString *)getDocDirPath {
    return self.docPath;
}

- (NSString *)getOtherFileDirPath {
    return self.filePath;
}

- (NSString *)getDirPathWithFileName:(NSString *)fileName {
    fileName = [fileName lowercaseString];
    if ([fileName hasSuffix:@".jpg"] ||
        [fileName hasSuffix:@".jpeg"] ||
        [fileName hasSuffix:@".gif"] ||
        [fileName hasSuffix:@".bmp"] ||
        [fileName hasSuffix:@".png"] ||
        [fileName hasSuffix:@".psd"] ||
        [fileName hasSuffix:@".svg"] ||
        [fileName hasSuffix:@".swf"]) {
        return [self getPhotoDirPath];
    } else if ([fileName hasSuffix:@".mp3"] ||
               [fileName hasSuffix:@".mp4"] ||
               [fileName hasSuffix:@".wma"] ||
               [fileName hasSuffix:@".amr"] ||
               [fileName hasSuffix:@".wav"] ) {
        return [self getMusicDirPath];
    } else if ([fileName hasSuffix:@".apk"]) {
        return [self getOtherFileDirPath];
    }
    else if ([fileName hasSuffix:@".avi"] ||
             [fileName hasSuffix:@".wmv"] ||
             [fileName hasSuffix:@".mp4"] ||
             [fileName hasSuffix:@".mov"] ||
             [fileName hasSuffix:@".rmvb"] ||
             [fileName hasSuffix:@".flv"] ||
             [fileName hasSuffix:@".mpeg"]) {
        return [self getVideoDirPath];
    }
    else if ([fileName hasSuffix:@".doc"] ||
             [fileName hasSuffix:@".docx"] ||
             [fileName hasSuffix:@".xls"] ||
             [fileName hasSuffix:@".xlsx"] ||
             [fileName hasSuffix:@".ppt"] ||
             [fileName hasSuffix:@".pptx"] ||
             [fileName hasSuffix:@".pdf"] ||
             [fileName hasSuffix:@".wps"] ||
             [fileName hasSuffix:@".txt"] ||
             [fileName hasSuffix:@".md"]) {
        return [self getDocDirPath];
    }
    else {
        return [self getOtherFileDirPath];
    }
}

- (BOOL)writeFileFromData:(NSData *)data toPath:(NSString *)filePath {
    
    NSError *error = nil;
    BOOL isWrite = [data writeToFile:filePath options:NSDataWritingAtomic error:&error];
    if (error != nil) {
        // error log
        NSLog(@"%s %@", __func__, error);
    }
    
    return isWrite;
}

// 获取路径内的文件名称数组
- (NSArray *)getDirContentsWithPath:(NSString *)path {
    NSError *error = nil;
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *name in contents) {
       TTFileModel *model = [[TTFileModel alloc] init];
        model.fileName = name;
        model.filePath = [path stringByAppendingPathComponent:name];
        model.fileUrl = [NSURL URLWithString:model.filePath];
        if ([path isEqualToString:[self getPhotoDirPath]]) {
            model.fileType = TTFileTypePic;
            [model setFileIconWithFileName:name];
            
        }
        else if ([path isEqualToString:[self getMusicDirPath]]) {
            model.fileType = TTFileTypeVideo;
            [model setFileIconWithFileName:name];
        }
        else if ([path isEqualToString:[self getVideoDirPath]]) {
            model.fileType = TTFileTypeVideo;
            [model setFileIconWithFileName:name];
        }
        else if ([path isEqualToString:[self getDocDirPath]]) {
            model.fileType = TTFileTypeFile;
            [model setFileIconWithFileName:name];
        }
        else if ([path isEqualToString:[self getOtherFileDirPath]]) {
            model.fileType = TTFileTypeFile;
            [model setFileIconWithFileName:name];
        }
        [array addObject:model];
    }
    
    return error == nil ? array : nil;
}

// 获取缓存数据大小
- (NSString *)getCacheDataSize {
    
    NSUInteger photoSize = [self getCacheSizeWithPath:self.photoPath];
    NSUInteger videoSize = [self getCacheSizeWithPath:self.videoPath];
    NSUInteger musicSize = [self getCacheSizeWithPath:self.musicPath];
    NSUInteger docSize = [self getCacheSizeWithPath:self.docPath];
    NSUInteger fileSize = [self getCacheSizeWithPath:self.filePath];
    
    NSUInteger allSize = photoSize + videoSize + musicSize + docSize + fileSize;
    NSString *resultStr = [NSByteCountFormatter stringFromByteCount:allSize countStyle:NSByteCountFormatterCountStyleBinary];
    if ([resultStr hasPrefix:@"Zero"]) {
        resultStr = [resultStr stringByReplacingOccurrencesOfString:@"Zero" withString:@"0"];
    }
    
    return resultStr;
}

// 计算每个文件夹中的文件大小
- (NSUInteger)getCacheSizeWithPath:(NSString *)path {
    
    NSUInteger size = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *dirDic = [fileManager attributesOfItemAtPath:path error:nil];
        if ([dirDic.fileType isEqualToString:NSFileTypeDirectory]) {
            NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:path];
            for (NSString *subPath in enumerator) {
                NSString *fullPath = [path stringByAppendingPathComponent:subPath];
                size += [[fileManager attributesOfItemAtPath:fullPath error:nil] fileSize];
            }
        }
    }
    
    return size;
}

// 清理缓存数据
- (void)clearCacheData {
    
    [self clearCacheWithPath:self.photoPath];
    [self clearCacheWithPath:self.musicPath];
    [self clearCacheWithPath:self.videoPath];
    [self clearCacheWithPath:self.docPath];
    [self clearCacheWithPath:self.filePath];
}

- (void)clearCacheWithPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childFilePaths = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childFilePaths) {
            NSString *fullPath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:fullPath error:nil];
        }
    }
}

@end
