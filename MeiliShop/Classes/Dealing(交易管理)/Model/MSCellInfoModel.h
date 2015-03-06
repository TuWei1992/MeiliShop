//
//  MSCellInfoModel.h
//  MeiliShop
//
//  Created by 2014-763 on 15/2/13.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSCellInfoModel : NSObject

@property (nonatomic, copy) NSString *nibName;

@property (nonatomic, copy) NSString *reuseIdentifier;

@property (nonatomic, assign) CGFloat height;

+ (instancetype)cellInfoWithNibName:(NSString *)nibName reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height;
@end
