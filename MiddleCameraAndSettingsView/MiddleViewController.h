//
//  MiddleViewController.h
//  SnapchatLayout
//
//  Created by joshua on 7/3/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiddleViewController : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) UIScrollView *parentScrollView;

@property (weak, nonatomic) UITabBar *tabBar;

@end
