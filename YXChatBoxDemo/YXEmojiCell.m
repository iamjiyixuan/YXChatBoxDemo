//
//  YXEmojiCell.m
//  YXChatBoxDemo
//
//  Created by JI Yixuan on 16/2/1.
//  Copyright © 2016年 iamjiyixuan. All rights reserved.
//

#import "YXEmojiCell.h"

// 3rd
#import <Masonry/Masonry.h>

@implementation YXEmojiCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.emojiButton];
        
        [self.emojiButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
    return self;
}

- (UIButton *)emojiButton
{
    if (!_emojiButton) {
        _emojiButton = [[UIButton alloc] init];
        [_emojiButton setImage:[UIImage imageNamed:@"emoji_1"] forState:UIControlStateNormal];
    }
    return _emojiButton;
}

@end
