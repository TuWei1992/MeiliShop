//
//  MSOrderListItemDetailCell.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/13.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSOrderListItemDetailCell.h"
#import "MSGoods.h"
#import "MSRefundGoods.h"
#import "MSProp.h"

#import "UIImageView+WebCache.h"

@interface MSOrderListItemDetailCell()
@property (weak, nonatomic) IBOutlet UIImageView *goods_img;
@property (weak, nonatomic) IBOutlet UILabel *goods_title;
@property (weak, nonatomic) IBOutlet UILabel *goods_no;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *amount;
/**
 *  颜色
 */
@property (weak, nonatomic) IBOutlet UILabel *value1;
/**
 *  尺码
 */
@property (weak, nonatomic) IBOutlet UILabel *value2;
@end

@implementation MSOrderListItemDetailCell

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

- (void)setGoods:(MSGoods *)goods {
    if (_goods != goods) {
        _goods = goods;
        [self.goods_img sd_setImageWithURL:[NSURL URLWithString:goods.b_pic_url] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        
        self.goods_title.text = goods.goods_title;
        
        if (goods.goods_no) {
            self.goods_no.text = [NSString stringWithFormat:@"货号:%zd",goods.goods_no];
        } else {
            self.goods_no.text = @"货号:";
        }
        
        CGFloat price = goods.price;
        self.price.text = [NSString stringWithFormat:@"单价:%.2f",price];
        self.amount.text = [NSString stringWithFormat:@"数量:%@",goods.amount];
        NSArray *props = goods.prop;
        MSProp *colorName = props[0];
        MSProp *sizeName = props[1];
        self.value1.text = [NSString stringWithFormat:@"颜色:%@",colorName.value];
        self.value2.text = [NSString stringWithFormat:@"尺码:%@",sizeName.value];
    }
}

- (void)setRefundGoods:(MSRefundGoods *)refundGoods {
    if (_refundGoods != refundGoods) {
        _refundGoods = refundGoods;
        [self.goods_img sd_setImageWithURL:[NSURL URLWithString:refundGoods.b_pic_url] placeholderImage:[UIImage imageNamed:@"avatar_default"]];
        
        self.goods_title.text = refundGoods.goods_title;
        
        CGFloat price = refundGoods.price;
        self.price.text = [NSString stringWithFormat:@"单价:%.2f",price];
        self.amount.text = [NSString stringWithFormat:@"数量:%@",refundGoods.amount];
        NSArray *props = refundGoods.prop;
        MSProp *colorName = props[0];
        MSProp *sizeName = props[1];
        self.value1.text = [NSString stringWithFormat:@"颜色:%@",colorName.value];
        self.value2.text = [NSString stringWithFormat:@"尺码:%@",sizeName.value];
    }
}

@end
