//
//  MSRefundListInfo.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/28.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSRefundListInfo.h"
#import "MSRefundInfo.h"

@implementation MSRefundListInfo

+ (NSDictionary *)objectClassInArray {
    return @{@"info" : [MSRefundInfo class]};
}
@end
