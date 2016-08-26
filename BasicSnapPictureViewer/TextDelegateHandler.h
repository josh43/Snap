//
// Created by joshua on 7/17/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TextDelegateHandler : NSObject <UITextFieldDelegate> {
    UIView *_addOnTop;
}

@property(nonatomic, strong) UIView *addOnTop;

-(instancetype)initWithParentView:(UIView *)parentView andLabel:(UITextField *) textField;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@end