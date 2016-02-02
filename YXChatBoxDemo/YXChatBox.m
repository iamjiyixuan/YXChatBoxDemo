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

@property(nonatomic, assign) BOOL isImportant;
@property(nonatomic, copy) NSString *textViewText;

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
    [self addSubview:self.switchButton];
    [self addSubview:self.recordButton];

    CGFloat textViewHeight = [self.textView sizeThatFits:self.textView.frame.size].height;
    // layout subview
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {

        //        make.left.mas_equalTo(self.mas_left).offset(kYXChatBoxTextViewPadding);
        make.top.mas_equalTo(self.mas_top).offset(kYXChatBoxTextViewPadding);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kYXChatBoxTextViewPadding);
        make.height.mas_equalTo(ceilf(textViewHeight));
    }];

    [self.emojiButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25.0f, 25.0f));
        make.left.mas_equalTo(self.textView.mas_right).offset(kYXChatBoxTextViewPadding / 2);
        make.bottom.mas_equalTo(self.textView.mas_bottom);
    }];

    [self.moreButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25.0f, 25.0f));
        make.left.mas_equalTo(self.emojiButton.mas_right).offset(kYXChatBoxTextViewPadding / 2);
        make.right.mas_equalTo(self.mas_right).offset(-kYXChatBoxTextViewPadding / 2);
        make.bottom.mas_equalTo(self.textView.mas_bottom);
    }];

    [self.switchButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25.0f, 25.0f));
        make.left.mas_equalTo(self.mas_left).offset(kYXChatBoxTextViewPadding / 2);
        make.right.mas_equalTo(self.textView.mas_left).offset(-kYXChatBoxTextViewPadding / 2);
        make.bottom.mas_equalTo(self.textView.mas_bottom);
    }];

    [self.recordButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.textView).with.insets(UIEdgeInsetsZero);
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

    self.status = YXChatBoxStatusNone;
    self.isImportant = NO;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;

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
    self.textViewText = self.textView.text;
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
    [self resetRecordButton];

    YXChatBoxStatus lastStatus = self.status;
    if (lastStatus == YXChatBoxStatusShowEmojiKeyboard) { // 正在显示表情，改为显示系统键盘

        // 表情 -> 系统键盘
        self.status = YXChatBoxStatusShowKeyboard;

        [self.emojiButton setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];

        [self.textView becomeFirstResponder];
    }
    else {

        //  -> 表情
        self.status = YXChatBoxStatusShowEmojiKeyboard;

        [self.emojiButton setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];

        [self.textView resignFirstResponder];
    }

    if ([self.delegate respondsToSelector:@selector(yx_chatBox:fromStatus:toStatus:)]) {
        [self.delegate yx_chatBox:self fromStatus:lastStatus toStatus:self.status];
    }
}

- (void)onMoreButtonTouchUpInside:(UIButton *)sender
{
    [self resetEmojiButton];
    [self resetRecordButton];

    YXChatBoxStatus lastStatus = self.status;
    if (lastStatus == YXChatBoxStatusShowMoreKeyboard) {

        self.status = YXChatBoxStatusShowKeyboard;

        [self.moreButton setBackgroundImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];

        [self.textView becomeFirstResponder];
    }
    else {

        self.status = YXChatBoxStatusShowMoreKeyboard;

        [self.moreButton setBackgroundImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];

        [self.textView resignFirstResponder];
    }

    if ([self.delegate respondsToSelector:@selector(yx_chatBox:fromStatus:toStatus:)]) {
        [self.delegate yx_chatBox:self fromStatus:lastStatus toStatus:self.status];
    }
}

