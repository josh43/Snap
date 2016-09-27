//
// Created by joshua on 7/20/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "Get.h"
#import "Utility.h"
#import "Snap.h"
#import "Content.h"

#import "SnapCreate.h"
#import "SnapRead.h"
#import <Foundation/Foundation.h>
#import "GetHelper.h"

//GET METHODS
//@"helloGet": [NSString stringWithFormat:@"%@helloGet",baseURL],
//router.get("/login/:username/:password",function(req,res)
//router.get("/getPictureInfo/:snapID",function(req,res){
//router.get("/getLastTimeFriendsUpdatedStory/:username/:password/:lastTimeChecked",function(req,res){
//router.get("/getContent/:username/:password/:snapID",function(req,res){
//router.get("/queryWithProjection/:username/:password/:queryPayload/:projection",function(req,res) {
//router.get("/query/:username/:password/:queryPayload",function(req,res){

/*
 * pictureInfo
 *
 *  return {
        "_id":new MongoID(),Z
        "filename":fileName,
        "mode":"w",
        chunkSize:1024,

        metadata: {
            uploadedBy: "",
            contentType:-1,
            dataFormat:-1,
            seenBy: [],
            sentTo: [],
            numViews:0,
            lastSeen:"",
            lastSeenBy:"",
            screenShotted:"",
            date:{}
            length:-1.0

        }

    }


  db.fs.files.updateOne({"_id" : ObjectId("5790690a0eb3b6301e0aaf96")},
  {$set:
    {"metadata":
        {"uploadedBy":"Josh",
        "contentType":1,
        "seenBy":["BillyBob"],
        "sentTo":["airbody","billybob"],
        "numViews":2,"lastSeen":"",
        "screenShotted":"",
        "date":{1},
        "length":1.8
        }
       }
      }
      )
 *
 */
@implementation Get {

}
+(NSURLSessionTask * ) getBasicTaskWithStringURL:(NSString *) stringURL
        completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler{
    NSURL* url = [NSURL URLWithString:[stringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];


    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:completionHandler];

    return task;
}
+(void) helloGet:(void (^)(BOOL,id)) onCompletion{
    NSURL* url = [NSURL URLWithString:[[HTTPHelper urlForKey:@"helloGet"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    if(debugging){logMethod()NSLog(@"Final url is : %@",[HTTPHelper urlForKey:@"helloGet"]);}
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BasicHandler * basicHandler = [[BasicHandler  alloc]init];
        if(error){
            [basicHandler acceptURL:nil withData:nil withBlock:onCompletion];
        }else{
            [basicHandler acceptURL:response withData:data withBlock:onCompletion];
        }


    }];

        [task resume];
}
+(void) helloGetSimple:(void (^)(BOOL,id)) onCompletion{
    NSURLSessionTask  * task = [Get getBasicTaskWithStringURL:[HTTPHelper urlForKey:@"helloGet"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BasicHandler * basicHandler = [[BasicHandler  alloc]init];
        if(error){
            [basicHandler acceptURL:nil withData:nil withBlock:onCompletion];
        }else{
            [basicHandler acceptURL:response withData:data withBlock:onCompletion];
        }

    }];
    [task resume];
}

+ (void)getContentInfo:(NSString *)snapID
              withComp:(void (^)(BOOL, Snap *))onCompletion {

    NSString *base = [HTTPHelper urlForKey:@"picInfo"];
    NSString *final = [NSString stringWithFormat:@"%@/%@", base, snapID];
    if(debugging){logMethod()NSLog(@"\nFinal url  getContentInfo is : %@",final);}
    NSURLSessionTask *task = [Get getBasicTaskWithStringURL:final completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BasicHandler *basicHandler = [[BasicHandler alloc] init];
        if(data == nil){
            NSLog(@"Error on getting picture info");
            onCompletion(NO,nil);
        }else{
        [basicHandler acceptURL:response withData:data withBlock:^(BOOL success, id res) {
                if(success){
                    if(debugging){
                        NSLog(@"Got back something successfuly from getContentInfo %@",res);
                    }
                    // its sending it back as an array rookie move
                    NSDictionary  * response = (NSDictionary *)res;
                    NSDictionary * mainInfo = (NSDictionary *)response[@"Success"];
                    NSDictionary  * meta = (NSDictionary *)mainInfo[@"metadata"];
                    // does insert into the store.
                    Snap * toReturn = [GetHelper createSnapWithResponse:mainInfo andMeta:meta];
                    if(toReturn != nil){
                        onCompletion(YES,toReturn);
                    }else{
                        onCompletion(NO,nil);
                    }
                }else{
                    NSLog(@"Error on getting picture info");
                    onCompletion(NO,nil);
                }
        }];
        }

    }];
    [task resume];

}


