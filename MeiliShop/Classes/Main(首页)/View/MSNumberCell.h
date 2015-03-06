//
//  MSNumberCell.h
//  Shop
//
//  Created by 2014-763 on 15/2/3.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSBasicCell.h"

@interface MSNumberCell : MSBasicCell
/**标题-左*/
@property (weak, nonatomic) IBOutlet UILabel *titleLabelLeft;
/**数量-左*/
@property (weak, nonatomic) IBOutlet UILabel *countLabelLeft;
/**标题-右*/
@property (weak, nonatomic) IBOutlet UILabel *titleLabelRight;
/**数量-右*/
@property (weak, nonatomic) IBOutlet UILabel *countLabelRight;
@end
