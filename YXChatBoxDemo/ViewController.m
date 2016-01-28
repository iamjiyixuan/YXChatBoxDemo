//
//  ViewController.m
//  YXChatBoxDemo
//
//  Created by JI Yixuan on 16/1/28.
//  Copyright © 2016年 iamjiyixuan. All rights reserved.
//

#import "ViewController.h"
#import "YXChatBox.h"

// 3rd
#import <Masonry/Masonry.h>

CGFloat kScreenWith()
{
    return [UIScreen mainScreen].bounds.size.width;
}

CGFloat kScreenHeight()
{
    return [UIScreen mainScreen].bounds.size.height;
}

@interface ViewController () <YXChatBoxDelegate>

@property(nonatomic, strong) YXChatBox *chatBox;
@property(nonatomic, strong) UIView *emojiView;
@property(nonatomic, strong) UIView *layoutHelperView;

@property(nonatomic, assign) CGFloat keyboardH;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.keyboardH = 0;
    self.emojiView.hidden = YES;
    
    [self.view addSubview:self.chatBox];
    [self.view addSubview:self.layoutHelperView];
    [self.view addSubview:self.emojiView];
    
    [self.layoutHelperView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWith());
        make.height.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.top.mas_equalTo(self.chatBox.mas_bottom);
    }];
    
    [self.chatBox mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWith());
//        make.height.mas_equalTo(50);
    }];
    
    [self.emojiView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWith());
        make.height.mas_equalTo(120);
        make.bottom.mas_equalTo(self.view.mas_bottom);
//        make.top.mas_equalTo(self.chatBox.mas_bottom);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)onTap:(id)sender
{
    [self.chatBox.textView resignFirstResponder];
}

#pragma mark - keyboard

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self.layoutHelperView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.layoutHelperView layoutIfNeeded];
        [self.chatBox layoutIfNeeded];
    }];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    self.keyboardH = keyboardFrame.size.height;
    
    [self.layoutHelperView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(keyboardFrame.size.height);
    }];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.layoutHelperView layoutIfNeeded];
        [self.chatBox layoutIfNeeded];
    }];
}

#pragma mark - YXChatBoxDelegate

- (void)yx_chatBox:(YXChatBox *)chatBox fromStatus:(YXChatBoxStatus)fromStatus toStatus:(YXChatBoxStatus)toStatus
{
    if (toStatus == YXChatBoxStatusShowEmojiKeyboard) {
        [self.chatBox.textView resignFirstResponder];
        self.emojiView.hidden = YES;
    }
    else {
        self.emojiView.hidden = NO;
    }
}

#pragma mark - Getters & Setters

- (YXChatBox *)chatBox
{
    if (!_chatBox) {
        _chatBox = [[YXChatBox alloc] init];
        _chatBox.delegate = self;
        _chatBox.layer.borderWidth = 1;
        _chatBox.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _chatBox;
}

- (UIView *)emojiView
{
    if (!_emojiView) {
        _emojiView = [[UIView alloc] init];
        _emojiView.backgroundColor = [UIColor orangeColor];
    }
    return _emojiView;
}

- (UIView *)layoutHelperView
{
    if (!_layoutHelperView) {
        _layoutHelperView = [[UIView alloc] init];
        
//        _layoutHelperView.backgroundColor = [UIColor orangeColor];
    }
    return _layoutHelperView;
}

@end
