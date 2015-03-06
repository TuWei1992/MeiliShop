

#define SCUserDefaults [NSUserDefaults standardUserDefaults] // Preferences目录
#define SCDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] // Document目录
#define SCLibraryPath [NSSearchPathForDirectoriseInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] // Library目录
#define SCCachePath [NSSearchPathForDirectoriseInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] // Cache目录
#define SCHomePath NSHomeDirectory() // 程序根目录
#define SCTempPath NSTemporaryDirectory() // 程序临时目录

#import "SCSaveTool.h"

@implementation SCSaveTool

+ (id)objectForKey:(NSString *)defaultName {
    return [SCUserDefaults objectForKey:defaultName];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName {
    [SCUserDefaults setObject:value forKey:defaultName];
    // 同步
    [SCUserDefaults synchronize];
}

+ (void)removeObjectForKey:(NSString *)defaultName {
    [SCUserDefaults removeObjectForKey:defaultName];
}

+ (void)saveImage:(id)image imageName:(NSString *)imageName imageExtension:(SCImageExtension)imageExtension {
    NSString *imagePath = [SCDocumentPath stringByAppendingPathComponent:imageName];
    switch (imageExtension) {
        case SCImageExtensionJPEG:
            [UIImageJPEGRepresentation(image, 1.0) writeToFile:[imagePath stringByAppendingPathExtension:@"jpg"] atomically:YES];
            break;
        case SCImageExtensionPNG:
            [UIImagePNGRepresentation(image) writeToFile:[imagePath stringByAppendingPathExtension:@"png"] atomically:YES];
            break;
        default:
            break;
    }
}

+ (UIImage *)image:(NSString *)imageName {
    return [UIImage imageNamed:[SCDocumentPath stringByAppendingPathComponent:imageName]];
}

+ (void)remove:(NSString *)imageName imageExtension:(SCImageExtension)imageExtension {
    NSString *imagePath = [SCDocumentPath stringByAppendingPathComponent:imageName];
    switch (imageExtension) {
        case SCImageExtensionJPEG:
            [[NSFileManager defaultManager] removeItemAtPath:[imagePath stringByAppendingPathExtension:@"jpg"] error:nil];
            break;
        case SCImageExtensionPNG:
            [[NSFileManager defaultManager] removeItemAtPath:[imagePath stringByAppendingPathExtension:@"png"] error:nil];
            break;
        default:
            break;
    }
}

@end
