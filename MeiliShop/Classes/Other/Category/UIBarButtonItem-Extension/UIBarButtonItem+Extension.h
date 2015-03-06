
/**
 *  UIBarButtonItem基础分类
 */

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/**
 *  通过一个按钮创建一个UIBarButtonItem, 大小自适应背景图大小
 *
 *  @param image            背景图片
 *  @param highlightedImage 高亮背景图片
 *  @param target           谁来监听按钮点击
 *  @param action           点击按钮会调用的方法
 */
+ (instancetype)itemWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action;

/**
 *  通过一个按钮创建一个UIBarButtonItem, 大小自适应背景图大小
 *
 *  @param image            背景图片
 *  @param target           谁来监听按钮点击
 *  @param action           点击按钮会调用的方法
 */
+ (instancetype)itemWithImage:(UIImage *)image target:(id)target action:(SEL)action;

@end
