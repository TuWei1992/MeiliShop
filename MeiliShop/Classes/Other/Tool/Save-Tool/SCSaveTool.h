
/**
 *  存储工具类
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SCImageExtension) {
    SCImageExtensionPNG,
    SCImageExtensionJPEG, // 压缩质量默认为1
};

@interface SCSaveTool : NSObject

/**
 *  存储数据 至 NSUserDefaults下
 *
 *  @param value       只能为NSData, NSString, NSNumber, NSDate, NSArray, 或者 NSDictionary. 如果是 NSArray 和 NSDictionary , 他们的成员必须非自定义对象
 *  @param defaultName 存储的对象对应的key
 */
+ (void)setObject:(id)value forKey:(NSString *)defaultName;

/**
 *  取出数据 从 NSUserDefaults下
 *
 *  @param defaultName 取出的对象对应的key
 *
 *  @return 取出的对象
 */
+ (id)objectForKey:(NSString *)defaultName;

/**
 *  删除数据 从 NSUserDefaults下
 *
 *  @param defaultName 删除的对象应对的key
 */
+ (void)removeObjectForKey:(NSString *)defaultName;

/**
 *  存储图像 至 沙盒document目录下
 *
 *  @param image          需要存储的图像
 *  @param imageName      指定图片名 (不要带后缀)
 *  @param imageExtension 指定扩展名类型
 */
+ (void)saveImage:(UIImage *)image imageName:(NSString *)imageName imageExtension:(SCImageExtension)imageExtension;

/**
 *  读取图片 从 沙盒document目录下
 *
 *  @param imageName 图片名
 *
 *  @return document 图片名对应的图像
 */
+ (UIImage *)image:(NSString *)imageName;

/**
 *  删除图片 从 沙盒document目录下
 *
 *  @param imageName      图片名
 *  @param imageExtension 指定扩展名类型
 */
+ (void)remove:(NSString *)imageName imageExtension:(SCImageExtension)imageExtension;

@end
