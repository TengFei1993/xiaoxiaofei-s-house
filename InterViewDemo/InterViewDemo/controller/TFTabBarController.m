//
//  TFTabBarController.m
//  InterViewDemo
//
//  Created by yangxiaofei on 16/8/4.
//  Copyright (c) 2016年 yangxiaofei. All rights reserved.
//

#import "TFTabBarController.h"
#import "TFMessageController.h"
#import "TFDiscoverControlelr.h"

@interface TFTabBarController ()

/**
 信息控制器
 */
@property (nonatomic,strong) TFMessageController *messageVC;

/**
 发现控制器
 */
@property (nonatomic,strong) TFDiscoverControlelr *discvorVC;

@end

@implementation TFTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加子控制器
    [self setUpAllChildrenItems];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpAllChildrenItems
{
    //添加四个子item
    //tabbar控制器的子item是由四个子控制器控制的，所以需要新建四个新子控制器，然后设置
    TFMessageController *VC1 = [[TFMessageController alloc] init];
    VC1.view.backgroundColor = [UIColor redColor];
    _messageVC = VC1;
    [self setUpChildrenViewController:VC1 image:[UIImage imageNamed:@"tabbar_message_center"] seclectedImage:nil title:@"信息"];
    
    TFDiscoverControlelr *VC2 = [[TFDiscoverControlelr alloc] init];
    _discvorVC = VC2;
    VC2.view.backgroundColor = [UIColor yellowColor];
    //VC2.tabBarItem.badgeValue = @"10";
    [self setUpChildrenViewController:VC2 image:[UIImage imageNamed:@"tabbar_discover"] seclectedImage:nil title:@"发现"];
    
}

- (void)setUpChildrenViewController:(UIViewController *)VC image:(UIImage *)image seclectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    //VC.tabBarItem.title = title;
    VC.title = title;
    //VC.tabBarItem.badgeValue = @"10";
    VC.tabBarItem.image = image;
    VC.tabBarItem.selectedImage = selectedImage;
    
    //四个界面都设置成导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:VC];
//    [self.items addObject:VC.tabBarItem];
    [self addChildViewController:nav];
}


@end
