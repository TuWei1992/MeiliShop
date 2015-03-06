
#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (instancetype)circleImageWithName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [self circleImageWithImage:image];
}


+ (instancetype)circleImageWithName:(NSString *)imageName
                        borderWidth:(CGFloat)borderWidth
                        borderColor:(UIColor *)borderColor {
    UIImage *image = [UIImage imageNamed:imageName];
    return [self circleImageWithImage:image borderWidth:borderWidth borderColor:borderColor];
}

+ (instancetype)circleImageWithImage:(UIImage *)image {
    // 0.创建上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO , 0);
    // 1.获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, image.size.width, image.size.height));
    CGContextClip(ctx);
    CGContextStrokePath(ctx);
    // 2.裁剪图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    // 3.获取图片
    UIImage *newsImage = UIGraphicsGetImageFromCurrentImageContext();
    // 4.销毁上下文
    UIGraphicsEndImageContext();
    return newsImage;
}

+ (instancetype)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    CGFloat width = image.size.width + 2 * borderWidth;
    CGFloat height = image.size.width + 2 * borderWidth;
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 画外面的大圆，因为需要设置边框宽度，所以只能用addArc
    CGFloat circleX = width * 0.5;
    CGFloat circleY = height * 0.5;
    CGFloat radius = MIN(circleX, circleY);
    CGContextAddArc(ctx, circleX, circleY, radius, 0, M_PI * 2, 0);
    [borderColor set];
    // 渲染大圆
    CGContextFillPath(ctx);
    // 画小圆，来裁剪图片
    CGFloat sRadius = radius - borderWidth;
    CGContextAddArc(ctx, circleX, circleY, sRadius, 0, M_PI * 2, 0);
    CGContextClip(ctx);
    CGContextFillPath(ctx);
    // 画图片
    [image drawInRect:CGRectMake(circleX - sRadius, circleY - sRadius, width - borderWidth * 2, height - borderWidth * 2)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageOriginalName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)imageResizableWithName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}


+ (instancetype)imageWithCaptureView:(UIView *)view {
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 渲染控制器view的图层到上下文
    // 图层只能用渲染不能用draw
    [view.layer renderInContext:ctx];
    
    // 获取截屏图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}


+ (UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}


@end
