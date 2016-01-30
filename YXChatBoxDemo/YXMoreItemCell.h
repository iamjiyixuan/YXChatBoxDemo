//
//  YXMoreItemCell.h
//  YXChatBoxDemo
//
//  Created by JI Yixuan on 16/1/30.
//  Copyright © 2016年 iamjiyixuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXMoreItem.h"

@interface YXMoreItemCell : UICollectionViewCell

@property(nonatomic, strong) YXMoreItem *item;

@property(nonatomic, strong) UIButton *iconImageView;
@property(nonatomic, strong) UILabel *titleTextLabel;

@end
