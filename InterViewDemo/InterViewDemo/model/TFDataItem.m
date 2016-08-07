//
//  TFDataItem.m
//  InterViewDemo
//
//  Created by yangxiaofei on 16/8/4.
//  Copyright (c) 2016年 yangxiaofei. All rights reserved.
//

#import "TFDataItem.h"
#import <objc/runtime.h>

@implementation TFDataItem

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    /*
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.images forKey:@"images"];
  */
    unsigned int count = 0;
    //取出该对象的左右属性，最后返回一个数组，属性存放在这个数组中
    Ivar *ivars = class_copyIvarList([TFDataItem class], &count);
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
        Ivar *ivars = class_copyIvarList([TFDataItem class], &count);
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

@end
