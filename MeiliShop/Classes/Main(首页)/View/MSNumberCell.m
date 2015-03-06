//
//  MSNumberCell.m
//  Shop
//
//  Created by 2014-763 on 15/2/3.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSNumberCell.h"

@interface MSNumberCell()
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@end
@implementation MSNumberCell

- (void)awakeFromNib {
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(0.5));
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(0.5));
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
