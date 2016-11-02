//
//  MainViewController.h
//  SnapchatLayout
//
//  Created by joshua on 7/3/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnapTransition.h"

@class TabBarObservable;

@interface MainViewController : UIViewController<UITabBarDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *leftItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *middleItem;
@property (weak, nonatomic) IBOutlet UITabBarItem *rightItem;
@property(strong,nonatomic) UIScrollView * scrollView;

@property CGRect transitionRect;

-(void)onCameraTouch;

@end
