//
// Created by joshua on 7/6/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SnapTransition;

/*
 * Animator objects. An animator object is responsible for creating the animations
 * used to reveal or hide a view controller’s view. The transitioning delegate can supply
 * separate animator objects for presenting and dismissing the view controller.
 * Animator objects conform to the UIViewControllerAnimatedTransitioning protocol.
Interactive animator objects. An interactive animator object drives the timing of
 custom animations using touch events or gesture recognizers. Interactive animator
 objects conform to the UIViewControllerInteractiveTransitioning protocol.
The easiest way to create an interactive animator is to subclass
 UIPercentDrivenInteractiveTransition class and add event-handling code to your subclass. That class controls the timing of animations created using your existing animator objects. If you create your own interactive animator, you must render each frame of the animation yourself.
Presentation controller. A presentation controller manages the presentation style while the view controller is onscreen. The system provides presentation controllers for the built-in presentation styles and you can provide custom presentation controllers for your own presentation styles. For more information about creating a custom presentation controller, see Creating Custom Presentations.
 *
 *
 */
@interface SnapTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property(nonatomic) BOOL presenting;
@property(nonatomic, weak) UIViewController <SnapTransition> *toVC;
@property(nonatomic, weak) UIViewController <SnapTransition> *fromVC;

-(instancetype)initWithFromVC:(UIViewController<SnapTransition>*)from toVC:(UIViewController<SnapTransition> *)toVC;
@end
@interface SnapTransitionDelegate : NSObject <UIViewControllerTransitioningDelegate>
@property(nonatomic, weak) UIViewController <SnapTransition> *toVC;
@property(nonatomic, weak) UIViewController <SnapTransition> *fromVC;
-(instancetype)initWithFromVC:(UIViewController<SnapTransition>*)from toVC:(UIViewController<SnapTransition> *)toVC;
@end