//
//  TFDataFrameItem.m
//  InterViewDemo
//
//  Created by yangxiaofei on 16/8/5.
//  Copyright (c) 2016年 yangxiaofei. All rights reserved.
//

#import "TFDataFrameItem.h"
#import "TFDataItem.h"
#import <objc/runtime.h>


@implementation TFDataFrameItem

- (void) encodeWithCoder:(NSCoder *)aCoder
{/*
  [aCoder encodeObject:self.name forKey:@"name"];
  [aCoder encodeObject:self.content forKey:@"content"];
  [aCoder encodeObject:self.images forKey:@"images"];
  */
    unsigned int count = 0;
    //取出该对象的左右属性，最后返回一个数组，属性存放在这个数组中
    Ivar *ivars = class_copyIvarList([TFDataFrameItem class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        //取出成员变量的名字
        const char *name = ivar_getName(ivar);
        
        //归档
        NSString *key = [NSString stringWithUTF8String:name];
        /*
         现在key的值其实是_key，所以归档的时候要获取到_key代表的value
         */
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    
    //释放内存
    free(ivars);
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        /*
         self.name = [aDecoder decodeObjectForKey:@"name"];
         self.content = [aDecoder decodeObjectForKey:@"content"];
         self.images = [aDecoder decodeObjectForKey:@"images"];
         */
        unsigned int count = 0;
        //取出该对象的左右属性，最后返回一个数组，属性存放在这个数组中
        Ivar *ivars = class_copyIvarList([TFDataFrameItem class], &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            //取出成员变量的名字
            const char *name = ivar_getName(ivar);
            
            //归档
            NSString *key = [NSString stringWithUTF8String:name];
            /*
             现在key的值其实是_key，所以归档的时候要获取到_key代表的value
             */
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        //释放内存
        free(ivars);
    }
    return self;
}

- (void) setItem:(TFDataItem *)item
{
    _item = item;
    
    //计算文字部分frame
    [self setUptextFrame];
    
    //设置图片frame
    if (item.images.count) {
        [self setUpImageFrame];
        _cellhieght = CGRectGetMaxY(_imageFrame);
    }else{
        _cellhieght = CGRectGetMaxY(_textFrame);
    }
}

- (void)setUptextFrame
{
    //昵称
    CGFloat NameX = MBStatusCellMargin;
    CGFloat NameY = NameX;
    CGSize NameSize;
    /*
     使用sizeWithFont时候要给UILabel设置一个字体大小，然后在sizeWithFont方法里面根据字体大小设置控件自适应大小才会有效，否则不设置UILabel的字体大小的话，方法是不起作用的
     */
    if (_item.name.length != 0) {
        NSString *str = _item.name;
        NameSize = [str sizeWithFont:MBNameFont];
    }
    //使用这种方式给结构体赋值的时候需要强转一下类型
    _nameFrame = (CGRect){{NameX,NameY},NameSize};
    
    CGFloat textX = NameX;
    CGFloat textY = CGRectGetMaxY(_nameFrame) + MBStatusCellMargin;
    
    CGFloat textW = WIDTH - 2 * MBStatusCellMargin;
    CGSize textSize = [_item.content sizeWithFont:MBTextFont constrainedToSize:CGSizeMake(textW, MAXFLOAT)];
    _contentFrame = (CGRect){{textX,textY},textSize};
    
    //文字view的高度
    CGFloat textViewH = CGRectGetMaxY(_contentFrame)+MBStatusCellMargin;
    CGFloat textViewX = 0;
    CGFloat textViewY = 10;
    CGFloat textViewW = WIDTH;
    _textFrame = CGRectMake(textViewX, textViewY, textViewW, textViewH);
}

- (void)setUpImageFrame
{
    CGFloat photoViewX = 10;
    CGFloat photoViewY = 10;
    CGSize photoSize = [self sizeOfPhoto:_item.images];
    _photoFrame = (CGRect){{photoViewX,photoViewY},photoSize};
    
    CGFloat imageViewX = 0;
    CGFloat imageViewY = CGRectGetMaxY(_textFrame);
    CGFloat imageViewW = WIDTH;
    CGFloat imageViewH = CGRectGetMaxY(_photoFrame);
    _imageFrame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
}

- (CGSize)sizeOfPhoto:(NSArray *) array
{
    int cols = array.count == 4?2:3;
    int rols = (int)(array.count - 1) / cols + 1;
    
    //frame
    CGFloat photoWH = 70;
    
    CGFloat photoViewW = rols * photoWH + (cols - 1) * MBStatusCellMargin;
    CGFloat photoViewH = rols * photoWH + (rols - 1) * MBStatusCellMargin;
    return CGSizeMake(photoViewW, photoViewH);
}

@end
