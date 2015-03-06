//
//  MSGoods.h
//  MeiliShop
//
//  Created by 2014-763 on 15/2/25.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSGoods : NSObject
/**
 *  商品小图
 */
@property (nonatomic, copy) NSString *b_pic_url;
/**
 *  商品大图
 */
@property (nonatomic, copy) NSString *goods_img;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *goods_title;
/**
 *  货号
 */
@property (nonatomic, assign) NSInteger goods_no;
/**
 *  单价
 */
@property (nonatomic, assign) CGFloat price;
/**
 *  数量
 */
@property (nonatomic, assign) NSNumber *amount;
/**
 *  颜色和尺码
 */
@property (nonatomic, strong) NSArray *prop;
@end
