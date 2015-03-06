//
//  MSRefundInfo.h
//  MeiliShop
//
//  Created by 2014-763 on 15/2/28.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MSRefundAddress,MSBuyer,MSRefundGoods,MSRefundOrder;

@interface MSRefundInfo : NSObject
/**
 *  地址信息
 */
@property (nonatomic, strong) MSRefundAddress *address;
/**
 *  买家信息
 */
@property (nonatomic, strong) MSBuyer *buyer;
/**
 *  商品信息
 */
@property (nonatomic, strong) MSRefundGoods *goods;
/**
 *  订单信息
 */
@property (nonatomic, strong) MSRefundOrder *order;
@end
