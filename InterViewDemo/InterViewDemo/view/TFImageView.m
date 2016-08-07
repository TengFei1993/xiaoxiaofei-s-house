//
//  TFImageView.m
//  InterViewDemo
//
//  Created by yangxiaofei on 16/8/5.
//  Copyright (c) 2016年 yangxiaofei. All rights reserved.
//

#import "TFImageView.h"
#import "TFPhotosView.h"
#import "TFDataFrameItem.h"
#import "TFDataItem.h"

@interface TFImageView ()

@property (nonatomic,weak) TFPhotosView *photoView;

@end

@implementation TFImageView

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
    TFPhotosView *photoView = [[TFPhotosView alloc] init];
    _photoView = photoView;
    [self addSubview:photoView];
}

- (void)setMyframe:(TFDataFrameItem *)myframe
{
    _myframe = myframe;
    
    //赋值
    TFDataItem *item = myframe.item;
    
    _photoView.pic_urls = item.images;
    
    _photoView.frame = myframe.photoFrame;
}

@end
