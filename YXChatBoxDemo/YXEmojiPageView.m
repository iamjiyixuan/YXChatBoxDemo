//
//  YXEmojiPageView.m
//  YXChatBoxDemo
//
//  Created by JI Yixuan on 16/2/1.
//  Copyright © 2016年 iamjiyixuan. All rights reserved.
//

#import "YXEmojiCell.h"
#import "YXEmoji.h"
#import "YXEmojiPageView.h"

#import <Masonry/Masonry.h>

@interface YXEmojiPageView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation YXEmojiPageView

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
    [self addSubview:self.collectionView];

    //
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 21;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YXEmoji *emoji = nil;
    if (indexPath.row < self.data.count) {
        emoji = [self.data objectAtIndex:indexPath.row];
    }
    
    NSString *identifier = NSStringFromClass([YXEmojiCell class]);
    YXEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (emoji.emojiName) {
        [cell.emojiButton setImage:[UIImage imageNamed:emoji.emojiName] forState:UIControlStateNormal];
    }
    else if (indexPath.row == 20) {
        [cell.emojiButton setImage:[UIImage imageNamed:@"DeleteEmoticonBtn"] forState:UIControlStateNormal];
    }
    else {
        [cell.emojiButton setImage:nil forState:UIControlStateNormal];
    }
//    cell.layer.borderWidth = 1;
//    cell.layer.borderColor = [UIColor darkGrayColor].CGColor;

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width / 7;
    CGFloat h = (217.0f - 20.0f - 75.0f / 2) / 3;

    return CGSizeMake(w, h);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)setData:(NSArray *)data
{
    _data = data;
    
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;

        _collectionView.backgroundColor = [UIColor clearColor];

        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [_collectionView registerClass:[YXEmojiCell class] forCellWithReuseIdentifier:NSStringFromClass([YXEmojiCell class])];
    }
    return _collectionView;
}

@end
