//
//  RestfulSnapCRUD.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/21/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "RestfulSnapCRUD.h"
#import "Rest.h"
#import "SnapRead.h"
#import "Utility.h"
#import "SnapCreate.h"
#import "Command.h"

@implementation RestfulSnapCRUD


+ (void)checkAll {

    [RestfulSnapCRUD checkAndUpdateFriendList:^(BOOL i) {
        [RestfulSnapCRUD checkAndUpdateSnapInbox:^(BOOL i) {

        }];
        [RestfulSnapCRUD checkAndUpdateSnapStory:^(BOOL i) {

        }];
        [CommandFactory parseAndExecuteCommandList];

    }];
    [RestfulSnapCRUD purge];
}



+ (void)checkServerForNewFriendRequestsAndUpdate {

}

+ (void)checkServerForNewActionsAndUpdate {

}




#pragma mark - HELPER METHODS
+ (void)purge {

}

+ (void)checkAndUpdateFriendList:(void (^)(BOOL))completion {
    // passed back {"username":"Falcon","friendType":"2"}
    [Get getFriendList:^(BOOL success,NSArray * result){

        if(success){
            for(NSDictionary * pair in result){
                NSString * friendName = pair[@"username"];
                NSString * number = pair[@"friendType"];
                int iVal = [number intValue];

                if(debugging){NSLog(@"Checking our store against friendname: %@ with friendType : %@",friendName,number);}
                Friend * s = [SnapRead findFriendWithUsername:friendName];
                if(!s) {
                    s = [SnapCreate createNewFriendWithDisplayName:friendName andFriendType:iVal withUserName:friendName];
                }else{
                    // set the friend type no matta what
                    dispatchAsyncMainQueue(s.friendType = [NSNumber numberWithInt:
                            iVal];);

                }
// db.USERS.update({"username":"Joshua"},{$pull:{"friendList":{"username":"Mark","friendType":2}}})
            }
        }else if(debugging){
            NSLog(@"failed getting your friend list :(");
        }
    }];

}

// data is coming back now as 
+ (void)checkAndUpdateSnapStory:(void (^)(BOOL))completion {
    UserInfo * me = [SnapRead getUserInfo];

    [Get getListOfLastUpdatedStories:me.username andPass:me.password withComp:^(BOOL success, id res) {
        if(success){
            //// a[0] == typeof(NSString) a[1] == typeof(NSDate and repat the cycle
            NSArray * actual = (NSArray *)res;
            __block int numLeft = actual.count;
            for(NSString * snapID in actual){
                // even is the actualy snap ID
                [Get getContentInfo:snapID  withComp:^(BOOL res, Snap *snap) {
                    // actually get the content
                    [Get getContent:me.username withPass:me.password forSnap:snap withComp:^(BOOL i, id o) {
                        Snap * snap = (Snap *)o;
                        if(snap){
                            dispatch_async(dispatch_get_main_queue(),^{
                                [SnapUpdate linkSnapToStory:snap];
                            });
                        }
                        numLeft--;
                        if(numLeft == 0) {
                            completion(success);
                        }
                    }];
                }];
            }
        }else if(debugging){
            NSLog(@"Unable to retreive user's snap stories :|");
        }

    }];

}

+ (void)checkAndUpdateSnapInbox :(void (^)(BOOL))completion{



    [Get getSnapListForUser:[SnapRead getUserInfo] withComp:^(BOOL succes, id res) {
        UserInfo * me = [SnapRead getUserInfo];
        if(succes){
            if(debugging) {
                NSLog(@"Success on getting snap chat list  res: %@", res);
            }
            // res should be an NSSArray of <NSdictionary < STRING,STRING>
            __block int numLeft = ((NSArray *)res).count;
            for(NSDictionary * snap  in res){
                NSString * snapID = snap[@"snapID"];
                [Get getContentInfo:snapID withComp:^(BOOL res, Snap *snap) {
                    // actually get the content
                    [Get getContent:me.username withPass:me.password forSnap:snap withComp:^(BOOL success, id result) {
                        
                        numLeft--;
                        if(numLeft == 0) {
                            completion(success);
                        }
                    }];
                }];
            }
        }else{
            if(debugging) {
                NSLog(@"Error on getting snap chat list printing res : %@", res);
            }
        }
    }];
}


@end
