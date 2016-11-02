//
// Created by joshua on 7/12/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "SnapDelete.h"
#import "CoreDelete.h"
#import "Utility.h"
#import "CoreRead.h"
#import "Friend.h"
#import "SnapRead.h"


@implementation SnapDelete {

}


+ (BOOL)deleteDefaultUser {
    logMethod()
    [CoreDelete removeObjectsWithName:@"UserInfo" andPredicate:nil];
    return NO;
}

+ (BOOL)deleteFriend:(NSString *)displayName  withUserName:(NSString *)username andFriendID:(NSString *)friendID {
    logMethod()
    Friend * friend = [SnapRead findFriendWithUsername:username andDisplayName:displayName];
    if(friend != nil) {
        // always true
        return [CoreDelete removeObject:friend];

    }else{
        NSLog(@"Error deleting frined invalid display name and username!!!");
        return NO;
    }
}

+ (BOOL)deleteSnapWithID:(NSString *)snapID {
    logMethod()
    Snap * snap = [SnapRead getSnapWithID:snapID];
    if(snap != nil) {
        // always true
        return [CoreDelete removeObject:snap];

    }else{
        NSLog(@"Error deleting frined invalid display name and username!!!");
        return NO;
    }
}

+ (BOOL)deleteStory:(NSString *)username andDisplayName:(NSString *)displayName {
    logMethod()
    Story * story = [SnapRead getStoryWithUsername:username andDisplayName:displayName];

    if(story != nil) {
        // always true
        return [CoreDelete removeObject:story];

    }else{
        NSLog(@"Error deleting frined invalid display name and username!!!");
        return NO;
    }
}

@end