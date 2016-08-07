//
//  MBPhotosView.m
//  高仿微博
//
//  Created by yangxiaofei on 16/3/20.
//  Copyright (c) 2016年 yangxiaofei. All rights reserved.
//

#import "TFPhotosView.h"

#import "UIImageView+WebCache.h"
#import "TFPhoto.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "TFDataStoreTool.h"

#define MBStatusCellMargin 10
//#import "MBGifimageView.h"

@interface TFPhotosView ()

@property (nonatomic,strong) NSMutableArray *photos;

@end

@implementation TFPhotosView

- (NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

//重写initWithframe方法，自定义控件
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //得添加9个imageview，用的话就不隐藏，不用的话就设置隐藏
        //控件隐藏就是移除，所以就不用计算尺寸什么的了
        [self addAllchildrens];
    }
    return self;
}

//添加所有的子控件
- (void)addAllchildrens
{
    for (int i = 0; i < 9; i++) {
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.userInteractionEnabled = YES;
        //增加tag值
        imageview.tag = i;
        
        //添加点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        [imageview addGestureRecognizer:tap];
        
        [self.photos addObject:imageview];
        [self addSubview:imageview];
    }
}

#pragma mark - 点击手势的方法
- (void) tap:(UITapGestureRecognizer *)tapgesture
{
    NSLog(@"%s",__func__);
    //获取到点击手势的view
    UIImageView *imageview = (UIImageView *)tapgesture.view;
    
    //把 MBPhoto 转成 MJPhoto
    //
    int i =  0;
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *url in _pic_urls) {
        
        MJPhoto *mjphoto = [[MJPhoto alloc] init];
        NSString *filePath = [Path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", url]];
        NSString *urlStr = filePath;
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        mjphoto.url = [NSURL URLWithString:urlStr];
        
        mjphoto.srcImageView = imageview;
        mjphoto.index = i;
        [array addObject:mjphoto];
        i++;
    }
    
    //弹出图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.photos = array;
    browser.currentPhotoIndex = imageview.tag;
    //显示
    [browser show];
    
}


//重写setter方法赋值
- (void) setPic_urls:(NSArray *)pic_urls{
    _pic_urls = pic_urls;
    
    int count = (int)self.photos.count;
    //遍历数组赋值
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = self.photos[i];
        //剩下的没有图片的设置隐藏
        if (i < pic_urls.count) { //显示  并且赋值，要不然不用显示赋值
            imageView.hidden = NO;
            
            //filePath，取图片的时候的路径名字
//            NSLog(@"11%@11",path);
            NSString *filePath = [Path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", pic_urls[i]]];
//            NSLog(@"----%@",filePath);
            
            imageView.image = [UIImage imageWithContentsOfFile:filePath];
        }else{
            imageView.hidden = YES;
        }
    }
}

//设置位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int count = (int)_pic_urls.count;
    
    //位置
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat wh = 70;
    
    for (int i = 0; i < count; i++) {
        //列数  ---   行数列数都是以0开始的
        int col = i % 3;
        //行数
        int rol = i / 3;
        
        
        x = col * (wh + MBStatusCellMargin);
        y = rol * (wh + MBStatusCellMargin);
        
        UIImageView *imageview = self.photos[i];
        
        imageview.frame = (CGRect){{x,y},{wh,wh}};
    }
}

@end
