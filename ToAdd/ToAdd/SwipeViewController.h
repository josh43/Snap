//
// Created by joshua on 7/3/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SwipeViewController : UIViewController <UIGestureRecognizerDelegate,UIScrollViewDelegate>
- (void)swipeDown:(id)swipeDown;
- (void)swipeUp:(id)swipeUp;
- (void)swipeLeft:(id)swipeLeft;
- (void)swipeRight:(id)swipeRight;


@property(nonatomic,strong) UISwipeGestureRecognizer *swipeDown;
@property(nonatomic,strong) UISwipeGestureRecognizer *swipeLeft;
@property(nonatomic,strong) UISwipeGestureRecognizer *swipeRight;
@property(nonatomic,strong) UISwipeGestureRecognizer *swipeUp;
@end