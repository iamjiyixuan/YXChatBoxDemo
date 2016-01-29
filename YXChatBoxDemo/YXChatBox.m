//
//  YXChatBox.m
//  YXChatBoxDemo
//
//  Created by JI Yixuan on 16/1/28.
//  Copyright © 2016年 iamjiyixuan. All rights reserved.
//

#import "YXChatBox.h"


// 3rd
#import <Masonry/Masonry.h>

static CGFloat kYXChatBoxTextViewPadding = 10.0f;

@interface YXChatBox () <UITextViewDelegate>

@end

@implementation YXChatBox

- (instancetype)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    // add subviews
    [self addSubview:self.textView];
    [self addSubview:self.emojiButton];
    [self addSubview:self.moreButton];

    // layout subview
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {

        CGFloat textViewHeight = [self.textView sizeThatFits:self.textView.frame.size].height;

        make.left.mas_equalTo(self.mas_left).offset(kYXChatBoxTextViewPadding);
        make.top.mas_equalTo(self.mas_top).offset(kYXChatBoxTextViewPadding);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kYXChatBoxTextViewPadding);
//        make.height.mas_equalTo(ceilf(textViewHeight));
        make.height.mas_equalTo(textViewHeight);
    }];

    [self.emojiButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35.0f, 35.0f));
        make.left.mas_equalTo(self.textView.mas_right).offset(kYXChatBoxTextViewPadding / 2);
        make.bottom.mas_equalTo(self.textView.mas_bottom);
    }];

    [self.moreButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35.0f, 35.0f));
        make.left.mas_equalTo(self.emojiButton.mas_right); //.offset(kYXChatBoxTextViewPadding / 2);
        make.right.mas_equalTo(self.mas_right).offset(-kYXChatBoxTextViewPadding / 2);
        make.bottom.mas_equalTo(self.textView.mas_bottom);
    }];
}

- (BOOL)resignFirstResponder
{
    [self.textView resignFirstResponder];
    
    if (self.status == YXChatBoxStatusShowEmojiKeyboard) {
        [self resetEmojiButton];
    }
    else if (self.status == YXChatBoxStatusShowMoreKeyboard) {
        [self resetMoreButton];
    }
    
    return [super resignFirstResponder];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    YXChatBoxStatus lastStatus = self.status;
    self.status = YXChatBoxStatusShowKeyboard;
    
    [self resetEmojiButton];
    [self resetMoreButton];
    
    if ([self.delegate respondsToSelector:@selector(yx_chatBox:fromStatus:toStatus:)]) {
        [self.delegate yx_chatBox:self fromStatus:lastStatus toStatus:self.status];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
//    YXChatBoxStatus lastStatus = self.status;
//    if (lastStatus == YXChatBoxStatusShowKeyboard) {
//        self.status = YXChatBoxStatusNone;
//    }
//    
//    [self resetEmojiButton];
//    [self resetMoreButton];
//    
//    if ([self.delegate respondsToSelector:@selector(yx_chatBox:fromStatus:toStatus:)]) {
//        [self.delegate yx_chatBox:self fromStatus:lastStatus toStatus:self.status];
//    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self relayoutTextView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}

#pragma mark - Actions

- (void)onEmojiButtonTouchUpInside:(UIButton *)sender
{
    [self resetMoreButton];

    YXChatBoxStatus lastStatus = self.status;
    if (lastStatus == YXChatBoxStatusShowEmojiKeyboard) { // 正在显示表情，改为显示系统键盘

        self.status = YXChatBoxStatusShowKeyboard;

        [self.emojiButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];

        [self.textView becomeFirstResponder];
    }
    else {

        self.status = YXChatBoxStatusShowEmojiKeyboard;

        [self.emojiButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];

        [self.textView resignFirstResponder];
    }

    if ([self.delegate respondsToSelector:@selector(yx_chatBox:fromStatus:toStatus:)]) {
        [self.delegate yx_chatBox:self fromStatus:lastStatus toStatus:self.status];
    }
}

- (void)onMoreButtonTouchUpInside:(UIButton *)sender
{
    [self resetEmojiButton];

    YXChatBoxStatus lastStatus = self.status;
    if (lastStatus == YXChatBoxStatusShowMoreKeyboard) {

        self.status = YXChatBoxStatusShowKeyboard;

        [self.moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];

        [self.textView becomeFirstResponder];
    }
    else {

        self.status = YXChatBoxStatusShowMoreKeyboard;

        [self.moreButton setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];

        [self.textView resignFirstResponder];
    }
    
    if ([self.delegate respondsToSelector:@selector(yx_chatBox:fromStatus:toStatus:)]) {
        [self.delegate yx_chatBox:self fromStatus:lastStatus toStatus:self.status];
    }
}

#pragma mark - Private

- (void)resetEmojiButton
{
    [self.emojiButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
}

- (void)resetMoreButton
{
    [self.moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
}

- (void)relayoutTextView
{
    CGFloat height = MIN([self.textView sizeThatFits:self.textView.frame.size].height, 15.0f * 5); // 最多显示5行
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(ceilf(height));
        make.height.mas_equalTo(height);
    }];

    [self.textView layoutIfNeeded];
}

#pragma mark - Getters & Setters

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.scrollsToTop = NO;
        _textView.clipsToBounds = YES;
        _textView.font = [UIFont systemFontOfSize:18];
        _textView.textColor = [UIColor darkTextColor];
        _textView.layer.cornerRadius = 1.5f;
        _textView.layer.borderWidth = 0.5f;
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _textView;
}

- (UIButton *)emojiButton
{
    if (!_emojiButton) {
        _emojiButton = [[UIButton alloc] init];
        [_emojiButton setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [_emojiButton addTarget:self action:@selector(onEmojiButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiButton;
}

- (UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(onMoreButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

@end
