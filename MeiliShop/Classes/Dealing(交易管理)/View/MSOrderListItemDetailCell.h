//
//  MSOrderListItemDetailCell.h
//  MeiliShop
//
//  Created by 2014-763 on 15/2/13.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSGoods, MSRefundGoods;

@interface MSOrderListItemDetailCell : UITableViewCell
@property (nonatomic, strong) MSGoods *goods;
@property (nonatomic, strong) MSRefundGoods *refundGoods;
@end
