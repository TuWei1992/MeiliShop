//
//  MSRefundOrderListInfoTipCell.m
//  MeiliShop
//
//  Created by 2014-763 on 15/3/2.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSOrderListInfoTipCell.h"

@interface MSOrderListInfoTipCell()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@end

@implementation MSOrderListInfoTipCell

- (void)awakeFromNib {
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = kLineColor;
    [self.contentView addSubview:line1];
    line1.translatesAutoresizingMaskIntoConstraints = NO;
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(0);
        make.left.equalTo(self.contentView).with.offset(8);
        make.right.equalTo(self.contentView).with.offset(-8);
        make.height.equalTo(@(0.5));
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = kLineColor;
    [self.contentView addSubview:line2];
    line2.translatesAutoresizingMaskIntoConstraints = NO;
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(self.contentView).with.offset(0);
        make.height.equalTo(@(0.5));
    }];
}

- (void)setRefund_status:(NSString *)refund_status {
    if (_refund_status != refund_status) {
        _refund_status = refund_status;
        self.tipLabel.text = refund_status;
    }
}
@end
