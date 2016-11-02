//
//  RestfulSnapCRUD.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/21/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestfulSnapCRUD : NSObject
// Below methods make calls to the rest classes I made along with methods in CRUD
// to handle most of how the app get updated
/*
                        [RestfulSnapUpdater]
                  /                         \
                /                               \
               /                                 \
        [SnapCrud]                          [RestMethods]
            /                                       \
    Snap[,crud,update,delete,read]            Get,Post,Delete
 */





#pragma mark - UPDATES
+(void)checkAll;

+(void)checkServerForNewFriendRequestsAndUpdate;
+(void)checkServerForNewActionsAndUpdate;


+ (void) checkAndUpdateFriendList:(void (^)(BOOL))completion;

+ (void)checkAndUpdateSnapInbox:(void (^)(BOOL))completion;
+ (void)checkAndUpdateSnapStory:(void (^)(BOOL))completion;
// not sure if I will need those below..
#pragma mark - INSERTS



#pragma mark - DELETES

+ (void)purge;
@end
