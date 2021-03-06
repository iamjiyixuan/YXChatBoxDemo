//
//  YXChatBox.h
//  YXChatBoxDemo
//
//  Created by JI Yixuan on 16/1/28.
//  Copyright © 2016年 iamjiyixuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YXChatBoxStatus) {
    
    YXChatBoxStatusNone,
    YXChatBoxStatusShowKeyboard, // 显示系统键盘
    YXChatBoxStatusShowEmojiKeyboard, // 显示表情键盘
    YXChatBoxStatusShowMoreKeyboard, // 显示附件键盘
    YXChatBoxStatusVoice
    
//    TLChatBoxStatusNothing,
//    TLChatBoxStatusShowVoice,
//    TLChatBoxStatusShowFace,
//    TLChatBoxStatusShowMore,
//    TLChatBoxStatusShowKeyboard
};

@class YXChatBox;

@protocol YXChatBoxDelegate <NSObject>

@optional
- (void)yx_chatBox:(YXChatBox *)chatBox fromStatus:(YXChatBoxStatus)fromStatus toStatus:(YXChatBoxStatus)toStatus;

@end

@interface YXChatBox : UIView

@property(nonatomic, assign) YXChatBoxStatus status;
@property(nonatomic, weak) id<YXChatBoxDelegate> delegate;

@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UIButton *emojiButton;
@property(nonatomic, strong) UIButton *moreButton;
@property(nonatomic, strong) UIButton *switchButton;
@property(nonatomic, strong) UIButton *recordButton;

@end
