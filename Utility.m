//
//  Utility.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/15/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utility.h"
void addBottomBorder(UIView * toThisView,CGColorRef withCGColor,float size) {
    CALayer *theBorder = [CALayer layer];
    theBorder.backgroundColor = withCGColor;
    CGRect frame = toThisView.frame;
    frame = CGRectMake(0, frame.size.height - size, frame.size.width, size);
    theBorder.frame = frame;
    [toThisView.layer addSublayer:theBorder];
}

void addTopBorder(UIView * toThisView,CGColorRef withCGColor,float size){
    CALayer *theBorder = [CALayer layer];
    theBorder.backgroundColor = withCGColor;
    CGRect frame = toThisView.frame;
    frame = CGRectMake(0, 0, frame.size.width, size);
    theBorder.frame = frame;
    [toThisView.layer addSublayer:theBorder];
}
void addLeftBorder(UIView * toThisView,CGColorRef withCGColor,float size) {
    CALayer *theBorder = [CALayer layer];
    theBorder.backgroundColor = withCGColor;
    CGRect frame = toThisView.frame;
    frame = CGRectMake(0, 0, size, frame.size.height);
    theBorder.frame = frame;
    [toThisView.layer addSublayer:theBorder];

}
void addRightBorder(UIView * toThisView,CGColorRef withCGColor,float size) {
    CALayer *theBorder = [CALayer layer];
    theBorder.backgroundColor = withCGColor;
    CGRect frame = toThisView.frame;
    frame = CGRectMake( frame.size.width- size,0, size, frame.size.height);
    theBorder.frame = frame;
    [toThisView.layer addSublayer:theBorder];
}