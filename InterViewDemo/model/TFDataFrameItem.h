//
//  TFDataFrameItem.h
//  InterViewDemo
//
//  Created by yangxiaofei on 16/8/5.
//  Copyright (c) 2016年 yangxiaofei. All rights reserved.
//
//这个类要存储所有的frame，从小到大。－－ 所有frame从小到大是依赖关系

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class TFDataItem;

@interface TFDataFrameItem : NSObject

/**模型属性*/
@property (nonatomic,strong) TFDataItem *item;

/**文字部分frame*/
@property (nonatomic,assign) CGRect textFrame;
/**名字frame*/
@property (nonatomic,assign) CGRect nameFrame;
/**内容frame*/
@property (nonatomic,assign) CGRect contentFrame;


/**图片部分frame*/
@property (nonatomic,assign) CGRect imageFrame;
/**图片部分里面包含的图片的frame*/
@property (nonatomic,assign) CGRect photoFrame;

/**
 行高
 */
@property (nonatomic,assign) CGFloat cellhieght;

@end
