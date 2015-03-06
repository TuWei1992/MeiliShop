//
//  UITextField+SCTextField.m
//  SCTextViewDemo
//
//  Created by Adil Soomro on 4/14/14.
//  Copyright (c) 2014 Adil Soomro. All rights reserved.
//

#import "SCTextField.h"
#define kLeftPadding 10
#define kVerticalPadding 12
#define kHorizontalPadding 10

@interface SCTextField (){
    SCTextFieldType _type;
}

@end

@implementation SCTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    UIEdgeInsets edge = [self edgeInsetsForType:_type];
    
    CGFloat x = bounds.origin.x + edge.left +kLeftPadding;
    CGFloat y = bounds.origin.y + kVerticalPadding;
    
    
    return CGRectMake(x,y,bounds.size.width - kHorizontalPadding*2, bounds.size.height - kVerticalPadding*2);
    
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (void)setupTextFieldWithIconName:(NSString *)name{
    [self setupTextFieldWithType:SCTextFieldTypeDefault withIconName:name];
}
- (void)setupTextFieldWithType:(SCTextFieldType)type withIconName:(NSString *)name{
    UIEdgeInsets edge = [self edgeInsetsForType:type];
    NSString *imageName = [self backgroundImageNameForType:type];
    CGRect imageViewFrame = [self iconImageViewRectForType:type];
    _type = type;
    
    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image resizableImageWithCapInsets:edge];
    
    [self setBackground:image];
    
    UIImage *icon = [UIImage imageNamed:name];
    
    //make an imageview to show an icon on the left side of textfield
    UIImageView * iconImage = [[UIImageView alloc] initWithFrame:imageViewFrame];
    [iconImage setImage:icon];
    [iconImage setContentMode:UIViewContentModeCenter];
    self.leftView = iconImage;
    self.leftViewMode = UITextFieldViewModeAlways;

    [self setNeedsDisplay]; //force reload for updated editing rect for bound to take effect.
}
- (CGRect)iconImageViewRectForType:(SCTextFieldType) type{
    UIEdgeInsets edge = [self edgeInsetsForType:type];
    if (type == SCTextFieldTypeRound) {
        return CGRectMake(0, 0, edge.left*2, self.frame.size.height); //to put the icon inside
    }
    /*
     if (type == SCTextFieldTypeBlahBlah) {
     return 786; //whatever suits your field
     }
     */
    
    return CGRectMake(0, 0, edge.left, self.frame.size.height); // default
}
- (UIEdgeInsets)edgeInsetsForType:(SCTextFieldType) type{
    if (type == SCTextFieldTypeRound) {
        return UIEdgeInsetsMake(13, 13, 13, 13);
    }
    /*
     if (type == SCTextFieldTypeBlahBlah) {
     return UIEdgeInsetsMake(15, 15, 15, 15); //whatever suits your field
     }
     */
    
    return UIEdgeInsetsMake(10, 43, 10, 19); // default
}
- (NSString *)backgroundImageNameForType:(SCTextFieldType) type{
    if (type == SCTextFieldTypeRound) {
        return @"round_textfield";
    }
    /*
     if (type == SCTextFieldTypeBlahBlah) {
        return @""; // return suitable
     }
     */
    
    return @"text_field"; // default
}

@end
