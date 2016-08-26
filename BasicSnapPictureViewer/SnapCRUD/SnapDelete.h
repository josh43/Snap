//
// Created by joshua on 7/12/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SnapDelete : NSObject
#pragma clang diagnostic ignored "-Wnullability-completeness"
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
+(BOOL)deleteDefaultUser;
// Most likely these will be called from the update methods
// try and update if posssible else create it
+(BOOL)deleteFriend:(NSString *)displayName
                         withUserName:(NSString *)username
                          andFriendID:(NSString *) friendID;
// you have to check if the friend exists in the first place
// remember to delete out of the story if it is part of it
+(BOOL)deleteSnapWithID:(NSString *) snapID;

+(BOOL)deleteStory:(NSString *) username andDisplayName:(NSString *)displayName;

@end

#pragma clang diagnostics pop
#pragma clang diagnostics pop