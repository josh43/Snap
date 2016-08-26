//
// Created by joshua on 7/17/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "TextDelegateHandler.h"


@implementation TextDelegateHandler {

    UIView *parentView;
    UITextField * textField;
    CGRect keyboardRect;
    CGPoint undoScroll;
}

-(instancetype)init{
    @throw [NSException exceptionWithName:@"Dont use this init" reason:@"use [... initWithParentView:(UIView *)]" userInfo:nil];

    return nil;
}
-(instancetype)initWithParentView:(UIView *)parentVieww andLabel:(UITextField *) textFieldd{
    if(self = [super init]) {
        parentView = parentVieww;
        // just in case I need it, although the delegate methods should put it in range
        textField = textFieldd;


        // setting the initial height(guess) because the notification below gets called after
        // the textFieldShouldBeginEditing gets called.. so the scroll view will adjust incorrectly
        // given that the frame will be {0,0,0,0}
        // the last two parameters shouldnt matter but what the hey
        keyboardRect = CGRectMake(0,parentVieww.frame.size.height*2/3,parentVieww.frame.size.width,parentVieww.frame.size.height);
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setKeyboardHeightAndWidth:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
    }

    return self;
}



#pragma mark - Keyboard setter
//http://stackoverflow.com/questions/3546571/how-to-get-uikeyboard-size-with-apple-iphone-sdk
- (void)setKeyboardHeightAndWidth:(NSNotification *)notification {
// although this is called every time I don't know another way of getting the keyboard width and height
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    keyboardRect = [keyboardFrameBegin CGRectValue];
}

#pragma mark - helper methods

- (void)scrollParentViewToBounds:(UITextField *)field {
    int changeInY = 0;
    if((changeInY = (int)((field.frame.origin.y+field.frame.size.height) - keyboardRect.origin.y)) > 0){
        // i need to change!
        CABasicAnimation * position = [CABasicAnimation animationWithKeyPath:@"position"];
        position.duration = 0.35f;
        position.repeatCount = 0;
        //layer.cornerRadius
        position.fromValue = [parentView.layer valueForKey:@"position"];
        CGPoint currPos = parentView.layer.position;
        CGPoint finalPos = CGPointMake(currPos.x,currPos.y - changeInY);
        undoScroll = currPos;
        position.toValue =[NSValue valueWithCGPoint:finalPos];
        [parentView.layer setPosition:finalPos];
        [parentView.layer addAnimation:position forKey:@"position"];

    }else{
        undoScroll = CGPointMake(-1000,0);
    }
}
-(void)unscroll{
    if(undoScroll.x != -1000) {
        CABasicAnimation *position = [CABasicAnimation animationWithKeyPath:@"position"];
        position.duration = 0.35f;
        position.repeatCount = 0;

        position.fromValue = [parentView.layer valueForKey:@"position"];
        CGPoint currPos = parentView.layer.position;
        CGPoint finalPos = undoScroll;
        position.toValue = [NSValue valueWithCGPoint:finalPos];
        [parentView.layer setPosition:finalPos];
        [parentView.layer addAnimation:position forKey:@"position"];
    }
}

#pragma mark - textField touch methods

#pragma mark - textfield delegate methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)theTextField {
    [self scrollParentViewToBounds:theTextField];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self scrollParentViewToBounds:nil];

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self unscroll];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

@end