//
//  MSIssueViewController.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/6.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSIssueViewController.h"

@interface MSIssueViewController ()

@end

@implementation MSIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kRandomColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:btn];
    btn.center = self.view.center;
}

@end