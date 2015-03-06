//
//  MSOrderListInfoDescCell.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/12.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSOrderListInfoDescCell.h"
#import "MSInfo.h"
#import "MSRefundInfo.h"
#import "MSOrder.h"
#import "MSRefundOrder.h"

@interface MSOrderListInfoDescCell()
@property (weak, nonatomic) IBOutlet UIView *headerView;
/**
 *  订单编号
 */
@property (weak, nonatomic) IBOutlet UILabel *order_id;
@end

@implementation MSOrderListInfoDescCell

- (void)awakeFromNib {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLineColor;
    [self.contentView addSubview:line];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).with.offset(0);
        make.left.and.right.equalTo(self.contentView).with.offset(0);
        make.height.equalTo(@(0.5));
    }];
}

- (void)setInfo:(MSInfo *)info {
    if (_info != info) {
        _info = info;
        self.order_id.text = [NSString stringWithFormat:@"订单编号:%@",info.order.order_id];
    }
}

- (void)setRefundInfo:(MSRefundInfo *)refundInfo {
    if (_refundInfo != refundInfo) {
        _refundInfo = refundInfo;
        self.order_id.text = [NSString stringWithFormat:@"订单编号:%@",refundInfo.order.order_id];
    }
}

@end
