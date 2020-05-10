//
//  TTFeedBackViewController.m
//  ToptoTop
//
//  Created by 岳靖翔 on 2020/4/28.
//  Copyright © 2020 岳靖翔. All rights reserved.
//

#import "TTFeedBackViewController.h"
#import "TTConfig.h"
#import "MBProgressHUD.h"
#import <MessageUI/MFMailComposeViewController.h>
@interface TTFeedBackViewController ()<UITextViewDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate>{
    CGFloat _navHeight;
}
@property (nonatomic, strong) UITextView    *textView;
@property (nonatomic, strong) UITextField   *textField;
@property (nonatomic, strong) UIButton      *sendButton;
@property (nonatomic, assign) CGFloat       keyBorderNumber;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation TTFeedBackViewController
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navRect = self.navigationController.navigationBar.frame;
    _navHeight = statusRect.size.height + navRect.size.height;
    
    [self createTextView];
    [self createTextField];
    [self createOtherThing];
}

- (void)createTextView {
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(30, 40, g_afr_viewWidth - 60,
                                                                 g_afr_viewHeight / 3.0)];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.scrollEnabled = YES;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //允许编辑内容
    self.textView.editable = YES;
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.font = [UIFont systemFontOfSize:14.0];
    self.textView.textColor = [UIColor lightGrayColor];
    self.textView.layer.cornerRadius = 5.f;
    self.textView.text = @"在这里输入反馈...";
    //自适应高度
    //    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.textView];
}

- (void)createTextField {
    self.textField=[[UITextField alloc] initWithFrame:CGRectMake(30, self.textView.frame.origin.y + self.textView.frame.size.height + 20,
                                                                 g_afr_viewWidth - 60, 40)];
    self.textField.delegate = self;
    self.textField.placeholder = @"留下联系方式,方便客服联系(选填)";
    self.textField.font=[UIFont systemFontOfSize:14.0];
    self.textField.layer.borderWidth = 1;
    self.textField.textColor = [UIColor lightGrayColor];
    self.textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.textField.layer setCornerRadius:5];
    [self.view addSubview:self.textField];
    
}

- (void)createOtherThing {
    //初始化提交按钮
    self.sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.sendButton.frame = CGRectMake(30, self.textField.frame.origin.y + self.textField.frame.size.height + 20,
                                       g_afr_viewWidth - 60, 40);
    [self.sendButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.sendButton setTintColor:[UIColor whiteColor]];
    self.sendButton.backgroundColor = g_rgba(96, 155, 243, 1);
    [self.sendButton addTarget:self action:@selector(sendMailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.sendButton.layer.cornerRadius = 5.f;
    [self.view addSubview:self.sendButton];
    
}
#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.textView.text isEqualToString:@"在这里输入反馈..."]) {
        self.textView.text = @"";
    }
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y = currentFrame.origin.y - 10;
    self.view.frame = currentFrame;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.textView.text.length<1) {
        self.textView.text = @"在这里输入反馈...";
    }
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y = _navHeight;
    self.view.frame = currentFrame;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.textView resignFirstResponder];
        CGRect currentFrame = self.view.frame;
        currentFrame.origin.y = _navHeight;
        self.view.frame = currentFrame;
        return NO;
    }
    
    return YES;
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y = currentFrame.origin.y - self.keyBorderNumber / 2.0;
    self.view.frame = currentFrame;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y = _navHeight;
    self.view.frame = currentFrame;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    CGRect currentFrame = self.view.frame;
    currentFrame.origin.y = _navHeight;
    self.view.frame = currentFrame;
    
    [self.textField resignFirstResponder];
    return YES;
}
#pragma mark 计算键盘的高度
- (CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo {
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}


- (void)keyboardWillAppear:(NSNotification *)notification {
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    self.keyBorderNumber = change;
}
#pragma mark 点击背景去键盘的方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self.textView resignFirstResponder];
    [self.textField resignFirstResponder];
}
#pragma mark 点击提交按钮事件
- (void)sendMailButtonAction:(UIButton *)sender {
    if ([MFMailComposeViewController canSendMail] && ![self.textView.text isEqualToString:@"在这里输入反馈..."]) {
        [self sendMail];
    } else if ([self.textView.text isEqualToString:@"在这里输入反馈..."]) {
        [self showMessage:@"反馈为空" isSuccees:NO];
    } else {
        [self showMessage:@"未检测到邮件" isSuccees:NO];
    }
}
#pragma mark 发送邮件方法
- (void)sendMail {
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    //设置邮件主题
    [mc setSubject:@"一封来自用户反馈的邮件"];
    
    //设置主收件人
    [mc setToRecipients:[NSArray arrayWithObjects:@"792488979@qq.com", nil]];
    
    //设置邮件主体
    if (![self.textField.text isEqualToString:@""]) {
        NSString *str1 = self.textView.text;
        NSString *str2 = self.textField.text;
        NSString *sendStr = [NSString stringWithFormat:@"%@ 反馈者的联系方式: %@", str1, str2];
        [mc setMessageBody:sendStr isHTML:NO];
    } else {
        [mc setMessageBody:self.textView.text isHTML:NO];
    }
    
    [self presentViewController:mc animated:YES completion:nil];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(nullable NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            [self showMessage:@"反馈成功" isSuccees:YES];
            break;
        case MFMailComposeResultFailed:
            [self showMessage:@"反馈失败" isSuccees:NO];
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 提示框
- (void)showMessage:(NSString *)title isSuccees:(BOOL)isSucceed {
    if (isSucceed) {
        UIImage *image = [[UIImage imageNamed:@"loading_success"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.hud.customView = [[UIImageView alloc] initWithImage:image];
    } else {
        UIImage *image = [[UIImage imageNamed:@"loading_error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.hud.customView = [[UIImageView alloc] initWithImage:image];
    }
    self.hud.label.text = title;
    self.hud.square = YES;
    [self.hud showAnimated:YES];
    [self.hud hideAnimated:YES afterDelay:0.8];
}

- (MBProgressHUD *)hud {
    
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        _hud.mode = MBProgressHUDModeCustomView;
        _hud.label.textColor = [UIColor grayColor];
        _hud.offset = CGPointMake(0, -_navHeight);
        [self.view addSubview:_hud];
    }
    return _hud;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

@end
