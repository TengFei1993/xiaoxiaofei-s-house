//
//  TFTextView.m
//  InterViewDemo
//
//  Created by yangxiaofei on 16/8/5.
//  Copyright (c) 2016年 yangxiaofei. All rights reserved.
//

#import "TFTextView.h"
#import "TFDataItem.h"
#import "TFDataFrameItem.h"

@interface TFTextView ()

@property (nonatomic,weak) UILabel *nameLabel;

@property (nonatomic,weak) UILabel *contentLabel;

@end

@implementation TFTextView

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //添加子控件
        [self addchildrens];
    }
    return self;
}


- (void)addchildrens
{
    //name
    // 昵称
    UILabel *nameView = [[UILabel alloc] init];
    nameView.backgroundColor = [UIColor yellowColor];
    nameView.font = MBNameFont;
    [self addSubview:nameView];
    _nameLabel = nameView;
    //内容
    // 正文
    UILabel *textView = [[UILabel alloc] init];
    textView.backgroundColor = [UIColor blueColor];
    [self addSubview:textView];
    textView.font = MBTextFont;
    textView.numberOfLines = 0;
    _contentLabel = textView;
}

- (void) setMyframe:(TFDataFrameItem *)myframe
{
    _myframe = myframe;
    
    TFDataItem *item = myframe.item;
    //赋值
    _nameLabel.text = item.name;
    _contentLabel.text = item.content;
    
    //位置
    _nameLabel.frame = myframe.nameFrame;
    _contentLabel.frame = myframe.contentFrame;
}

@end
