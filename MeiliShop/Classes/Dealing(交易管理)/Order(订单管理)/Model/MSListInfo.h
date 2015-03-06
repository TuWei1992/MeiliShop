//
//  MSListInfo.h
//  MeiliShop
//
//  Created by 2014-763 on 15/2/25.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSListInfo : NSObject
/**
 *  订单信息
 */
@property (nonatomic, strong) NSArray *info;
/**
 *  订单总数
 */
@property (nonatomic, assign) NSInteger total_num;
@end
