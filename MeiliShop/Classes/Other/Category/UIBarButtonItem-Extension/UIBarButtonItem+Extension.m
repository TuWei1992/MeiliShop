
#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (instancetype)itemWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage target:(id)target action:(SEL)action {
    UIButton *button = [[UIButton alloc] init];
    if (image) [button setBackgroundImage:image forState:UIControlStateNormal];
    if (highlightedImage) [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    
    CGRect frame = button.frame;
    frame.size = button.currentBackgroundImage.size;
    button.frame = frame;
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)itemWithImage:(UIImage *)image target:(id)target action:(SEL)action {
    return [self itemWithImage:image highlightedImage:nil target:target action:(SEL)action];
}
@end
