//
//  YXMoreItemCell.m
//  YXChatBoxDemo
//
//  Created by JI Yixuan on 16/1/30.
//  Copyright © 2016年 iamjiyixuan. All rights reserved.
//

#import "YXMoreItemCell.h"

#import <Masonry/Masonry.h>

@interface YXMoreItemCell ()

@property(nonatomic, strong) UIView *container;

@end

@implementation YXMoreItemCell

- (instancetype)init
{
    if (self = [super init]) {
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
    [self.container addSubview:self.iconImageView];
    [self.container addSubview:self.titleTextLabel];
    [self.contentView addSubview:self.container];
    
    // layout subviews
    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.contentView.mas_width);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.container.mas_top);
        make.centerX.mas_equalTo(self.container.mas_centerX);
    }];
    
    [self.titleTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.container.mas_centerX);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(10.0f);
        make.bottom.mas_equalTo(self.container.mas_bottom);
    }];
}

- (void)setItem:(YXMoreItem *)item
{
    _item = item;
    
    [self.iconImageView setBackgroundImage:[UIImage imageNamed:item.iconImageName] forState:UIControlStateNormal];
    self.titleTextLabel.text = item.title;
}

- (UIView *)container
{
    if (!_container) {
        _container = [[UIView alloc] init];
        
//        _container.layer.borderColor = [UIColor redColor].CGColor;
//        _container.layer.borderWidth = 1;
    }
    return _container;
}

- (UIButton *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIButton alloc] init];
        
//        _iconImageView.layer.borderColor = [UIColor redColor].CGColor;
//        _iconImageView.layer.borderWidth = 1;
    }
    return _iconImageView;
}

- (UILabel *)titleTextLabel
{
    if (!_titleTextLabel) {
        _titleTextLabel = [[UILabel alloc] init];
        _titleTextLabel.font = [UIFont systemFontOfSize:12];
    }
    return _titleTextLabel;
}

@end
