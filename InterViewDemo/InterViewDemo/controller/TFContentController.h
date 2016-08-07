//
//  TFContentController.h
//  InterViewDemo
//
//  Created by yangxiaofei on 16/8/4.
//  Copyright (c) 2016年 yangxiaofei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFContentController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *contentView;

@property (nonatomic,copy) NSString *context;

@end
