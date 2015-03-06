//
//  AppDelegate.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/5.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "AppDelegate.h"
#import "SCSaveTool.h"
#import "MZLoginViewController.h"
#import "MSMenuViewController.h"
#import "SCGuideController.h"
#import "SCSaveTool.h"
#import "SSKeychain.h"

#define kLoginPassword @"password"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    NSString *curVersion = dict[@"CFBundleVersion"];
    // 获取之前存储版本
    NSString *lastVersion = [SCSaveTool objectForKey:@"version"];
    
    if ([curVersion isEqualToString:lastVersion]) { // 没有新版本
        // 加载登录页控制器
        [self loadVc];
    } else { // 有新版本
        // 储存最新版本
        [SCSaveTool setObject:curVersion forKey:@"version"];
        // 加载引导页控制器
        [self loadGuideVc];
    }
    
    return YES;
}

- (void)loadGuideVc {
    [self loadVc];
    self.windowGuide = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 实引导页视图层级结构在状态栏之上
    self.windowGuide.windowLevel = UIWindowLevelStatusBar;
    SCGuideController *guideVc = [[SCGuideController alloc] initWithImageNames:[NSArray arrayWithObjects:@"guide01", @"guide02", @"guide03", @"guide04", nil]];
    self.windowGuide.rootViewController = guideVc;
    [self.windowGuide makeKeyAndVisible];
}

- (void)loadVc {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if ([SSKeychain passwordForService:kLoginPassword account:[SCSaveTool objectForKey:@"username"]]&&![SCSaveTool objectForKey:@"openTouchID"]) { // 自动登录并且没有开启指纹解锁时
        MSMenuViewController *mainVc = [[MSMenuViewController alloc] init];
        self.window.rootViewController = mainVc;
        
    } else { // 手动登录
        MZLoginViewController *loginVc = [[MZLoginViewController alloc] init];
        self.window.rootViewController = loginVc;
    }

    [self.window makeKeyAndVisible];
}

@end
