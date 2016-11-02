//
// Created by joshua on 7/3/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "SwipeViewController.h"
#include "FunctionMacros.h"


@implementation SwipeViewController {


}

#pragma  mark VIEWCONTROLLER
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    _swipeRight= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    _swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    _swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];

    if(!_swipeDown || ! _swipeUp || !_swipeLeft || !_swipeRight){
        NSLog(@"Error couldn't instantiate all swipe gestures");
        //exit(0);
    }
    // DEFAULT HANDLERS ALL CAPS YES
    SETSWIPE(_swipeLeft,self,UISwipeGestureRecognizerDirectionLeft)
    SETSWIPE(_swipeRight,self,UISwipeGestureRecognizerDirectionRight)
    SETSWIPE(_swipeUp,self,UISwipeGestureRecognizerDirectionUp)
    SETSWIPE(_swipeDown,self,UISwipeGestureRecognizerDirectionDown)

}



#pragma  mark SWIPE HANDLER METHODS PLEEEEASE OVERIDE THESE
- (void)swipeDown:(id)swipeDown {
    @throw [NSException exceptionWithName:@"Overide method" reason:@"You have to" userInfo:nil];
}

- (void)swipeUp:(id)swipeUp {
    @throw [NSException exceptionWithName:@"Overide method" reason:@"You have to" userInfo:nil];
}

- (void)swipeRight:(id)swipeRight {
    @throw [NSException exceptionWithName:@"Overide method" reason:@"You have to" userInfo:nil];
}

- (void)swipeLeft:(id)swipeLeft {
    @throw [NSException exceptionWithName:@"Overide method" reason:@"You have to" userInfo:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark GESTURE RECOGNIZTION
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

@end