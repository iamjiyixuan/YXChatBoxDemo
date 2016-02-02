//
//  ViewController.m
//  YXChatBoxDemo
//
//  Created by JI Yixuan on 16/1/28.
//  Copyright © 2016年 iamjiyixuan. All rights reserved.
//

#import "ViewController.h"
#import "YXChatBox.h"
#import "YXMoreView.h"
#import "YXEmojiView.h"

// 3rd
#import <Masonry/Masonry.h>
#import <HexColors/HexColors.h>

static CGFloat kEmojiViewH = 217.0f;

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
@property(nonatomic, strong) YXEmojiView *emojiView;
@property(nonatomic, strong) YXMoreView *moreView;
@property(nonatomic, strong) UIView *layoutHelperView;

@property(nonatomic, strong) UIButton *testButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.emojiView.hidden = YES;
    
    [self.view addSubview:self.chatBox];
    [self.view addSubview:self.layoutHelperView];
    [self.view addSubview:self.emojiView];
    [self.view addSubview:self.moreView];
    
//    [self.view addSubview:self.testButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tap];
    
    [self.chatBox mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWith());
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
    }];
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
    if (self.chatBox.status == YXChatBoxStatusNone) {
        return;
    }
    
    [self.chatBox resignFirstResponder];

    [UIView animateWithDuration:0.25f animations:^{
        
        //  reset emojiView
        CGFloat emojiViewH = kEmojiViewH;
        self.emojiView.frame = CGRectMake(0, kScreenHeight(), kScreenWith(), emojiViewH);
        
        // reset moreView
        CGFloat moreViewH = 290.0f;
        self.moreView.frame = CGRectMake(0, kScreenHeight(), kScreenWith(), moreViewH);
        
        [self.chatBox mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
        [self.chatBox layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        self.moreView.hidden = YES;
        self.emojiView.hidden = YES;
    }];
}

#pragma mark - keyboard

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (self.chatBox.status == YXChatBoxStatusShowEmojiKeyboard || self.chatBox.status == YXChatBoxStatusShowMoreKeyboard) {
        return;
    }
    
    [self.chatBox mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [self.chatBox layoutIfNeeded];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
//    self.chatBox.frame = CGRectMake(0, kScreenHeight() - self.keyboardH - self.chatBox.frame.size.height, self.chatBox.frame.size.width, self.chatBox.frame.size.height);
    
    [self.chatBox mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-keyboardFrame.size.height);
    }];
    [self.chatBox layoutIfNeeded];
}

#pragma mark - YXChatBoxDelegate

- (void)yx_chatBox:(YXChatBox *)chatBox fromStatus:(YXChatBoxStatus)fromStatus toStatus:(YXChatBoxStatus)toStatus
{
    //  reset emojiView
    self.emojiView.frame = CGRectMake(0, kScreenHeight(), kScreenWith(), kEmojiViewH);
    self.emojiView.hidden = YES;
    
    // reset moreView
    CGFloat moreViewH = 100.0f;
    self.moreView.frame = CGRectMake(0, kScreenHeight(), kScreenWith(), moreViewH);
    self.moreView.hidden = YES;
    
    if (fromStatus == YXChatBoxStatusShowKeyboard && toStatus == YXChatBoxStatusNone) {
        
        [UIView animateWithDuration:0.25f animations:^{
            [self.chatBox mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.view.mas_bottom);
            }];
            [self.chatBox layoutIfNeeded];
        }];
    }
    else if (toStatus == YXChatBoxStatusShowEmojiKeyboard) {
        
        self.emojiView.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^{
            
            self.emojiView.frame = CGRectMake(0, kScreenHeight() - kEmojiViewH, kScreenWith(), kEmojiViewH);
            
            [self.chatBox mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kEmojiViewH);
            }];
            [self.chatBox layoutIfNeeded];
        }];
    }
    else if (toStatus == YXChatBoxStatusShowMoreKeyboard) {
        
        self.moreView.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^{
            
            self.moreView.frame = CGRectMake(0, kScreenHeight() - moreViewH, kScreenWith(), moreViewH);

            [self.chatBox mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.view.mas_bottom).offset(-moreViewH);
            }];
            [self.chatBox layoutIfNeeded];
        }];
    }
    else if (toStatus == YXChatBoxStatusVoice) {
        
        [UIView animateWithDuration:0.25f animations:^{
            [self.chatBox mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.view.mas_bottom);
            }];
            [self.chatBox layoutIfNeeded];
        }];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect f = self.emojiView.frame;
    
    if (f.size.width) {
        
    }
}

#pragma mark - Getters & Setters

- (YXChatBox *)chatBox
{
    if (!_chatBox) {
        _chatBox = [[YXChatBox alloc] initWithFrame:CGRectMake(0, kScreenHeight() - 50.0f, kScreenWith(), 50.0f)];
        _chatBox.delegate = self;
//        _chatBox.layer.borderWidth = 1;
//        _chatBox.layer.borderColor = [UIColor redColor].CGColor;
        
        _chatBox.backgroundColor = [UIColor hx_colorWithHexString:@"#f4f6f3"];
    }
    return _chatBox;
}

- (YXEmojiView *)emojiView
{
    if (!_emojiView) {
        _emojiView = [[YXEmojiView alloc] init];
//        _emojiView.backgroundColor = [UIColor orangeColor];
    }
    return _emojiView;
}

- (YXMoreView *)moreView
{
    if (!_moreView) {
        _moreView = [[YXMoreView alloc] init];
    }
    return _moreView;
}

- (UIView *)layoutHelperView
{
    if (!_layoutHelperView) {
        _layoutHelperView = [[UIView alloc] init];
        
        _layoutHelperView.backgroundColor = [UIColor orangeColor];
    }
    return _layoutHelperView;
}

- (UIButton *)testButton
{
    if (!_testButton) {
        _testButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 160, 90)];
        [_testButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_testButton setTitle:@"Test" forState:UIControlStateNormal];
        
        _testButton.layer.borderWidth = 1;
        _testButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        
        [_testButton addTarget:self action:@selector(onRecordButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_testButton addTarget:self action:@selector(onRecordButtonTouchDownRepeat:) forControlEvents:UIControlEventTouchDownRepeat];
        [_testButton addTarget:self action:@selector(onRecordButtonTouchDragInside:) forControlEvents:UIControlEventTouchDragInside];
        [_testButton addTarget:self action:@selector(onRecordButtonTouchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
        [_testButton addTarget:self action:@selector(onRecordButtonTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [_testButton addTarget:self action:@selector(onRecordButtonTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [_testButton addTarget:self action:@selector(onRecordButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_testButton addTarget:self action:@selector(onRecordButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [_testButton addTarget:self action:@selector(onRecordButtonTouchCancel:) forControlEvents:UIControlEventTouchCancel];
        
        NSLog(@"frame = %@", NSStringFromCGRect(self.testButton.frame));
        NSLog(@"bounds = %@", NSStringFromCGRect(self.testButton.bounds));
    }
    return _testButton;
}

- (void)onRecordButtonTouchDown:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onRecordButtonTouchDownRepeat:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onRecordButtonTouchDragInside:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onRecordButtonTouchDragOutside:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onRecordButtonTouchDragEnter:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onRecordButtonTouchDragExit:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onRecordButtonTouchUpInside:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onRecordButtonTouchUpOutside:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onRecordButtonTouchCancel:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
