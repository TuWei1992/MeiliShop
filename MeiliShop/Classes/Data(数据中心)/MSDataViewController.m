//
//  MSDataViewController.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/6.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSDataViewController.h"

@interface MSDataViewController ()

@end

@implementation MSDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:btn];
    btn.center = self.view.center;
}

@end
