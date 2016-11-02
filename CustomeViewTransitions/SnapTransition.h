//
// Created by joshua on 7/6/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SnapTransition

-(UIImage *) myPicture;
-(CGRect) getFrameOfPicture;

- (void)setSubviewsTo:(CGRect)rect;


- (void)setCornerRadiusTo:(CGFloat)radius;
@end