// returns an array of {"username":DATE,"lastStoryUpdate":DATE}
+ (void)getListOfLastUpdatedStories:(NSString *)username
                            andPass:(NSString *)pass withComp:(void (^)(BOOL, id))onCompletion {
    NSString * base = [HTTPHelper urlForKey:@"storyList"];
    UserInfo  * user = [SnapRead getUserInfo];
    NSString * last;

    if(user.lastServerQuery == nil||  user.lastServerQuery.timeIntervalSinceNow  < -(24 * 60 * 60)){
        user.lastServerQuery = [NSDate dateWithTimeIntervalSinceNow:(-24 * 60 * 60)];
    }
    last= [HTTPHelper dateToString:user.lastServerQuery];
    // always query with a little offset
    user.lastServerQuery = [NSDate dateWithTimeIntervalSinceNow:-60];
    
    NSString * final = [NSString stringWithFormat:@"%@/%@/%@/%@",base,username,pass,last];
    if(debugging){logMethod()NSLog(@"\nFinal url getListOfLastUpdatedStories : %@",final);}
    NSURLSessionTask  * task = [Get getBasicTaskWithStringURL:final completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BasicHandler *basicHandler = [[BasicHandler alloc] init];
        if(data == nil){
            NSLog(@"Error on getting picture info");
            onCompletion(NO,nil);
        }
        [basicHandler acceptURL:response withData:data withBlock:^(BOOL success, id res) {
            if(success){
                if([res isKindOfClass:[NSDictionary class]]){

                    // error
                    if(debugging){
                        NSLog(@"Error on getting story list with %@",res);
                    }
                    onCompletion(NO,nil);

                }else{
                    NSArray * response = (NSArray * )res;
                // does not insert into store..
                // only on completion will it remove from snapInbox.
                
                    NSMutableArray * toReturn = [GetHelper createListOfStoryUpdates:response];
                    if(toReturn != nil){
                        onCompletion(YES,toReturn);
                    }else{
                        onCompletion(NO,nil);
                    }
                }
               
            }else{
                NSLog(@"Error on getting picture info");
                onCompletion(NO,nil);
            }
        }];

    }];
    [task resume];
}
+(void )getSnapListForUser:(UserInfo *)user withComp:(void (^)(BOOL,id)) onCompletion{
    NSString * base = [HTTPHelper urlForKey:@"queryProjection"];

    NSString * query = [NSString stringWithFormat:@"{\"username\":\"%@\"}",user.username];
    NSString * projection = @"{\"snapchats\":1}";
    
    
    NSString * final = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",base,user.username,user.password,query,projection];
    if(debugging){logMethod()NSLog(@"\nFinal url getListOfLastUpdatedStories : %@",final);}
    NSURLSessionTask  * task = [Get getBasicTaskWithStringURL:final completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        BasicHandler *basicHandler = [[BasicHandler alloc] init];
        if(data == nil){
            NSLog(@"Error on getting picture info");
            onCompletion(NO,nil);
        }
        [basicHandler acceptURL:response withData:data withBlock:^(BOOL success, id res) {
            if(success){
                
                NSLog(@"Response on getting snap list is %@",res);
                if([res isKindOfClass:[NSArray  class]]){
                    NSArray  * arr = res;
                    if(arr.count < 1){
                        onCompletion(NO,nil);

                    }else {
                        NSArray *response = (NSArray *) (arr[0][@"snapchats"]);
                        // does not insert into store..
                        // only on completion will it remove from snapInbox.

                        if (response != nil) {
                            onCompletion(YES, response);
                        } else {
                            onCompletion(NO, nil);
                        }
                    }
                }
                
            }else{
                NSLog(@"Error on updating snaps :|");
                onCompletion(NO,nil);
            }
        }];
        
    }];
    [task resume];
}
+ (void)getContent:(NSString *)username withPass:(NSString *)pass
         forSnap:(Snap *)snap withComp:(void (^)(BOOL, id))onCompletion {
    NSString * base;

    NSString * final;
    if([snap.snapType intValue] == SNAP_PERSONAL_TYPE || [snap.snapType intValue] == SNAP_USER_SENT_TYPE){
        base  = [HTTPHelper urlForKey:@"getContent"];
        final = [NSString stringWithFormat:@"%@/%@/%@/%@",base,username,pass,snap.snapID];
    }else{
        base  = [HTTPHelper urlForKey:@"getStoryContent"];
        final = [NSString stringWithFormat:@"%@/%@",base,snap.snapID];

    }
    if(debugging){logMethod()NSLog(@"Final url is : %@",final);}

    if([snap.content.contentType intValue] == IMAGE_CONTENT) {
        NSURLSessionTask *task = [Get getBasicTaskWithStringURL:final completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (response == nil || data == nil) {
                if (debugging) {NSLog(@"Failed to get picture content");}
                onCompletion(NO, nil);
            } else {
                
                id  dict = [HTTPHelper URLToJson:response andData:data];
                //  dict == nil so this should be array
                if(dict == nil){
                    snap.content.hasDownloaded = [NSNumber numberWithBool:YES];
                    snap.content.content = data;
                    snap.hasSeen = [NSNumber numberWithBool:NO];

                    onCompletion(YES, snap);
                }else{
                    if(debugging){NSLog(@"Failed to get image with error %@",dict);}
                    onCompletion(NO, nil);
                }
                
              


            }

        }];
        [task resume];
    }else{ // MOVIE
        NSURL  * url =  [NSURL URLWithString:final];
        [GetHelper downloadWithRequest:url withCompletion:^(BOOL success, id res) {
                if(success){ // yay we downloaded
                    NSString * contentURL = (NSString *)res;
                    snap.content.url = contentURL;
                    snap.content.hasDownloaded = [NSNumber numberWithBool:YES];
                    onCompletion(YES,snap);
                }else{
                    // failed :|
                    onCompletion(NO,nil);
                }
        }];
    }
}
+(void) login:(NSString *)username andPass:(NSString *)password
     withComp:(void (^)(BOOL,Snap *)) onCompletion{
    NSString * base = [HTTPHelper urlForKey:@"login"];
    NSString * final = [NSString stringWithFormat:@"%@/%@/%@",base,username,password];
    if(debugging){logMethod()NSLog(@"Final url is : %@",final);}

    NSURL* url = [NSURL URLWithString:[final stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.timeoutInterval = 5;

    [urlRequest setHTTPMethod:@"GET"];

    NSURLSessionTask  * task = [[NSURLSession sharedSession]
            dataTaskWithRequest:urlRequest
              completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                  basicHandler()

              }];

    [task resume];
}
+ (void)queryWithProjection:(NSString *)username withPass:(NSString *)pass
                   andQuery:(NSString *)query withProjection:(NSString *)projection
                   withComp:(void (^)(BOOL, id))onCompletion {
    NSString * base = [HTTPHelper urlForKey:@"queryProjection"];
    NSString * final = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",base,username,pass,query,projection];
    if(debugging){logMethod()NSLog(@"Final url is : %@",final);}
    NSURLSessionTask  * task = [Get getBasicTaskWithStringURL:final completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        basicHandler() // this will just return your query.. which could be an array of things

    }];

    [task resume];
}

