//
//  TFDataItem.h
//  InterViewDemo
//
//  Created by yangxiaofei on 16/8/4.
//  Copyright (c) 2016年 yangxiaofei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFDataItem : NSObject<NSCoding>

/*name*/
@property (nonatomic,copy) NSString *name;

/*内容*/
@property (nonatomic,copy) NSString *content;

/*图片*/
@property (nonatomic,strong) NSArray *images;

/**序号*/
@property (nonatomic,assign) int ID;

@end
