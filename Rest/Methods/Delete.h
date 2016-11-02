//
// Created by joshua on 7/20/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPHelper.h"
//DELETE METHODS
//router.delete("/findOneAndDelete/:username/:password/", function (req, res) {
//router.delete("/deleteSnapFromStory/:username/:password/:snapID", function (req, res) {
//router.delete("/removeFriend/:username/:password/:friendUserName/:friendType", function (req, res) {

@interface Delete : NSObject



+(void) helloDelete:(void (^)(BOOL,id)) onCompletion;
+(void) deleteAccount:(NSString *) username andPass:(NSString *)pass andComp:(void (^)(BOOL,id)) onCompletion;
+(void) removeSnapFromStory:(NSString *) username andPass:(NSString *)pass andSnapID:(NSString *)snapID andComp:(void (^)(BOOL,id)) onCompletion;
+(void) removeFriend:(NSString *) username andPass:(NSString *)pass andFriend:(NSString *)friend andFriendType:(int) type andComp:(void (^)(BOOL,id)) onCompletion;


@end