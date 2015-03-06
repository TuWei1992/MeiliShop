//
//  SWTabBarController.m
//  SimpleWeiBo
//
//  Created by Jason on 14/12/10.
//  Copyright (c) 2014年 Jason’s Application House. All rights reserved.
//

#import "MSGoodsTabBarController.h"
#import "MSNavigationController.h"

#import "MSOnOfferViewController.h"
#import "MSOnRepositoryViewController.h"

#import "MSGoodsTabBar.h"

@interface MSGoodsTabBarController ()

@end

@implementation MSGoodsTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加子控制器
    [self addOneChildVcClass:[MSOnOfferViewController class] title:@"出售中" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    [self addOneChildVcClass:[MSOnRepositoryViewController class] title:@"仓库中" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    [self setValue:[[MSGoodsTabBar alloc] init] forKeyPath:@"tabBar"];
}


/**
 * 添加一个子控制器
 * @param vc : 子控制器
 * @param title : 标题
 * @param image : 图片
 * @param selectedImage : 选中的图片
 */
- (void)addOneChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    [vc.tabBarItem setTitleTextAttributes:@{
                                            NSForegroundColorAttributeName : [UIColor orangeColor]
                                            } forState:UIControlStateSelected];
    
    // 控制tabbar每个标签的文字
    //    vc.tabBarItem.title = title;
    // 控制navigationBar的文字
    //    vc.navigationItem.title = title;
    // 同时设置tabbar每个标签的文字 和 navigationBar的文字
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    vc.view.backgroundColor = kRandomColor;
//    vc.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"top_navigation_more"] target:self action:nil];

    // 包装一个导航控制器后,再成为tabbar的子控制器
    MSNavigationController *nav = [[MSNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

/**
 * 添加一个子控制器
 * @param vcClass : 子控制器的类名
 * @param title : 标题
 * @param image : 图片
 * @param selectedImage : 选中的图片
 */
- (void)addOneChildVcClass:(Class)vcClass title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    UIViewController *vc = [[vcClass alloc] init];
    [self addOneChildVc:vc title:title image:image selectedImage:selectedImage];
}

@end
