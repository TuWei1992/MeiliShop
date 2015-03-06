//
//  MSOrderListInfoDescCell.h
//  MeiliShop
//
//  Created by 2014-763 on 15/2/12.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSInfo, MSRefundInfo;

@interface MSOrderListInfoDescCell : UITableViewCell
@property (nonatomic, strong) MSInfo *info;
@property (nonatomic, strong) MSRefundInfo *refundInfo;
@end
