//
//  YXEmojiView.m
//  YXChatBoxDemo
//
//  Created by JI Yixuan on 16/1/30.
//  Copyright © 2016年 iamjiyixuan. All rights reserved.
//

#import "YXEmojiView.h"
#import "YXEmoji.h"
#import "YXEmojiPageView.h"

// 3rd
#import <Masonry/Masonry.h>
#import <HexColors/HexColors.h>

@interface YXEmojiView () <UIScrollViewDelegate>

@property(nonatomic, strong) NSArray *data;

@end

@implementation YXEmojiView

- (instancetype)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        [self commonInit];
//    }
//    return self;
//}

- (void)commonInit
{
    // add subviews
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    [self addSubview:self.sendButton];
    
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.width.mas_equalTo(self.mas_width);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.pageControl.mas_top);
    }];
    
    [self.pageControl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.width.mas_equalTo(self.mas_width);
        make.height.mas_equalTo(20.0f);
//        make.top.mas_equalTo(self.scrollView.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-75.0f / 2);
    }];
    
    [self.sendButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-5.0f);
        make.width.mas_equalTo(75.0f);
        make.height.mas_equalTo(39.0f);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5.0f);
    }];
    
    [self.scrollView layoutIfNeeded];
    [self.pageControl layoutIfNeeded];
    
    [self layoutIfNeeded];
    
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = 217.0f - 20.0f - 75.0f / 2;
    
    NSInteger pageCount = [self pageCount];
    NSInteger index = 0;
    for (; index < pageCount; index++) {
        YXEmojiPageView *v = [[YXEmojiPageView alloc] initWithFrame:CGRectMake(index * w, 0, w, h)];
        NSInteger len = 20;
        if (20 * index + 20 > self.data.count) {
            len = self.data.count - 20 * index;
        }
        
        v.data = [self.data subarrayWithRange:NSMakeRange(20 * index, len)];
        
        [self.scrollView addSubview:v];
    }
    
    [self.scrollView setContentSize:CGSizeMake(w * [self pageCount], h)];
}

- (NSInteger)pageCount
{
    return self.data.count % 20 == 0 ? self.data.count / 20 : self.data.count / 20 + 1;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    CGFloat w = self.scrollView.frame.size.width;
    CGFloat h = self.scrollView.frame.size.height;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.scrollView.frame.size.width;
    CGFloat h = self.scrollView.frame.size.height;
    
    CGRect f = self.frame;
    
    if (w) {
        
    }
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / self.frame.size.width;
//    if (page > _curPage && (page * WIDTH_SCREEN - scrollView.contentOffset.x) < WIDTH_SCREEN * 0.2) {       // 向右翻
//        [self showFaceFageAtIndex:page];
//    }
//    else if (page < _curPage && (scrollView.contentOffset.x - page * WIDTH_SCREEN) < WIDTH_SCREEN * 0.2) {
//        [self showFaceFageAtIndex:page];
//    }
    self.pageControl.currentPage = page;
}

- (UIScrollView *) scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setScrollsToTop:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setDelegate:self];
        [_scrollView setPagingEnabled:YES];
    }
    return _scrollView;
}

- (UIPageControl *) pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = [self pageCount];
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//        [_pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
        
//        _pageControl.layer.borderWidth = 1;
//        _pageControl.layer.borderColor = [UIColor orangeColor].CGColor;
    }
    return _pageControl;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [[UIButton alloc] init];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_sendButton setBackgroundColor:[UIColor hx_colorWithHexString:@"#4dad43"]];
        
        _sendButton.layer.cornerRadius = 1.5f;
        _sendButton.clipsToBounds = YES;
        //        _sendButton.tag = -2;
        //        [_sendButton addTarget:self action:@selector(buttonDown:) forControlEvents:UIControlEventTouchDown];
    }
    return _sendButton;
}

- (NSArray *)data
{
    if (!_data) {
        
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"normal_face" ofType:@"plist"]];
        NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:array.count];
        for (NSDictionary *dic in array) {
            YXEmoji *face = [[YXEmoji alloc] init];
            face.emojiID = [dic objectForKey:@"face_id"];
            face.emojiName = [dic objectForKey:@"face_name"];
            [data addObject:face];
        }
        _data = data;
    }
    return _data;
}

@end
