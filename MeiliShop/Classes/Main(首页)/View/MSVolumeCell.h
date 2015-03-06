//
//  MSVolumeCell.h
//  Shop
//
//  Created by 2014-763 on 15/2/3.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSBasicCell.h"

@interface MSVolumeCell : MSBasicCell
/**标题*/
@property (weak, nonatomic) IBOutlet UIView *titleLabel;
/**金额*/
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@end
