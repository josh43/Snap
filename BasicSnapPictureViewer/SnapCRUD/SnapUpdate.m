//
// Created by joshua on 7/12/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "SnapUpdate.h"
#import "UserInfo.h"
#import "Friend.h"
#import "Snap.h"
#import "Story.h"
#import "Utility.h"
#import "SnapRead.h"
#import "SnapCreate.h"


@implementation SnapUpdate {

}


+ (void)updateUserInfo:(UserInfo *)toUpdate {

    UserInfo * info  = [SnapRead getUserInfo];
    if(info)
    info = toUpdate;

}
+(void) setCurrentUserInfoTo:(UserInfo * )curr{
    UserInfo * previousUser = [SnapRead getUserInfo];
    if(previousUser != nil) {
        previousUser.currentUser = [NSNumber numberWithBool:NO];
    }
    [SnapRead setUser:curr];
    curr.currentUser = [NSNumber numberWithBool:YES];
    [CoreUpdate  save];
}
+ (void)updateFriendInfo:(Friend *)aFriend {

    logMethod()
    Friend * info = [SnapRead findFriendWithUsername:aFriend.username andDisplayName:aFriend.displayName];
    if(info)
        info = aFriend;


}

+ (void)updateSnap:(Snap *)aSnap {
    logMethod()
    Snap * info = [SnapRead getSnapWithID:aSnap.snapID];
    if(info) {
        info = aSnap;
    }
}
+(void)linkSnapToStory:(Snap *)snap{
    logMethod()
    if(!snap.friend){
       NSLog(@"This is an error the snap must have an owner!!!!");
        exit(0);
    }
    if(!snap.friend.story){
        snap.friend.story = [CoreCreate createObject:@"Story"];
        snap.friend.story.user = snap.friend;
    }
    [SnapCreate addToStorywithSnap:snap andUser:snap.friend];
    [CoreUpdate  save];
}
+ (void)updateStory:(Story *)aStory {
   logMethod()
    if(aStory.user){
        Story * info = [SnapRead getStoryWithUsername:aStory.user.username andDisplayName:aStory.user.displayName];
        info = aStory;
    }else{
        if(debugging){
            NSLog(@"@error the story's user must be non null when trying to update!");
        }
    }
}



@end