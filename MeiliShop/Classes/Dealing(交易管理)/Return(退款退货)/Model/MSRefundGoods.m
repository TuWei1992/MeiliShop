//
//  MSRefundGoods.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/28.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSRefundGoods.h"
#import "MSRefundProp.h"

@implementation MSRefundGoods

+ (NSDictionary *)objectClassInArray {
    return @{@"prop" : [MSRefundProp class]};
}

@end
