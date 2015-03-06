//
//  MSCellInfoModel.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/13.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSCellInfoModel.h"

@implementation MSCellInfoModel

+ (instancetype)cellInfoWithNibName:(NSString *)nibName reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height {
    MSCellInfoModel *cellInfo = [[MSCellInfoModel alloc] init];
    cellInfo.nibName = nibName;
    cellInfo.reuseIdentifier = reuseIdentifier;
    cellInfo.height = height;
    return cellInfo;
}

@end
