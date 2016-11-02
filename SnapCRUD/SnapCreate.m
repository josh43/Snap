//
// Created by joshua on 7/12/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "SnapCreate.h"
#import "Content.h"
#import "Friend.h"
#import "Snap.h"
#import "UserInfo.h"
#import "Story.h"
#import "Utility.h"
#import "SnapRead.h"


@implementation SnapCreate {

}

+ (UserInfo *)createUserWithName:(NSString *)username andPasword:(NSString *)password {

    UserInfo *user = [CoreCreate createObject:@"UserInfo"];
    if (user == nil) {
        return nil;
    }
    user.username = username;
    user.password = password;

    [CoreUpdate save];
    return user;
}
+(Content *)createContentWith:(UIImage *) thePic
                 andStringURL:(NSString *)url
           withType:(int)type{
    logMethod()
    Content *content = [CoreCreate createObject:@"Content"];
    if(!content){
        return nil;
    }
    content.contentType = [NSNumber numberWithInt:type];
    content.url = url;
    //0 == worst quality 1 == best
    content.content = UIImageJPEGRepresentation(thePic,1.0f);
    [CoreUpdate  save];
    return content;

}

+ (Friend *)createNewFriendWithDisplayName:(NSString *)displayName
                         andFriendType:(int)friendType withUserName:(NSString *)username {
    logMethod()
    Friend *friend = [CoreCreate createObject:@"Friend"];
    // MUST BE UNIQUE!!
    if(!friend){return nil;}
    friend.username = username;
    friend.displayName = displayName;
    friend.firstLetter = [username substringToIndex:1].uppercaseString;
    friend.friendType = @(friendType);
    UserInfo * user = [SnapRead getUserInfo];
    friend.currentUserName = user.username;
    [CoreUpdate  save];
    return friend;
}

+ (Snap *)createSnapWithDate:(NSDate *)date andLength:(float)length
               andSnapType:(int)snapType andSnapID:(NSString *)snapID
                andContent:(Content *)content andUser:(Friend *)friend {
    logMethod()
    [CoreUpdate  save];

    return [self createSnapWith:date andLen:length andType:snapType andID:snapID andContent:content andFriend:friend andUser:nil];
}
+(Snap *)createUserStorySnapWithDate:(NSDate *) date
                           andLength:(float)length
                          andContent:(nonnull Content *)content
                             andUser:(nonnull UserInfo *)user{
    logMethod()
    Snap * theSnap = [self createSnapWith:date andLen:length andType:SNAP_STORY_TYPE andID:nil andContent:content andFriend:nil andUser:user];
    theSnap.currentUserName = user.username;
    
    
    [self addToUserStoryWithSnap:theSnap andUser:user];
    [CoreUpdate  save];
    return theSnap;

}





+ (Story *)addToUserStoryWithSnap:(Snap *)snap andUser:(UserInfo *)user {
    logMethod()
    return [self addtoStoryThisSnap:snap withFriend:nil andUser:user];
}



+ (Story *)addToStorywithSnap:(Snap *)initial andUser:(Friend *)friend {
    logMethod()
    return [self addtoStoryThisSnap:initial withFriend:friend andUser:nil];

}

+(Snap *)createUserSendSnapChat:(NSDate *)date
               andContentType:(int)contentType
                    andLength:(float)length
                      andUser:(UserInfo *)user
         withActualFriendList:(nonnull NSMutableArray<Friend *> *) friendList{
    logMethod()
    Content * cont = [SnapCreate createContentWith:nil andStringURL:nil withType:contentType];

    return [self createSnapWith:date andLen:length andType:SNAP_USER_SENT_TYPE
                   andID:nil andContent:cont andFriend:nil andUser:user andFriendList:friendList];

}
+ (Snap *)createUserSendSnapChat:(NSDate *)date
                andContentType:(int)contentType
                     andLength:(float)length andUser:(UserInfo *)user
                withFriendList:(NSArray<NSString *> *)usernameList {
    logMethod()
    NSMutableArray <Friend *> * friendList = [[NSMutableArray<Friend *> alloc]init];
    for(NSString * username in usernameList){
        Friend * toAdd = [SnapRead findFriendWithUsername:username];
        if(debugging) {
            if (toAdd == nil){
                toAdd = [SnapCreate createNewFriendWithDisplayName:username andFriendType:MUTUAL_FRIENDS withUserName:username];
                NSLog(@"Unable to find that friend so I am creating for debugging purposes!!!");
            }
        }
        [friendList addObject:toAdd];
    }
    if(debugging){
        NSLog(@"About to add snap receipts %@",friendList);
    }
    Content * cont = [SnapCreate createContentWith:nil andStringURL:nil withType:contentType];
    return [self createSnapWith:date andLen:length andType:SNAP_USER_SENT_TYPE andID:nil andContent:cont andFriend:nil andUser:user andFriendList:friendList];
}

