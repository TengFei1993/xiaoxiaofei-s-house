//
//  TFTableViewCell.m
//  InterViewDemo
//
//  Created by yangxiaofei on 16/8/5.
//  Copyright (c) 2016年 yangxiaofei. All rights reserved.
//

#import "TFTableViewCell.h"
#import "TFTextView.h"
#import "TFDataFrameItem.h"
#import "TFDataItem.h"
#import "TFImageView.h"


@interface TFTableViewCell ()

@property (nonatomic,weak) TFTextView *textView;

@property (nonatomic,weak) TFImageView *imageview;

@end

@implementation TFTableViewCell

//cell的所有初始化方法最后都要调用initWithStyle方法，就像其它控件最后都要调用initWithFrame方法一样
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //添加所有的子控件
        [self addchildrenViews];
    }
    return self;
}

+ (instancetype) cellWithTableview:(UITableView *)tableview
{
    static NSString *ID = @"cell";
    TFTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (void)addchildrenViews
{
    //文字部分
    TFTextView *textView = [[TFTextView alloc] init];
    textView.backgroundColor = [UIColor whiteColor];
    _textView = textView;
    [self.contentView addSubview:textView];
    
    //图片部分
    TFImageView *imageview = [[TFImageView alloc] init];
    imageview.backgroundColor = [UIColor whiteColor];
     _imageview = imageview;
    [self.contentView addSubview:imageview];
}

//重写模型的setter方法，完成赋值
- (void) setDataframeItem:(TFDataFrameItem *)dataframeItem
{
    _dataframeItem = dataframeItem;
    //计算frame
    //给它de子控件的myframe模型赋值，为的是获得模型数据，后来好赋值
    _textView.myframe = dataframeItem;
    _textView.frame = dataframeItem.textFrame;
    
    _imageview.frame = dataframeItem.imageFrame;
    _imageview.myframe = dataframeItem;
}


@end
