//
// Created by joshua on 7/12/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreCRUD.h"
@class UserInfo;
@class Friend;
@class Snap;
@class Story;


@interface SnapUpdate : NSObject



+(void)updateUserInfo:(UserInfo *)toUpdate;
// this will only get content with people you are actually friends with
+(void)updateFriendInfo:(Friend * )aFriend;
// This will make it for stories only in the last 24 hours!
+(void)updateSnap:(Snap * )aSnap;

+(void)linkSnapToStory:(Snap *)snap;

+(void)updateStory:(Story * )aStory;

+(void) setCurrentUserInfoTo:(UserInfo * )curr;








@end