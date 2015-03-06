//
//  MSOrderListOperateCell.h
//  MeiliShop
//
//  Created by 2014-763 on 15/2/13.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSInfo;

@interface MSOrderListOperateCell : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, strong) MSInfo *info;
@end
