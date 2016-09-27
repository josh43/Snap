//
// Created by joshua on 7/24/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "Command.h"
#import "Snap.h"
#import "SnapRead.h"
#import "Post.h"
#import "Delete.h"
#import "SnapDelete.h"
#import "Get.h"


@implementation Command {

}

- (void)execute {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override this method %@!!", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}
@end

@implementation CommandFactory{


}

+ (void)parseAndExecuteCommandList {

    UserInfo * me = [SnapRead getUserInfo];
    NSString * query = [NSString stringWithFormat:@"{\"username\":\"%@\"}",me.username];
    NSString * projection = @"{\"actionList\":1,\"_id\":0}";
    [Get queryWithProjection:me.username withPass:me.password andQuery:query withProjection:projection withComp:^(BOOL success, id res) {
        logMethod();
        NSLog(@"%@",res);
        if(success){
            if(!res[0]){

                return;
            }
            NSArray * array =  res[0][@"actionList"];
            if(![array isKindOfClass:[NSArray class]]){
                NSLog(@"Error parsingandExecuting Command list the array res[0][@\"actionList\"] was not really an array! ");
                return;
            }
            for(NSDictionary * actionReq in array){
                if(![actionReq isKindOfClass:[NSDictionary class]]){
                    NSLog(@"Error parsingandExecuting Command list the dictionary was not really an dictionary! ");
                    return;
                }
                NSLog(@"Found action request%@",actionReq);
                NSString * username = actionReq[@"user"];
                NSString * methodID = actionReq[@"actionType"];
                NSString * snapID = actionReq[@"snapID"];
                int id = [methodID intValue];
                Snap * theSnap = [SnapRead getSnapWithID:snapID];
                if(!theSnap){
                    NSLog(@"This could potentially be an error in %i of Command @ parseAndExecute\n"
                            "unless the case were the USER_DELETED it in which it is permissable to not have fetched the snap in the first place",__LINE__);
                    continue;
                }
                switch(id){
                    case USER_SAW:{
                        [self aUserSawThisSnap:theSnap withUserName:username];
                        break;
                    }case USER_SCREEN_SHOTTED:{
                        [self aUserScreenShottedThisSnap:theSnap withUserName:username];
                        break;
                    }default:{
                        [self aUserDeletedSnapFromStory:theSnap withUserName:username];
                        // deleted
                    }
                }
                //user:username . methoID:x owner:username snapID:snap

            }
        }

    }];

}

+ (void)thisUserSawSnap:(Snap *)theSnap {
    UserInfo * me = [SnapRead getUserInfo];
    [Post picSeen:theSnap.snapID byUser:me.username withComp:^(BOOL succ, id res) {
        if(debugging){NSLog(@"response from user saw snap %@",res);}



    }];
    [Post sendAction:USER_SAW byUser:me.username toOwner:theSnap.friend.username withSnap:theSnap withComp:^(BOOL succ, id res) {
        if(debugging){NSLog(@"response from user saw snap %@",res);}

    }];
    
}

+ (void)thisUserScreenShottedSnap:(Snap *)theSnap {
    UserInfo * me = [SnapRead getUserInfo];
    [Post screenShot:theSnap.snapID byUser:me.username withComp:^(BOOL succ, id res) {
        if (debugging) {NSLog(@"response from user screen shotted snap %@", res);}


    }];
    [Post sendAction:USER_SCREEN_SHOTTED byUser:me.username toOwner:theSnap.friend.username withSnap:theSnap withComp:^(BOOL succ, id res) {
        if(debugging){NSLog(@"response from user saw snap %@",res);}
        
    }];
}

+ (void)thisUserDeletedSnapFromStory:(Snap *)theSnap {
    UserInfo * me = [SnapRead getUserInfo];
    [Delete removeSnapFromStory:me.username andPass:me.password andSnapID:theSnap.snapID andComp:^(BOOL i, id o) {

    }];
    [Post sendAction:USER_DELETED  byUser:me.username toOwner:theSnap.friend.username withSnap:theSnap withComp:^(BOOL succ, id res) {
        if(debugging){NSLog(@"response from user saw snap %@",res);}
        
    }];
}



//BEGIN TESTING HELPER FUNCTION
+(void)thisUser:(NSString *) user SawSnap:(Snap *) theSnap whoOwnsIt:(NSString*) owner{
    
    [Post picSeen:theSnap.snapID byUser:user withComp:^(BOOL succ, id res) {
        if(debugging){NSLog(@"response from user saw snap %@",res);}



    }];
    [Post sendAction:USER_SAW byUser:user toOwner:owner withSnap:theSnap withComp:^(BOOL succ, id res) {
        if(debugging){NSLog(@"response from user saw snap %@",res);}
        
    }];
}

+ (void)thisUser:(NSString *)user ScreenShottedSnap:(Snap *)theSnap whoOwnsIt:(NSString*)owner{
    [Post screenShot:theSnap.snapID byUser:user withComp:^(BOOL succ, id res) {
        if (debugging) {NSLog(@"response from user screen shotted snap %@", res);}


    }];
    [Post sendAction:USER_SCREEN_SHOTTED byUser:user toOwner:owner withSnap:theSnap withComp:^(BOOL succ, id res) {
        if(debugging){NSLog(@"response from user saw snap %@",res);}
        
    }];
}

+ (void)thisUser:(NSString *)user andPass:(NSString *)pass DeletedSnapFromStory:(Snap *)theSnap {
    
    [Delete removeSnapFromStory:user andPass:pass andSnapID:theSnap.snapID andComp:^(BOOL i, id o) {

    }];
    [Post sendAction:USER_DELETED byUser:user toOwner:theSnap.friend.username withSnap:theSnap withComp:^(BOOL succ, id res) {
        if(debugging){NSLog(@"response from user saw snap %@",res);}
        
    }];;
}


//END TESTING HELPER FUNCTIONS

// member helper functions
+ (void)aUserSawThisSnap:(Snap *)snap withUserName :(NSString *)name {
    [snap addFriendThatHasSeen:[SnapRead findFriendWithUsername:name]];
    snap.hasSeen = [NSNumber numberWithBool:YES];
}

+ (void)aUserScreenShottedThisSnap:(Snap *)snap withUserName :(NSString *)name {

}

+ (void)aUserDeletedSnapFromStory:(Snap *)theSnap withUserName:(NSString *)name {
    [SnapDelete deleteSnapWithID:theSnap.snapID];
}


@end