#pragma  mark - Helper methods

+ (Story *)addtoStoryThisSnap:(Snap *)snap withFriend:(Friend *)friend andUser:(UserInfo *)user
{
    logMethod()
    Story *story = nil;
    // you may have to create the story
   if(friend) {
       story = [SnapRead getStoryWithUsername:friend.username andDisplayName:friend.displayName];
   }else{
       story = user.story;
   }
    if(story == nil){
        // create it
        story = [CoreCreate createObject:@"Story"];
    }



    // one of these should be null
    if(!user && !friend){if(debugging){NSLog(@"Error one of these must be null");}}

    // link up
    story.numberOfSnaps = @([story.numberOfSnaps intValue]+1);

    story.myInfo = user;
    story.user = friend;
    if(user) {
        user.story = story;
    }else {
        friend.story = story;
    }

    [story insertSnap:snap];
    if(story.mostRecentSnapNotSeen == nil){
        story.mostRecentSnapNotSeen = snap;
    }else if(story.mostRecentSnapNotSeen.dateSent.timeIntervalSince1970 < snap.dateSent.timeIntervalSince1970){
        story.mostRecentSnapNotSeen = snap;
    }
    
    UserInfo * currentUser = [SnapRead getUserInfo];
    story .currentUserName = currentUser.username;
    [CoreUpdate  save];

    return story;
}

+ (Snap *)createSnapWith:(NSDate *)date
                  andLen:(float)len andType:(int)type
                   andID:(NSString *)ID andContent:(Content *)content
               andFriend:(Friend *)friend andUser:(UserInfo *)user {
    logMethod()
    Snap *snap= [CoreCreate createObject:@"Snap"];
    // MUST BE UNIQUE!!
    if(snap == nil){
        return nil;
    }
    snap.length = @(len);
    snap.snapID =  ID == nil? [NSProcessInfo processInfo].globallyUniqueString : ID;
    snap.hasSeen = @NO;
    snap.dateSent = date;
    snap.snapType = @(type);

    snap.friend = friend;
    snap.thisUser = user;
    snap.content = content;

    UserInfo * currentUser = [SnapRead getUserInfo];
    snap .currentUserName = currentUser.username;
    [CoreUpdate  save];

    return snap;
}
+ (Snap *)createSnapWith:(NSDate *)date andLen:(float)len
               andType:(int)type andID:(NSString *)ID
            andContent:(Content *)content andFriend:(void *)friend andUser:(UserInfo *)user
         andFriendList:(NSMutableArray<Friend *> *)list {
    logMethod()
    bool set  = NO;
    Content * next = content;
    Snap * toReturn;
    for(Friend * friend in list){
        // this is really slow but

        if(set){
            if(debugging){
                NSLog(@"NOTE ONLY USE THIS METHOD in SnapCreate when debugging, its pretty inefficient");
            }
            next = [SnapCreate createContentWith:[content getUIImage]andStringURL:content.url withType:[content.contentType intValue]];
            
        }
        set = YES;
        Snap * snap = [self createSnapWith:date andLen:len andType:type andID:nil andContent:next andFriend:friend andUser:user];
        UserInfo * currentUser = [SnapRead getUserInfo];
        snap .currentUserName = currentUser.username;
        
        toReturn = snap;
    }
    [CoreUpdate  save];

    return toReturn;
}
@end