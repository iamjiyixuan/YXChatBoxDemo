//
//  YXMoreView.m
//  YXChatBoxDemo
//
//  Created by JI Yixuan on 16/1/29.
//  Copyright © 2016年 iamjiyixuan. All rights reserved.
//

#import "YXMoreView.h"

// 3rd
#import <Masonry/Masonry.h>

@interface YXMoreView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation YXMoreView

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
    [self addSubview:self.collectionView];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f));
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = NSStringFromClass([UICollectionViewCell class]);
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat wh = ([UIScreen mainScreen].bounds.size.width - 10.0f * 5) / 3;
    
    return CGSizeMake(wh, wh);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.layer.borderColor = [UIColor redColor].CGColor;
        _collectionView.layer.borderWidth = 2;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
    return _collectionView;
}

@end
