//
//  MZLoginViewController.m
//  meilizhizao
//
//  Created by Adil Soomro on 4/14/14.
//  Copyright (c) 2014 Adil Soomro. All rights reserved.
//

#import "MZLoginViewController.h"
#import "MSMenuViewController.h"
#import "SCTextField.h"
#import "SCSaveTool.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "SSKeychain.h"
#import <LocalAuthentication/LocalAuthentication.h>

// 登录成功返回的参数
#define kLoginSucceed 3
#define kLoginUserName @"username"
#define kLoginPassword @"password"

@interface MZLoginViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, assign, getter=isTouchIDLogin) BOOL touchIDLogin;
@property (nonatomic, weak) MBProgressHUD *HUD;
@end

@implementation MZLoginViewController

- (id)init {
    self = [super initWithNibName:@"MZLoginViewController" bundle:nil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellArray = [NSMutableArray arrayWithObjects: _usernameCell, _passwordCell, _doneCell, nil];
    
    [_usernameField setupTextFieldWithIconName:@"user_name_icon"];
    [_passwordField setupTextFieldWithIconName:@"password_icon"];

    if ([[NSBundle mainBundle].infoDictionary[@"CFBundleVersion"] isEqualToString:[SCSaveTool objectForKey:@"version"]]) { // 没有新版本
        [self chooseLoginType];
    }
}

- (void)chooseLoginType {
    if ([SCSaveTool objectForKey:@"username"]) {
        self.usernameField.text = [SCSaveTool objectForKey:@"username"];
        if ([SCSaveTool objectForKey:@"openTouchID"]) {
            [self checkTouchID];
        } else {
            [self.passwordField becomeFirstResponder];
        }
    } else {
        [self.usernameField becomeFirstResponder];
    }
}

#pragma mark - 指纹验证
- (void)checkTouchID {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
     context.localizedFallbackTitle = @"";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"验证失败" message:@"" delegate:self cancelButtonTitle:@"输入密码" otherButtonTitles:@"再次验证", nil];
    alert.delegate = self;
    
    // 判断是否能验证指纹
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        // 判断验证指纹的结果
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"指纹验证登录", nil) reply:^(BOOL success, NSError *error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MSMenuViewController *mainVc = [[MSMenuViewController alloc] init];
                    [UIApplication sharedApplication].keyWindow.rootViewController = mainVc;
                });
            } else {
                switch (error.code) {
                        
                    case LAErrorAuthenticationFailed: {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            alert.message = @"验证失败,擦擦你手指上的汗?";
                            [alert show];
                        });
                    }
                        break;
                        
                    case LAErrorSystemCancel: {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            alert.message = @"验证超时,请再次验证";
                            [alert show];
                        });
                    }
                        break;
                        
                    case LAErrorUserCancel: {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.passwordField becomeFirstResponder];
                        });
                    }
                        break;

                    default:
                        break;
                }
            }
        }];
    } else {
        switch (error.code) {
            case LAErrorPasscodeNotSet: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loginFailed:@"您的设备没有登记指纹"]; // 登记指纹一定要设置密码, 所以当没有设置密码时, 无法进行指纹验证
                });
            }
                break;
                
            case LAErrorTouchIDNotEnrolled: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loginFailed:@"您的设备没有登记指纹"]; // 没有登记指纹时, 无法进行指纹验证
                });
            }
                break;
                
            case LAErrorTouchIDNotAvailable: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loginFailed:@"您的设备不支持指纹识别"]; // 设备不支持指纹时, 无法进行指纹验证
                });
            }
                break;
            default:
                break;
        }

        [self.passwordField becomeFirstResponder];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self.passwordField becomeFirstResponder];
            break;
        case 1:
            [self checkTouchID];
            break;
        default:
            break;
    }
}

#pragma mark - tableview deleagate datasource stuff
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((UITableViewCell*)[self.cellArray objectAtIndex:indexPath.row]).frame.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [self.cellArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)changeFieldBackground:(UISegmentedControl *)segment {
    if ([segment selectedSegmentIndex] == 0) {
        self.touchIDLogin = NO;
    } else {
        self.touchIDLogin = YES;
    }
}

- (IBAction)letMeIn:(id)sender {
    // 用户名密码都不为空
    if (self.usernameField.text.length && self.passwordField.text.length) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        [HUD show:YES];
        [self login];
        [self resignAllResponders];
        self.HUD = HUD;
    } else {
        return;
    }
}

- (void)login {
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"email"] = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]; // 忽略帐号尾部的空格
    params[@"password"] = self.passwordField.text;
    
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    [mgr POST:@"http://shop-mobapi.bizfe.meilishuo.com/user/log_on_mob" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.HUD hide:YES];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSNumber *loginState = dict[@"code"];
        // 验证通过
        if ([loginState isEqualToNumber:@(0)]) {

            [SCSaveTool setObject:self.usernameField.text forKey:kLoginUserName];
            [SSKeychain setPassword:self.passwordField.text forService:kLoginPassword account:self.usernameField.text];

            
            if (self.isTouchIDLogin) { // 开启指纹登录
                BOOL openTouchID = YES;
                [SCSaveTool setObject:@(openTouchID) forKey:@"openTouchID"];
                [self checkTouchID];
            } else { // 自动登录
                [SCSaveTool removeObjectForKey:@"openTouchID"];
                MSMenuViewController *mainVc = [[MSMenuViewController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = mainVc;
            }
        } else {
            [self loginFailed:@"用户名或密码不正确"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.HUD hide:YES];
        [self loginFailed:@"亲，您的手机网路不太顺畅喔~"];
    }];
}

- (void)loginFailed:(NSString *)labelText {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = labelText;
    [HUD showWhileExecuting:@selector(delay) onTarget:self withObject:nil animated:YES];
}

- (void)delay {
    sleep(1);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.passwordField becomeFirstResponder];
    });
}

- (void)resignAllResponders{
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

@end
