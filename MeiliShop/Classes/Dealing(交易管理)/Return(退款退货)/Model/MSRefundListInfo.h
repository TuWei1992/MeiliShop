//
//  MSRefundListInfo.h
//  MeiliShop
//
//  Created by 2014-763 on 15/2/28.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSRefundListInfo : NSObject
/**
 *  退款退货列表
 */
@property (nonatomic, strong) NSArray *info;
/**
 *  退款退货总数
 */
@property (nonatomic, assign) NSInteger total_num;
@end
