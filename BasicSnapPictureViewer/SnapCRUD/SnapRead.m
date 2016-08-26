//
// Created by joshua on 7/12/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "SnapRead.h"
#import "Snap.h"
#import "Friend.h"
#import "UserInfo.h"
#import "Story.h"
#import "Utility.h"

static UserInfo * user;

@implementation SnapRead {

}

#pragma mark - Private Methods
+(__kindof NSManagedObject *) findObjectWithEntity:(NSString *) entity andKey:(NSString*)key andPredicate:(NSPredicate *) predicate{
    NSArray <NSManagedObject *> * res = [CoreRead findObjects:entity andKeyForEntity:key andPredicate:predicate andFetchedResultsController:nil useSectionKeyPath:NO];
    logMethod()
    if(res == nil){
        if(debugging){
            NSLog(@"In findObjectWithEnttiy we found nothing");
        }
        return nil;
    }else if(res.count == 0){
        if(debugging){
            NSLog(@"In findObjectWithEnttiy we found nothing");
        }
        return nil;
    }else{
        if(debugging){
            for(int i = 0; i < 5 && i < res.count; i ++){
                NSLog(@"Found %@",res[i]);
            }
            NSLog(@"\nReturning we %@",res[0]);
        }
        return res[0];
    }

}
+(__kindof NSArray<NSManagedObject *> *) findObjects:(NSString *) entity andKey:(NSString*)key andPredicate:(NSPredicate *) predicate{
    NSArray <NSManagedObject *> * res = [CoreRead findObjects:entity andKeyForEntity:key andPredicate:predicate andFetchedResultsController:nil useSectionKeyPath:NO];
    logMethod()
    if(res == nil){
        if(debugging){
            NSLog(@"In findObjects we found nothing");
        }
        return nil;
    }else if(res.count == 0){
        if(debugging){
            NSLog(@"In findObjects we found nothing");
        }
        return nil;
    }else{
        if(debugging){
            NSLog(@"In findObjects we found!!! %@",res);
        }
        return res;
    }

}
#pragma mark - Public Methods

+(NSArray<Friend *> *) findAllFriendsWithUsername:(NSString *)username{
    NSString * currentUserName = [self getUserInfo].username;
    return [self findObjects:@"Friend" andKey:@"username" andPredicate:
            [NSCompoundPredicate andPredicateWithSubpredicates:
                    @[
                            [NSPredicate predicateWithFormat:@"username = %@",username],
                            [NSPredicate predicateWithFormat:@"currentUserName = %@",currentUserName]
                    ]
            ]
    ];

}
+ (Friend *)findFriendWithUsername:(NSString *)username andDisplayName:(NSString *)displayName {
    return [SnapRead findObjectWithEntity:@"Friend" andKey:@"username"
                             andPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[
        [NSPredicate predicateWithFormat:@"username == %@",username],
            [NSPredicate predicateWithFormat:@"displayName == %@",displayName]

    ]]];
}
+ (Friend *)findFriendWithUsername:(NSString *)username {
    return [SnapRead findObjectWithEntity:@"Friend" andKey:@"username"
                             andPredicate:[NSPredicate predicateWithFormat:@"username == %@",username]];
}
+ (UserInfo *)getUserInfo {
    if(user == nil){
        user =[SnapRead findObjectWithEntity:@"UserInfo" andKey:@"username"
                                andPredicate:[NSPredicate predicateWithFormat:@"currentUser == %@",[NSNumber numberWithBool:YES]]];
    }
    return user;
}
+(void)setUser:(UserInfo *)toThis{
    user = toThis;
}
+(UserInfo * )findUserWithName:(NSString *) username{

    return [SnapRead findObjectWithEntity:@"UserInfo" andKey:@"username" andPredicate:[NSPredicate predicateWithFormat:@"username == %@",username]];
}
+ (Snap *)getSnapWithID:(NSString *)snapID {
    return [SnapRead findObjectWithEntity:@"Snap" andKey:@"snapID" andPredicate:[NSPredicate predicateWithFormat:@"snapID == %@",snapID]];
}

+ (Story *)getStoryWithUsername:(NSString *)username andDisplayName:(NSString *)displayName {
    return [SnapRead findObjectWithEntity:@"Story" andKey:@"numberViewed" andPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:@[
            [NSPredicate predicateWithFormat:@"user != nil"],
            [NSPredicate predicateWithFormat:@"user.username == %@",username],
            [NSPredicate predicateWithFormat:@"user.displayName == %@",displayName]

    ]]];
}



@end