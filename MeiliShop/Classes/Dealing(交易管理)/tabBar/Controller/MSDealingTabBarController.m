//
//  SWTabBarController.m
//  SimpleWeiBo
//
//  Created by Jason on 14/12/10.
//  Copyright (c) 2014年 Jason’s Application House. All rights reserved.
//

#import "MSDealingTabBarController.h"
#import "MSNavigationController.h"

#import "MSOrderViewController.h"
#import "MSReturnViewController.h"
#import "MSDeliveryViewController.h"
#import "MSValuationViewController.h"

#import "MSDealingTabBar.h"

@interface MSDealingTabBarController ()

@end

@implementation MSDealingTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加子控制器
    [self addOneChildVcClass:[MSOrderViewController class] title:@"订单管理" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    [self addOneChildVcClass:[MSReturnViewController class] title:@"退款退货" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    [self addOneChildVcClass:[MSDeliveryViewController class] title:@"发货管理" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    [self addOneChildVcClass:[MSValuationViewController class] title:@"评价管理" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];

    [self setValue:[[MSDealingTabBar alloc] init] forKeyPath:@"tabBar"];
    
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
