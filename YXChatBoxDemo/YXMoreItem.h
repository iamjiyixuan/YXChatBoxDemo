//
//  YXMoreItem.h
//  YXChatBoxDemo
//
//  Created by JI Yixuan on 16/1/30.
//  Copyright © 2016年 iamjiyixuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXMoreItem : NSObject

+ (instancetype)itemWithIconImageName:(NSString *)iconImageName title:(NSString *)title;

@property(nonatomic, copy) NSString *iconImageName;
@property(nonatomic, copy) NSString *title;

@end
