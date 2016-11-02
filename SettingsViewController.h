//
//  SettingsViewController.h
//  SnapchatLayout
//
//  Created by joshua on 7/3/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeViewController.h"
@interface SettingsViewController : SwipeViewController
@property (weak, nonatomic) IBOutlet UIView *addedMeView;
@property (weak, nonatomic) IBOutlet UIView *addFriendsView;
@property (weak, nonatomic) IBOutlet UIView *myFriendsView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property(nonatomic,weak) UIScrollView * scrollView;

-(void) adjustScroll;
@end
