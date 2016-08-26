//
// Created by joshua on 7/6/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SnapViewerViewController.h"
#import "SwipeViewController.h"
#import "SnapTransition.h"

@protocol StoryViewerDelegate;

@interface BridgeVC : SwipeViewController

@end


// StorySnapViewController is so similiar to snapviewercontroller
// and StoryTVC ~= SnapTVC but OO programming and objective c :(
// I want something like
// class OOClass{public: virtual void mustImplementMe() = 0; void doSomething(){privateMemberFunction();mustImplementMe();}}
@interface StorySnapViewController : SwipeViewController<SnapTransition>


@property(strong, nonatomic) ContentDisplayer * contentDisplayer;
@property (strong, nonatomic) UITextField *textField;
@property(nonatomic,strong) NSTimer * timer;
//NOTE dont ever change the length in the story!!
@property(nonatomic,weak) Story *story;
//@property(nonatomic,weak) Snap * singleSnap;
@property (nonatomic) BOOL shouldDecrement;
@property (nonatomic) int currentPictureInList;
@property (nonatomic) int currentPictureViewTime;
@property(nonatomic, weak) id<StoryViewerDelegate> completionDelegate;
-(instancetype) initWithFrame:(CGRect) frame andData:(NSData *) data withContentType:(int)content_type
                       andUrl:(NSURL *)url orWithSnap:(Snap *)snap andStory:(Story *)story;
-(instancetype) init;

-(void) start;
@end