//
//  UITextField+SCTextField.h
//  SCTextViewDemo
//
//  Created by Adil Soomro on 4/14/14.
//  Copyright (c) 2014 Adil Soomro. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SCTextFieldTypeDefault,
    SCTextFieldTypeRound
} SCTextFieldType;

@interface SCTextField : UITextField

@end


@interface UITextField ()
- (void)setupTextFieldWithIconName:(NSString *)name;
- (void)setupTextFieldWithType:(SCTextFieldType)type withIconName:(NSString *)name;
@end
