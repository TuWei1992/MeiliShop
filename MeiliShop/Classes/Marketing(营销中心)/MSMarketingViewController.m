//
//  MSMarketingViewController.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/6.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSMarketingViewController.h"

@interface MSMarketingViewController ()

@end

@implementation MSMarketingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:btn];
    btn.center = self.view.center;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:tableView];
}

@end
