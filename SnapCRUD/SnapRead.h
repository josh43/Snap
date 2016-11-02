//
// Created by joshua on 7/12/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreCRUD.h"
@class Snap;
@class Friend;
@class Friend;
@class UserInfo;
@class Story;


@interface SnapRead : NSObject


// These will most liklely just call above methods than call queries to get the info :D :))))))

+(Friend *) findFriendWithUsername:(NSString *)username andDisplayName:(NSString * )displayName;
+(UserInfo * )getUserInfo;
+(UserInfo * )findUserWithName:(NSString *) username;
+(Snap * )getSnapWithID:(NSString *) snapID;
+(Story * )getStoryWithUsername:(NSString *) username andDisplayName:(NSString *) displayName;
// this will only get content with people you are actually friends with
+(void)setUser:(UserInfo *)toThis;


+ (Friend *)findFriendWithUsername:(NSString *)username;
@end