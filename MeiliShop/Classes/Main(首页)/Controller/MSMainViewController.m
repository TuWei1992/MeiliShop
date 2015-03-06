//
//  MSMainViewController.m
//  Shop
//
//  Created by 2014-763 on 15/2/2.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSMainViewController.h"
#import "MSIconCell.h"
#import "MSVolumeCell.h"
#import "MSNumberCell.h"
#import "MSGraphCell.h"
#import "MJRefresh.h"
#import "SDWebImageManager.h"
#import "MSMineViewController.h"
#import "SCSaveTool.h"
#import "MZLoginViewController.h"
#import "SSKeychain.h"

#define kLoginPassword @"password"

@interface MSMainViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)iconButton;
@property (nonatomic, copy) NSString *iconNameURL;
@property (nonatomic, assign, getter=isCookiesExpires) BOOL cookiesExpires;
@property (nonatomic, strong) AFHTTPRequestOperationManager *mgr;
@end

@implementation MSMainViewController

static NSString *iconID = @"iconCell";
static NSString *volumeID = @"volumeCell";
static NSString *numberID = @"numberCell";
static NSString *graphID = @"graphCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpRefresh];
    
    [self setUpRightBarButtonItem];
    
    [self setData];
    
    [self setBackBarButtonItem];
    
}

- (void)setUpRefresh {
    __weak typeof(self) weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf.tableView headerEndRefreshing];
    }];
}

- (void)setUpRightBarButtonItem {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"title_ico_scan"] target:self action:nil];
}

- (void)setData {
    // 加载数据
    
}

- (void)setBackBarButtonItem {
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] init];
    backBarButton.title = @"返回";
    self.navigationItem.backBarButtonItem = backBarButton;
}


- (AFHTTPRequestOperationManager *)mgr {
    if (!_mgr) {
        _mgr = [AFHTTPRequestOperationManager manager];
        _mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
        _mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _mgr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isCookiesExpires) {
        return 0;
    } else {
        return 6;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MSIconCell *cell = [tableView dequeueReusableCellWithIdentifier:iconID forIndexPath:indexPath];
        
        // 将上一次的头像作为默认头像
        NSString *preIconNameURL = [SCSaveTool objectForKey:@"iconNameURL"];
        if (preIconNameURL) {
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:preIconNameURL] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [cell.iconButton setImage:[UIImage circleImageWithImage:image borderWidth:3 borderColor:[UIColor grayColor]] forState:UIControlStateNormal];
            }]; // 将需要缓存的图片加载进来
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"email"] = [SCSaveTool objectForKey:@"username"]; // 忽略帐号尾部的空格
        params[@"password"] = [SSKeychain passwordForService:kLoginPassword account:params[@"email"]];
        
        [self.mgr POST:@"http://shop-mobapi.bizfe.meilishuo.com/user/log_on_mob" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSNumber *loginState = dict[@"code"];
            // 验证通过
            if ([loginState isEqualToNumber:@(0)]) {
                // 拿到cookies
                [self.mgr GET:@"http://shop-mobapi.bizfe.meilishuo.com/user/session" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                    NSString *iconNameURL = dict[@"info"][@"avatar_e"];
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    [manager downloadImageWithURL:[NSURL URLWithString:iconNameURL] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        if (preIconNameURL != iconNameURL) {
                            [cell.iconButton setImage:[UIImage circleImageWithImage:image borderWidth:3 borderColor:[UIColor grayColor]] forState:UIControlStateNormal];
                            [SCSaveTool setObject:iconNameURL forKey:@"iconNameURL"];
                        }
                    }]; // 将需要缓存的图片加载进来
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    MSLog(@"%@",error);
                }];
            } else {
                MSLog(@"MSMainViewController--服务器验证密码失败");
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            kKeyWindow.rootViewController = [[MZLoginViewController alloc] init];
        }];
        
        return cell;
    } else if (indexPath.row == 1) {
        MSVolumeCell *cell = [tableView dequeueReusableCellWithIdentifier:volumeID forIndexPath:indexPath];
        return cell;
    } else if (indexPath.row >= 2 && indexPath.row <= 4) {
        MSNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:numberID forIndexPath:indexPath];
        switch (indexPath.row) {
            case 2:
                cell.titleLabelLeft.text = @"今日订单数";
                cell.titleLabelRight.text = @"今日已付款";
                cell.countLabelLeft.text = @"3";
                cell.countLabelRight.text = @"3";
                break;
            case 3:
                cell.titleLabelLeft.text = @"今日代发货";
                cell.titleLabelRight.text = @"昨日总流量";
                cell.countLabelLeft.text = @"20";
                cell.countLabelRight.text = @"6";
                break;
            case 4:
                cell.titleLabelLeft.text = @"昨日交易转换";
                cell.titleLabelRight.text = @"昨日交易总额";
                cell.countLabelLeft.text = @"0";
                cell.countLabelRight.text = @"200";
                break;
            default:
                break;
        }
        return cell;
    } else if (indexPath.row == 5) {
        MSGraphCell *cell = [tableView dequeueReusableCellWithIdentifier:graphID forIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 100;
            break;
        case 1:
            return 60;
            break;
        case 5:
            return 200;
            break;
        default:
            return 80;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return;
}

- (IBAction)iconButton {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MSMineViewController" bundle:nil];
    [self.navigationController pushViewController:sb.instantiateInitialViewController animated:YES];
}
@end
