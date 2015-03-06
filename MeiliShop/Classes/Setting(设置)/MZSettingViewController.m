//
//  MZSettingViewController.m
//  meilizhizao
//
//  Created by 2014-763 on 15/1/20.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MZSettingViewController.h"
#import "SCSaveTool.h"
#import "MZLoginViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "MBProgressHUD.h"
#import "SSKeychain.h"

#define kLoginPassword @"password"

@interface MZSettingViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *fingerprintUnlock;

- (IBAction)openFingerprintUnlock:(UISwitch *)sender;
@property (nonatomic, weak) MBProgressHUD *HUD;
@end

@implementation MZSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    if ([SCSaveTool objectForKey:@"supportedTouchID"]) { // 支持指纹
        self.fingerprintUnlock.enabled = YES;
        
        if (![SSKeychain passwordForService:kLoginPassword account:[SCSaveTool objectForKey:@"username"]]) {
            self.fingerprintUnlock.enabled = NO;
        } else {
            self.fingerprintUnlock.enabled = YES;
        }
        
        if ([SCSaveTool objectForKey:@"openTouchID"]) { // 开启了指纹
            self.fingerprintUnlock.on = YES;
        } else {
            self.fingerprintUnlock.on = NO;
        }

    } else { // 不支持指纹
        self.fingerprintUnlock.on = NO;
        self.fingerprintUnlock.enabled = NO;
    }
}


- (IBAction)openFingerprintUnlock:(UISwitch *)sender {
    if (sender.on == YES) { // 开启指纹解锁
        [SCSaveTool setObject:@(sender.isOn) forKey:@"openTouchID"];
    } else { // 关闭指纹解锁
        [SCSaveTool removeObjectForKey:@"openTouchID"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3 && indexPath.row == 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"退出后不会删除任何历史数据，下次登录依然可以使用本帐号。" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }
    // 选中后恢复cell状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.HUD hide:YES];
        [SSKeychain deletePasswordForService:kLoginPassword account:[SCSaveTool objectForKey:@"username"]];
        [SCSaveTool removeObjectForKey:@"openTouchID"];
        MZLoginViewController *loginVc = [[MZLoginViewController alloc] init];
        [UIApplication sharedApplication].keyWindow.rootViewController = loginVc;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"正在退出";
        [HUD show:YES];
        self.HUD = HUD;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
}

@end
