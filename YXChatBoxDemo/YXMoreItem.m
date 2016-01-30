//
//  YXMoreItem.m
//  YXChatBoxDemo
//
//  Created by JI Yixuan on 16/1/30.
//  Copyright © 2016年 iamjiyixuan. All rights reserved.
//

#import "YXMoreItem.h"

@implementation YXMoreItem

+ (instancetype)itemWithIconImageName:(NSString *)iconImageName title:(NSString *)title;
{
    YXMoreItem *item = [YXMoreItem new];
    item.iconImageName = iconImageName;
    item.title = title;
    return item;
}

@end
