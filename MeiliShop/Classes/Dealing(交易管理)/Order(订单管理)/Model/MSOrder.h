//
//  MSOrder.h
//  MeiliShop
//
//  Created by 2014-763 on 15/2/25.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSOrder : NSObject
/**
 *  订单编号
 */
@property (nonatomic, assign) NSNumber *order_id;
/**
 *  订单总价
 */
@property (nonatomic, assign) CGFloat total_price;
/**
 *  订单类型
 */
@property (nonatomic, assign) int status;
@end
