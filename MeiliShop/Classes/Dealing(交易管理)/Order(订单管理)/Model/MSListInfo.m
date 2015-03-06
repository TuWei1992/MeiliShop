//
//  MSListInfo.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/25.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSListInfo.h"
#import "MSInfo.h"

@implementation MSListInfo

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"info":[MSInfo class]
             };
}

@end
