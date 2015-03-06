//
//  SWTabBar.m
//  SimpleWeiBo
//
//  Created by Jason on 14/12/10.
//  Copyright (c) 2014年 Jason’s Application House. All rights reserved.
//

#import "MSDealingTabBar.h"

#define VCCOUNT 4 //控制器数量

@interface MSDealingTabBar()

@end
@implementation MSDealingTabBar

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
    
}

@end
