//
//  TTFileToolView.h
//  ToptoTop
//
//  Created by Sumang on 2020/5/19.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TTToolDelegate <NSObject>

@optional
- (void)mutilChooseAction;
- (void)uploadAction;
- (void)downloadAction;
- (void)deleteAction;

@end

@interface TTFileToolView : UIView
@property (nonatomic, weak) id<TTToolDelegate> toolDelegate;

- (instancetype)initWithFrame:(CGRect)frame isUpload:(BOOL)isUpload hasDelete:(BOOL)hasDelete;

@end

NS_ASSUME_NONNULL_END
