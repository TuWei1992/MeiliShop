//
//  MSOrderListShowMoreCell.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/27.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSOrderListFooterCell.h"
#import "MSInfo.h"
#import "MSRefundInfo.h"
#import "MSGoods.h"
#import "MSRefundGoods.h"
#import "MSOrder.h"
#import "MSRefundOrder.h"
#import "MSUserInfo.h"

@interface MSOrderListFooterCell()
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;
@property (weak, nonatomic) IBOutlet UILabel *total_price;
@property (weak, nonatomic) IBOutlet UILabel *buyer_nickname;
@end

@implementation MSOrderListFooterCell

- (void)awakeFromNib {
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = kLineColor;
    [self.contentView addSubview:line];
    line.translatesAutoresizingMaskIntoConstraints = NO;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(0);
        make.left.equalTo(self.contentView).with.offset(8);
        make.right.equalTo(self.contentView).with.offset(-8);
        make.height.equalTo(@(0.5));
    }];
}

- (void)setInfo:(MSInfo *)info {
    if (_info != info) {
        _info = info;
        NSInteger totalAmount = 0;
        for (MSGoods *goods in info.goods) {
            totalAmount += [goods.amount integerValue];
        }
        self.totalAmount.text = [NSString stringWithFormat:@"共%zd件，合计",totalAmount];
        self.total_price.text = [NSString stringWithFormat:@"￥%.2f",info.order.total_price];
        self.buyer_nickname.text = [NSString stringWithFormat:@"%@",info.user_info.buyer_nickname];
    }
}

- (void)setRefundInfo:(MSRefundInfo *)refundInfo {
    if (_refundInfo != refundInfo) {
        _refundInfo = refundInfo;
        self.totalAmount.text = [NSString stringWithFormat:@"共%@件，合计",refundInfo.goods.amount];
        self.total_price.text = [NSString stringWithFormat:@"￥%.2f",refundInfo.order.total_price];
    }
}
@end
