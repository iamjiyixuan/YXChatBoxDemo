//
//  YXMoreView.m
//  YXChatBoxDemo
//
//  Created by JI Yixuan on 16/1/29.
//  Copyright © 2016年 iamjiyixuan. All rights reserved.
//

#import "YXMoreItemCell.h"
#import "YXMoreView.h"

// 3rd
#import <Masonry/Masonry.h>
#import <HexColors/HexColors.h>

@interface YXMoreView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) NSArray<YXMoreItem *> *itmes;

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
    self.backgroundColor = [UIColor hx_colorWithHexString:@"#f4f6f3"];
    
    [self addSubview:self.collectionView];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f));
        make.edges.mas_equalTo(self).with.insets(UIEdgeInsetsZero);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itmes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = NSStringFromClass([YXMoreItemCell class]);
    YXMoreItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.item = [self.itmes objectAtIndex:indexPath.row];
    
//    cell.layer.borderWidth = 1;
//    cell.layer.borderColor = [UIColor blueColor].CGColor;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = ([UIScreen mainScreen].bounds.size.width) / 3;

    return CGSizeMake(w, self.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (NSArray<YXMoreItem *> *)itmes
{
    if (!_itmes) {
        _itmes = @[ [YXMoreItem itemWithIconImageName:@"IconAlbum" title:@"照片"],
                    [YXMoreItem itemWithIconImageName:@"IconPhoto" title:@"拍照"],
                    [YXMoreItem itemWithIconImageName:@"IconLocation" title:@"位置"] ];
    }
    return _itmes;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
//        _collectionView.layer.borderColor = [UIColor redColor].CGColor;
//        _collectionView.layer.borderWidth = 2;
        [_collectionView registerClass:[YXMoreItemCell class] forCellWithReuseIdentifier:NSStringFromClass([YXMoreItemCell class])];
    }
    return _collectionView;
}

@end
