//
//  MSGoods.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/25.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSGoods.h"
#import "MSProp.h"

@implementation MSGoods

+ (NSDictionary *)objectClassInArray {
    return @{@"prop" : [MSProp class]};
}

@end
