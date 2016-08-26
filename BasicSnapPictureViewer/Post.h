//
// Created by joshua on 7/20/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPHelper.h"

#import "Content.h"
#import "Friend.h"
#import "Snap.h"
#import "UserInfo.h"
#import "Utility.h"
#import "SnapRead.h"
#import "SnapUpdate.h"

//POST METHODS
//router.post("/sendSnap",upload.single("contentFile"), function (req, res) {
//router.post("/picWasScreenShotted/:objID/:byUser",function(req,res){
//router.post("/picWasSeen/:objID/:byUser",function(req,res){
//router.post("/storySnap",upload.single("contentFile"), function (req, res) {
//router.post("/register/:username/:password/:email/:firstname/:lastname", function (req, res) {
//router.post("/addFriend/:username/:friendName/:type",function(req,res){
//router.post("/helloPost",function(req,res){
//router.post("/action/:actionType/:user/:ownerOfSnap/:snapID",function(req,res){

@interface Post : NSObject
+(void) helloPost:(void (^)(BOOL,id)) onCompletion;

+(void) sendSnap:(Snap *)toSend
   toFriends:(NSMutableArray<Friend *> *)friendList orStringFriends:(NSMutableArray<NSString *> *)stringFriends withComp:(void (^)(BOOL,id)) onCompletion;
+(void) screenShot:(NSString *)snapID byUser:(NSString *) user withComp:(void (^)(BOOL,id)) onCompletion;
+(void) picSeen:(NSString *) snapID byUser:(NSString *) user withComp:(void (^)(BOOL,id)) onCompletion;
+(void) storySnapbyUser:(UserInfo *)user
          andSnap:(Snap *)snap withComp:(void (^)(BOOL,id)) onCompletion;
+(void) userRegister:(NSString *) username
                   withPass:(NSString *) pass
        andEmail:(NSString *)email
             andFirstname:(NSString *) firstname
        andLastname:(NSString *) lastname
                   withComp:(void (^)(BOOL,id)) onCompletion;

+ (void)sendSnap:(Snap *)toSend
            from:(NSString *) sender
       toFriends:(NSMutableArray<Friend *> *)friendList
 orStringFriends:(NSMutableArray<NSString *> *)stringFriends withComp:(void (^)(BOOL, id))onCompletion;


+(void) sendAction:(int)type byUser:(NSString *) username toOwner:(NSString *)owner withSnap:(Snap *) theSnap
          withComp:(void (^)(BOOL,id)) onCompletion;

+(void) addFriend:(NSString *) username
     friendName:(NSString *)friendName
     friendType:(int)type
     withComp:(void (^)(BOOL,id)) onCompletion;

+(void)storySnapByUsername:(NSString *)person
        andSnap:(Snap *)snap
        withComp:(void (^)(BOOL, id))onCompletion;
@end