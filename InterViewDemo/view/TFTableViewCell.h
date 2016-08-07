//
//  TFTableViewCell.h
//  InterViewDemo
//
//  Created by yangxiaofei on 16/8/5.
//  Copyright (c) 2016年 yangxiaofei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TFDataFrameItem;

@interface TFTableViewCell : UITableViewCell

/*增加一个属性*/
@property (nonatomic,strong) TFDataFrameItem *dataframeItem;

/*写一个构造方法*/
+ (instancetype) cellWithTableview:(UITableView *)tableview;

@end
