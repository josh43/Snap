//
// Created by joshua on 7/12/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreCRUD.h"

@class Content;
@class Friend;
@class Snap;
@class UserInfo;
@class Story;

@interface SnapCreate : NSObject
+(UserInfo *)createUserWithName:(NSString *) username andPasword:(NSString *)password;


+(Content *)createContentWith:(UIImage *) thePic
       andStringURL:(NSString *)url
           withType:(int)type;
// Most likely these will be called from the update methods
// try and update if posssible else create it
+(Friend *)createNewFriendWithDisplayName:(NSString *)displayName
                        andFriendType:(int)friendType
                         withUserName:(NSString *)username;
// you have to check if the friend exists in the first place
#pragma mark - Personal/story snap chats depending on snapType
+(Snap *)createSnapWithDate:(NSDate *) date andLength:(float)length
              andSnapType:(int)snapType
                andSnapID:(NSString *)snapID
               andContent:(nonnull Content *)content
                  andUser:(nonnull Friend *)friend;

+(Snap *)createUserStorySnapWithDate:(NSDate *) date andLength:(float)length
                 andContent:(nonnull Content *)content
                    andUser:(nonnull UserInfo *)user;

+(Snap *)createUserSendSnapChat:(NSDate *)date
        andContentType:(int)contentType
                andLength:(float)length
                  andUser:(UserInfo *)user
           withFriendList:(nonnull NSMutableArray<NSString *> *) usernameList;

+(Snap *)createUserSendSnapChat:(NSDate *)date
        andContentType:(int)contentType
                    andLength:(float)length
                      andUser:(UserInfo *)user
               withActualFriendList:(nonnull NSMutableArray<Friend *> *) friendList;


#pragma mark - Story Snap chats

+(Story *)addToStorywithSnap:(nonnull Snap *) initial
             andUser:(nonnull Friend *)friend;


@end