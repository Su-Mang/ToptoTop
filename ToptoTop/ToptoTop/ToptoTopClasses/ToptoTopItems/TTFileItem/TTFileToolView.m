//
//  TTFileToolView.m
//  ToptoTop
//
//  Created by Sumang on 2020/5/19.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTFileToolView.h"
@interface TTFileToolView()

@property (nonatomic, assign) BOOL      isUpload;
@property (nonatomic, assign) BOOL      hasDelete;

@end
@implementation TTFileToolView

- (instancetype)initWithFrame:(CGRect)frame isUpload:(BOOL)isUpload hasDelete:(BOOL)hasDelete {
    self = [self initWithFrame:frame];
    if (self) {
        self.isUpload = isUpload;
        self.hasDelete = hasDelete;
        [self setupView];
    }
    return self;
}


- (void)setupView {
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    CGFloat count = self.hasDelete == YES ? 3 : 2;
    CGFloat viewHeight = self.frame.size.height / 2.0;
    CGFloat originY = self.frame.size.height / 2.0 - viewHeight / 2.0;
    
    // 多选按钮
    CGFloat mutilOriginX = (self.frame.size.width / count) / 2.0 - viewHeight / 2.0;
    UIImageView *mutilChooseView = [[UIImageView alloc] initWithFrame:CGRectMake(mutilOriginX, originY, viewHeight, viewHeight)];
    mutilChooseView.image = [UIImage imageNamed:@"ic_file_tool_all"];
    mutilChooseView.userInteractionEnabled = YES;
    [self addSubview:mutilChooseView];
    
    UITapGestureRecognizer *mutilChooseTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(mutilChooseAction:)];
    [mutilChooseView addGestureRecognizer:mutilChooseTapGesture];
    
    // 上传下载按钮
    CGFloat upOriginX = self.hasDelete == YES ? (self.frame.size.width / 2.0 - viewHeight / 2.0) :
                                                (self.frame.size.width / 2.0 + (self.frame.size.width / 4.0 - viewHeight / 2.0));
    UIImageView *upAndDownView = [[UIImageView alloc] initWithFrame:CGRectMake(upOriginX, originY, viewHeight, viewHeight)];
    if (self.isUpload) {
        upAndDownView.image = [UIImage imageNamed:@"ic_file_tool_upload"];
    }
    else {
        upAndDownView.image = [UIImage imageNamed:@"ic_file_tool_download"];
    }
    
    upAndDownView.userInteractionEnabled = YES;
    [self addSubview:upAndDownView];
    
    UITapGestureRecognizer *secondTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(uploadAndDownAction:)];
    [upAndDownView addGestureRecognizer:secondTapGesture];
    
    // 删除按钮
    CGFloat deleteOriginX = self.frame.size.width / 3.0 * 2 + (self.frame.size.width / 6.0 - viewHeight / 2.0);
    UIImageView *deleteView = [[UIImageView alloc] initWithFrame:CGRectMake(deleteOriginX, originY, viewHeight, viewHeight)];
    deleteView.image = [UIImage imageNamed:@"ic_file_tool_delete"];
    deleteView.userInteractionEnabled = YES;
    [self addSubview:deleteView];
    
    UITapGestureRecognizer *deleteTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(deleteAction:)];
    [deleteView addGestureRecognizer:deleteTapGesture];
    if (self.hasDelete == NO) {
        deleteView.hidden = YES;
    }
    
    upAndDownView.hidden = YES;
}

- (void)mutilChooseAction:(UIBarButtonItem *)tap {
    if (self.toolDelegate && [self.toolDelegate respondsToSelector:@selector(mutilChooseAction)]) {
        [self.toolDelegate mutilChooseAction];
    }
}

- (void)uploadAndDownAction:(UITapGestureRecognizer *)tap {
    if (self.isUpload) {
        if (self.toolDelegate && [self.toolDelegate respondsToSelector:@selector(uploadAction)]) {
            [self.toolDelegate uploadAction];
        }
    }
    else {
        if (self.toolDelegate && [self.toolDelegate respondsToSelector:@selector(downloadAction)]) {
            [self.toolDelegate downloadAction];
        }
    }
}

- (void)deleteAction:(UITapGestureRecognizer *)tap {
    if (self.toolDelegate && [self.toolDelegate respondsToSelector:@selector(deleteAction)]) {
        [self.toolDelegate deleteAction];
    }
}

@end
