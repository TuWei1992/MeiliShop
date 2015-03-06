//
//  SWTabBar.m
//  SimpleWeiBo
//
//  Created by Jason on 14/12/10.
//  Copyright (c) 2014年 Jason’s Application House. All rights reserved.
//

#import "MSGoodsTabBar.h"

#define VCCOUNT 2 //控制器数量, 只能为双数

@interface MSGoodsTabBar()

@property (nonatomic, weak) UIButton *centerBtn;

@end
@implementation MSGoodsTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [centerBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [centerBtn setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    [centerBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [centerBtn setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    [centerBtn addTarget:self action:@selector(centerClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:centerBtn];
    self.centerBtn = centerBtn;
}

- (void)centerClick {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat btnW = self.width / (VCCOUNT + 1);
    CGFloat btnH = self.height;
    
    int btnIndex = 0;
    
    for (UIView *childV in self.subviews) {
        if ([childV isKindOfClass:[UIControl class]] && ![childV isKindOfClass:[UIButton class]]) {
            CGFloat btnX = btnW * btnIndex;
            childV.frame = CGRectMake(btnX, 0, btnW, btnH);
            btnIndex++;
            if (btnIndex == VCCOUNT/2) btnIndex++;
        }
    }
    
    self.centerBtn.size = self.centerBtn.currentBackgroundImage.size;
    self.centerBtn.center = [self.superview convertPoint:self.center toView:self];
}
@end
