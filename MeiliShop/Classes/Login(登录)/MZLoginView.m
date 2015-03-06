//
//  MZLoginView.m
//  meilizhizao
//
//  Created by 2014-763 on 15/1/16.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MZLoginView.h"
#import "Common.h"

@interface MZLoginView()
/**
 *  <登录>控件距离顶部的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *padding_top;
/**
 *  <登录>控件距离<输入框>控件的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *margin_label;
/**
 *  <输入框>控件距离<登录模式>控件的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *margin_button;
@end

@implementation MZLoginView

- (void)layoutSubviews {
    [super layoutSubviews];
    if (Iphone4) {
        self.padding_top.constant = 20;
        self.margin_label.constant = 10;
        self.margin_button.constant = 10;
    }
    if (Iphone6) {
        self.padding_top.constant = 100;
    }
    if (Iphone6p) {
        self.padding_top.constant = 150;
    }
}
@end
