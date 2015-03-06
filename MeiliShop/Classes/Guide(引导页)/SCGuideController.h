//
//  SCGuideController.h
//  collectionView引导页
//
//  Created by Jason on 14/11/22.
//  Copyright (c) 2014年 Jason’s Application House. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCGuideController : UICollectionViewController
/**
 *  初始化引导页控制器
 *
 *  @param imageNames 图片名数组
 */
- (instancetype)initWithImageNames:(NSArray *)imageNames;

@end