- (void)onSwitchButtonTouchUpInside:(UIButton *)sender
{
    YXChatBoxStatus lastStatus = self.status;

    if (lastStatus == YXChatBoxStatusVoice) {

        self.recordButton.hidden = YES;

        self.status = YXChatBoxStatusShowKeyboard;

        [self.textView becomeFirstResponder];

        self.isImportant = YES;
        self.textView.layer.borderColor = [UIColor redColor].CGColor;

        self.textView.text = self.textViewText;
        [self relayoutTextView];
    }
    else if (self.isImportant) { // 重 -> 初

        self.recordButton.hidden = YES;

        self.status = YXChatBoxStatusShowKeyboard;

        [self.textView becomeFirstResponder];

        self.isImportant = NO;
        self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;

        self.textView.text = self.textViewText;
        [self relayoutTextView];
    }
    else { // 初 -> 语

        self.textView.text = @" ";
        [self relayoutTextView];

        [self resetEmojiButton];
        [self resetMoreButton];
        self.recordButton.hidden = NO;

        self.status = YXChatBoxStatusVoice;

        [self.textView resignFirstResponder];
    }

    if ([self.delegate respondsToSelector:@selector(yx_chatBox:fromStatus:toStatus:)]) {
        [self.delegate yx_chatBox:self fromStatus:lastStatus toStatus:self.status];
    }
}

#pragma mark - Private

- (void)resetRecordButton
{
    self.recordButton.hidden = YES;
}

- (void)resetEmojiButton
{
    [self.emojiButton setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
}

- (void)resetMoreButton
{
    [self.moreButton setBackgroundImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
}

- (void)relayoutTextView
{
    CGFloat height = MIN([self.textView sizeThatFits:self.textView.frame.size].height, 15.0f * 5); // 最多显示5行
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ceilf(height));
        //        make.height.mas_equalTo(height);
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
        _textView.font = [UIFont systemFontOfSize:16];
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
        [_emojiButton setBackgroundImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
        [_emojiButton addTarget:self action:@selector(onEmojiButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiButton;
}

- (UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setBackgroundImage:[UIImage imageNamed:@"TypeSelectorBtn_Black"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(onMoreButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UIButton *)switchButton
{
    if (!_switchButton) {
        _switchButton = [[UIButton alloc] init];
        [_switchButton setBackgroundImage:[UIImage imageNamed:@"IconBtnSwitch"] forState:UIControlStateNormal];
        [_switchButton addTarget:self action:@selector(onSwitchButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UIButton *)recordButton
{
    if (!_recordButton) {
        _recordButton = [[UIButton alloc] init];
        _recordButton.backgroundColor = [UIColor whiteColor];
        [_recordButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_recordButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        _recordButton.layer.cornerRadius = 1.5f;
        _recordButton.layer.borderWidth = 0.5f;
        _recordButton.layer.borderColor = [UIColor lightGrayColor].CGColor;

        _recordButton.hidden = YES;

        [_recordButton addTarget:self action:@selector(onRecordButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_recordButton addTarget:self action:@selector(onRecordButtonTouchDragInside:) forControlEvents:UIControlEventTouchDragInside];
        [_recordButton addTarget:self action:@selector(onRecordButtonTouchDragOutside:) forControlEvents:UIControlEventTouchDragOutside];
//        [_recordButton addTarget:self action:@selector(onRecordButtonTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
//        [_recordButton addTarget:self action:@selector(onRecordButtonTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [_recordButton addTarget:self action:@selector(onRecordButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_recordButton addTarget:self action:@selector(onRecordButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [_recordButton addTarget:self action:@selector(onRecordButtonTouchCancel:) forControlEvents:UIControlEventTouchCancel];
    }
    return _recordButton;
}

- (void)onRecordButtonTouchDown:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onRecordButtonTouchDragInside:(id)sender
{
    NSLog(@"手指上滑 取消发送 %@", NSStringFromSelector(_cmd));
}

- (void)onRecordButtonTouchDragOutside:(id)sender
{
    NSLog(@"松开手指 取消发送 %@", NSStringFromSelector(_cmd));
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
    NSLog(@"录音完成 发送语音 %@", NSStringFromSelector(_cmd));
}

- (void)onRecordButtonTouchUpOutside:(id)sender
{
    NSLog(@"录音取消 %@", NSStringFromSelector(_cmd));
}

- (void)onRecordButtonTouchCancel:(id)sender
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
