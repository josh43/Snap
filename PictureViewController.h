//
//  PictureViewController.h
//  SnapchatLayout
//
//  Created by joshua on 7/3/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeViewController.h"
@interface PictureViewController : SwipeViewController
@property(nonatomic,weak) UIScrollView * scrollView;

@property(nonatomic) CGRect cameraButtonBounds;
@end
