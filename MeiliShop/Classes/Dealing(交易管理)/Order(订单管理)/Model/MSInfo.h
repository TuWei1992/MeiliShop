//
//  MSInfo.h
//  MeiliShop
//
//  Created by 2014-763 on 15/2/25.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MSAddress,MSOrder,MSUserInfo;

@interface MSInfo : NSObject
/**
 *  地址信息
 */
@property (nonatomic, strong) MSAddress *address;
/**
 *  商品信息
 */
@property (nonatomic, strong) NSArray *goods;
/**
 *  订单信息
 */
@property (nonatomic, strong) MSOrder *order;
/**
 *  用户信息
 */
@property (nonatomic, strong) MSUserInfo *user_info;
@end
