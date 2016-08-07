//
//  TFDataStoreTool.h
//  InterViewDemo
//
//  Created by yangxiaofei on 16/8/4.
//  Copyright (c) 2016年 yangxiaofei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@class TFDataItem;

@interface TFDataStoreTool : NSObject
singleton_interface(TFDataStoreTool);

- (void) save:(TFDataItem *) object;

- (NSArray *)getdata;

@end
