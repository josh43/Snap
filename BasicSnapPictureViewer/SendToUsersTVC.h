//
// Created by joshua on 7/11/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyFriendsTVC.h"

@class ContentFinishedViewController;


@interface SendToUsersTVC : MyFriendsTVC

-(void) userDidCheckButton:(BOOL)state withTarget:(NSString*) username withIndexPath:indexPath;
@property(nonatomic,strong) NSMutableArray<NSIndexPath *> * usersToSendTo;
@property(nonatomic, weak) ContentFinishedViewController *onCompletionDelegate;
@end