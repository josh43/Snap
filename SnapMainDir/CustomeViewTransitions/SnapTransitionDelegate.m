//
// Created by joshua on 7/6/16.
// Copyright (c) 2016 joshua. All rights reserved.
// ----------I dont use this class in the relased version --------
// it was going to be used to make the oval animation that you see on snapchat's story
// but things went did not go as planned

#import "SnapTransitionDelegate.h"
#import "StoryTVC.h"
#import "SnapTVC.h"
#import "SnapTransition.h"


@implementation SnapTransitionAnimator{

}
/*
 * Swapping the values makes it easier to write a single animator that handles both presentations
 * and dismissals. When you design your animator, all you have to do is
 * include a property to know whether it is animating a presentation or dismissal.
 * The only required difference between the two is the following:

For a presentation, add the “to” view to the container view hierarchy.
For a dismissal, remove the “from” view from the container view hierarchy.
 *
 */
-(instancetype) initWithFromVC:(UIViewController<SnapTransition>*)from toVC:(UIViewController<SnapTransition> *)toVC{
    if(self = [super init]) {
        self.fromVC = from;
        self.toVC = toVC;
    }


    return self;

}
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    // make it slow at foist
    return 1.5;
}


-(void) dismiss:(id<UIViewControllerContextTransitioning>) transitionContext{
    

    UIView * containerView = [transitionContext containerView]; // main view to add all animations to


    CGRect finalToFrame = [_fromVC getFrameOfPicture];



    UIView * toView = _fromVC.view;


   // [_toVC setSubviewsTo:initialFromFrame];
   // toView.frame = initialFromFrame;

    __block float conerRad = 0;
    //toView.layer.cornerRadius = CGRectGetWidth(toView.
    // frame);

    [containerView addSubview:_fromVC.view];
   // [containerView addSubview:_toVC.view];

    [UIView animateWithDuration:0.5f animations:^{
        //_fromVC.view.frame = CGRectMake(0, 0, 500, 700);
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.fromValue = @(conerRad);
        animation.toValue = @(finalToFrame.size.width/2);
        [toView.layer setCornerRadius:finalToFrame.size.width/2];
        [toView.layer addAnimation:animation forKey:@"cornerRadius"];
        [self->_toVC setSubviewsTo:finalToFrame];
        [self->_toVC setCornerRadiusTo:conerRad];


        // werre going from big to smaaaal
    } completion:^(BOOL finished){

        // Notify UIKit that the transition has finished
        //[_toVC.view removeFromSuperview];

        [transitionContext completeTransition:YES];
    }];

    
}

-(void)show:(id <UIViewControllerContextTransitioning>) transitionContext{

    UIView * containerView = [transitionContext containerView]; // main view to add all animations to


    CGRect initialFromFrame = [_fromVC getFrameOfPicture]; // this could be the whole view or not
    CGRect finalToFrame = [_toVC getFrameOfPicture];



    UIView * toView = _toVC.view;


    [_toVC setSubviewsTo:initialFromFrame];
    toView.frame = initialFromFrame;

    __block float conerRad =  toView.frame.size.height/2;
    //toView.layer.cornerRadius = CGRectGetWidth(toView.
    // frame);
    [containerView addSubview:toView];
    //[containerView bringSubviewToFront:toView];

    [UIView animateWithDuration:0.5f animations:^{


        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.duration = 0.5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.fromValue = @(conerRad);
        animation.toValue = @(0);
        [toView.layer setCornerRadius:0];
        [toView.layer addAnimation:animation forKey:@"cornerRadius"];
        [self->_toVC setSubviewsTo:finalToFrame];
        [self->_toVC setCornerRadiusTo:conerRad];


        [toView setFrame:finalToFrame];
    } completion:^(BOOL finished){
        // Notify UIKit that the transition has finished
        [transitionContext completeTransition:YES];
    }];

}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {

    if(!self.presenting){ // if im the presentor you need to set this
        // flip everything around
        [self dismiss:transitionContext];
    }else {
        [self show:transitionContext];
    }
    //toView.frame = CGRectOffset(toView.frame,100,100);

}
@end

@implementation SnapTransitionDelegate {

}
-(instancetype)initWithFromVC:(UIViewController<SnapTransition>*)from toVC:(UIViewController<SnapTransition> *)toVC {
    if(self = [super init]) {
        self.fromVC = from;
        self.toVC = toVC;
    }

    return self;
}


- (id <UIViewControllerAnimatedTransitioning>)
       animationControllerForPresentedController:(UIViewController *)presented
                            presentingController:(UIViewController *)presenting
                                sourceController:(UIViewController *)source {

    SnapTransitionAnimator  *toReturn = [[SnapTransitionAnimator alloc] initWithFromVC:_fromVC toVC:_toVC];
    toReturn.presenting = YES;
    return toReturn;


}



- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    SnapTransitionAnimator  *toReturn = [[SnapTransitionAnimator alloc] initWithFromVC:_fromVC toVC:_toVC];
    toReturn.presenting = NO;
    return toReturn;
}



@end