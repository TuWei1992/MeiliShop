//
//  MSInfo.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/25.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSInfo.h"
#import "MSGoods.h"

@implementation MSInfo

+ (NSDictionary *)objectClassInArray {
    return @{@"goods" : [MSGoods class]};
}

@end
