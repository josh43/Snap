//
//  ContentFinishedViewController.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/11/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <UIKit/UIKit.h>

@import MediaPlayer;

@class Friend;
@class TextDelegateHandler;

@interface ContentFinishedViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *exButton;


@property(nonatomic, weak) NSData *data;
@property(nonatomic) int contentType;
@property(nonatomic, strong) NSURL *url;

-(void) sendContentToFriendList:(NSMutableArray <Friend * > *) friendList;

- (void)shouldFinish;

- (void)userTouchedPoint:(CGPoint)point;

- (void)canShowMovieStoryWith:(NSURL *)url;
@end
