//
// Created by joshua on 7/6/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Snap;
@protocol StoryViewerDelegate <NSObject>

-(void) doneWithStory:(NSSet<Snap *> * )snapList;
@end