//
//  MSMenuViewController.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/5.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSMenuViewController.h"
#import "MSMainViewController.h"
#import "MSDealingTabBarController.h"
#import "MSGoodsTabBarController.h"
#import "MSMarketingViewController.h"
#import "MSDataViewController.h"
#import "MZSettingViewController.h"

#import "UIBarButtonItem+Extension.h"
#import "MSNavigationController.h"

#import <LocalAuthentication/LocalAuthentication.h>
#import "SCSaveTool.h"

@interface MSMenuViewController ()

@end

@implementation MSMenuViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置子控制器
    [self setUpVc];
    // 检查TouchID
    [self checkTouchID];
}

#pragma mark - 设置子控制器
- (void)setUpVc {
    
    [self addOneChildVc:[UIStoryboard storyboardWithName:@"MSMainViewController" bundle:nil].instantiateInitialViewController title:@"首页" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    [self addOneChildVc:[[MSDealingTabBarController alloc] init] title:@"交易管理" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    [self addOneChildVc:[[MSGoodsTabBarController alloc] init] title:@"商品管理" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    [self addOneChildVc:[[MSMarketingViewController alloc] init] title:@"营销中心" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    [self addOneChildVc:[[MSDataViewController alloc] init] title:@"数据中心" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    [self addOneChildVc:[UIStoryboard storyboardWithName:@"MZSettingViewController" bundle:nil].instantiateInitialViewController title:@"设置" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];

}

- (void)checkTouchID {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        LAContext *context = [[LAContext alloc] init];
        BOOL supportedTouchID = YES;
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 支持指纹
                [SCSaveTool setObject:@(supportedTouchID) forKey:@"supportedTouchID"];
            });
        } else { // 不支持指纹
            [SCSaveTool removeObjectForKey:@"supportedTouchID"];
        }
    });
}

- (void)addOneChildVc:(UIViewController *)vc title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    // 同时设置tabbar每个标签的文字 和 navigationBar的文字
    vc.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    if (![vc isKindOfClass:[UITabBarController class]]) {
        // 如果控制器不是tabBar控制器, 则包装一个navi控制器
        MSNavigationController *nav = [[MSNavigationController alloc] initWithRootViewController:vc];
        [self addChildViewController:nav];
    } else {
        // 如果是tabBar控制器, 直接添加
        [self addChildViewController:vc];
    }
}
@end
