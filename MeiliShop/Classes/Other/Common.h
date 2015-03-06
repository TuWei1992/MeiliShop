
/**
 *  通用宏
 */

// 当前窗口
#define kKeyWindow ([UIApplication sharedApplication].keyWindow)

// 屏幕bounds
#define kScreenBounds [UIScreen mainScreen].bounds

// 屏幕size
#define kScreenSize [UIScreen mainScreen].bounds.size

// 屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

// 屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

// 状态栏高度
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

// 导航栏高度
#define kNavigationBarHeight self.navigationController.navigationBar.frame.size.height

// 是否为IOS8以上的系统
#define IOS8 ([UIDevice currentDevice].systemVersion.floatValue >= 8.0)

// 是否是iphone设备
#define Iphone ([UIApplication sharedApplication].keyWindow.bounds.size.width <= 414)
// 是否是iphone4设备
#define Iphone4 ([UIApplication sharedApplication].keyWindow.bounds.size.height == 480)
// 是否是iphone5设备
#define Iphone5 ([UIApplication sharedApplication].keyWindow.bounds.size.height == 568)
// 是否是iphone6设备
#define Iphone6 ([UIApplication sharedApplication].keyWindow.bounds.size.height == 667)
// 是否是iphone6p设备
#define Iphone6p ([UIApplication sharedApplication].keyWindow.bounds.size.height == 736)
// 是否是iphone6及以上的设备
#define Iphone6AndLater ([UIApplication sharedApplication].keyWindow.bounds.size.height >= 667)

// 创建随机数
#define kRandomNumber(n) arc4random_uniform(n)

// 创建rgb颜色
#define kColor(r,g,b) ([UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1])

// 创建随机颜色
#define kRandomColor [UIColor colorWithRed: arc4random_uniform(255) / 255.0f green:arc4random_uniform(255) / 255.0f blue:arc4random_uniform(255) / 255.0f alpha:1.0]

// 创建经典背景色
#define kBackGroundColor ([UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1])

// 创建分割线颜色
#define kLineColor ([UIColor colorWithRed:188/255.0 green:186/255.0 blue:193/255.0 alpha:1])

// 转角度为弧度
#define kAngle2Radian(angle) ((angle) / 180.0 * M_PI)

// 沙盒document路径
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

// 沙盒Preferences路径
#define kUserDefaults [NSUserDefaults standardUserDefaults]
