
/**
 *  UIImage基础分类
 */

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  返回裁剪成圆形的后的图片
 *  @param  imageName  图片名字
 **/

+ (instancetype)circleImageWithName:(NSString *)imageName;

/**
 *  返回裁剪成圆形后的图片（带边框）
 *  @param  imageName  图片名字
 *  @param  borderWidth  边框宽度
 *  @param  borderColor  边框颜色
 **/
+ (instancetype)circleImageWithName:(NSString *)imageName
                        borderWidth:(CGFloat)borderWidth
                        borderColor:(UIColor *)borderColor;

/**
 *  返回裁剪成圆形的后的图片
 *
 *  @param  image  图片
 */
+ (instancetype)circleImageWithImage:(UIImage *)image;

/**
 *  返回裁剪成圆形后的图片（带边框）
 *  @param  image  图片
 *  @param  borderWidth  边框宽度
 *  @param  borderColor  边框颜色
 **/
+ (instancetype)circleImageWithImage:(UIImage *)image
                        borderWidth:(CGFloat)borderWidth
                        borderColor:(UIColor *)borderColor;

/**
 *  返回始终保持图片原始状态的图片
 *
 *  @param imageName 图片名
 *
 *  @return 不会被渲染的图片
 */
+ (UIImage *)imageOriginalName:(NSString *)imageName;


/**
 *  返回以中心的像素点拉伸后的图片
 *
 *  @param imageName 图片名
 *
 *  @return 拉伸后的图片
 */
+ (UIImage *)imageResizableWithName:(NSString *)imageName;


/**
 *  截屏
 *
 *  @param view 需要截屏的视图
 *
 */
+ (instancetype)imageWithCaptureView:(UIView *)view;

/**
 *  改变图片尺寸
 *
 *  @param image 原始图片
 *  @param size  需要改变的图片尺寸
 *
 *  @return 改变尺寸后的图片
 */
+ (UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size;



@end
