//
// Created by joshua on 7/11/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>
@import MediaPlayer;
@import AVFoundation;
@import MediaPlayer;

@class Story;
@class Snap;
@class VideoLayer;


@interface ContentDisplayer : NSObject{

}

//
//  ContentFinishedViewController.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/11/16.
//  Copyright © 2016 joshua. All rights reserved.
//@propert
@property(nonatomic, weak) NSData *data;
@property(nonatomic) int contentType;
@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong)     UIImageView *iView;
@property(nonatomic, strong) UIView * myView;
@property(nonatomic) BOOL usingQueuePlayer;
// probably not a good idea to modify outside of this, but just in case
@property(nonatomic,strong) VideoLayer *vidLayer;

-(void)loadAndDisplayImage:(UIImage *)image;
-(instancetype) initWithFrame:(CGRect) frame andData:(NSData *) data withContentType:(int)content_type
                       andUrl:(NSURL *)url orWithSnap:(Snap *)snap andStory:(Story *)story;

-(instancetype) init;

-(void) unObserveKeyValues;

-(void) startMovie;
-(void) playNextMovie;
-(void) stopMovie;


-(void) bringMovieViewToFront;
-(void) bringImageViewToFront;

@end