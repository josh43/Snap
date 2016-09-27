//
// Created by joshua on 7/5/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Snap;

@protocol PictureViewerInterface <NSObject>
-(void) finishedViewingPicture:(Snap *) pInfo;
@end