+ (void)query:(NSString *)username withPass:(NSString *)pass
     andQuery:(NSString *)query withComp:(void (^)(BOOL, id))onCompletion {
    NSString * base = [HTTPHelper urlForKey:@"query"];
    NSString * final = [NSString stringWithFormat:@"%@/%@/%@/%@",base,username,pass,query];
    if(debugging){logMethod()NSLog(@"Final url is : %@",final);}
    NSURLSessionTask  * task = [Get getBasicTaskWithStringURL:final completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        basicHandler()

    }];

    [task resume];

}

+ (void)findUsers:(NSString *)text withCompletion:(void (^)(BOOL, id ))onCompletion {
    NSString * base = [HTTPHelper urlForKey:@"findUsers"];
    NSString * final = [NSString stringWithFormat:@"%@/%@",base,text];
    if(debugging){logMethod()NSLog(@"Final for searching friendsurl is : %@",final);}
    NSURLSessionTask  * task = [Get getBasicTaskWithStringURL:final completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        basicHandler()

    }];

    [task resume];
}

+ (void)getFriendList:(void (^)(BOOL, NSArray *))onCompletion {
    UserInfo * me = [SnapRead getUserInfo];
    NSString * query = [NSString stringWithFormat:@"{\"username\":\"%@\"}",me.username];
    NSString * projection = @"{\"friendList\":1}";

    [self queryWithProjection:me.username withPass:me.password andQuery:query withProjection:projection withComp:^(BOOL success, id res) {
        // it should come back as an nssarray
        //"friendList":[{"username":"Falcon","friendType":"2"}]}
        //[{"_id":"579161a1f474252b14d1ef9d","friendList":[{"username":"Falcon","friendType":"2"}]}]
        if(success){
            NSLog(@"Result from query was %@\n",res);
            NSArray * filteredResponse = res;
            if(filteredResponse){
                if(filteredResponse.count >=1){
                    NSArray * friendDict= filteredResponse[0][@"friendList"];
                    if(friendDict){ // so complicated ...
                        onCompletion(YES,friendDict);
                        return;

                    }
                }
            }
        }

        onCompletion(NO,nil);
    }];

}
@end