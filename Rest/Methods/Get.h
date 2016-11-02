//
// Created by joshua on 7/20/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPHelper.h"
#import "UserInfo.h"

@class Snap;

//GET METHODS
//@"helloGet": [NSString stringWithFormat:@"%@helloGet",baseURL],
//router.get("/login/:username/:password",function(req,res)
//router.get("/getPictureInfo/:snapID",function(req,res){
//router.get("/getLastTimeFriendsUpdatedStory/:username/:password/:lastTimeChecked",function(req,res){
//router.get("/getContent/:username/:password/:snapID",function(req,res){
//router.get("/queryWithProjection/:username/:password/:queryPayload/:projection",function(req,res) {
//router.get("/query/:username/:password/:queryPayload",function(req,res){
@interface Get : NSObject

+(void) helloGet:(void (^)(BOOL,id)) onCompletion;
+(void) getContentInfo:(NSString *)snapID withComp:(void (^)(BOOL,Snap *)) onCompletion;
+(void) login:(NSString *)username andPass:(NSString *)password withComp:(void (^)(BOOL,Snap *)) onCompletion;
+(void) getListOfLastUpdatedStories:(NSString *)username andPass:(NSString *) pass withComp:(void (^)(BOOL,id)) onCompletion;
+(void) getSnapListForUser:(UserInfo *)user withComp:(void (^)(BOOL,id)) onCompletion;
+(void) getContent:(NSString *) username withPass:(NSString *) pass forSnap:(Snap *)snap withComp:(void (^)(BOOL,id)) onCompletion;
+(void) queryWithProjection:(NSString *) username
                   withPass:(NSString *) pass andQuery:(NSString *)query
            withProjection:(NSString *) projection
                   withComp:(void (^)(BOOL,id)) onCompletion;
+(void) query:(NSString *) username
                   withPass:(NSString *)pass
                    andQuery:(NSString *)query
     withComp:(void (^)(BOOL,id)) onCompletion;

+ (void)findUsers:(NSString *)text withCompletion:(void (^)(BOOL, id))onCompletion;

+ (void)getFriendList:(void (^)(BOOL, NSArray *))pFunction;
@end