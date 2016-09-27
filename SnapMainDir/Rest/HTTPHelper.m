//
// Created by joshua on 7/20/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "HTTPHelper.h"
#import "Utility.h"

#define debugging 1
#define printHTTPMsg(x) if(debugging){NSLog(x);}
static const NSString * baseURL = @"http://localhost:3000/";

@implementation BasicHandler
-(void)acceptURL:(NSURLResponse *)response
        withData:(NSData *)data withBlock:(void (^)(BOOL, id))onCompletion{
    if(response == nil){
        if(debugging) {
            NSLog(@"respone was nil %d %s\n", __LINE__, __FILE__);
        }
        onCompletion(NO,nil);
    }else if(data == nil){
        if(debugging) {
            NSLog(@"data was nil %d %s\n", __LINE__, __FILE__);
        }
        onCompletion(NO,nil);
    }else{
        // It's not always NSDictionary data and this could pass back an NSArray although it casts it to a dictionary
        NSDictionary * jsonData = [HTTPHelper URLToJson:response andData:data];
        if(debugging){NSLog(@"jsonData : %@",jsonData);}
        if(!jsonData){
            onCompletion(NO, nil);
        }
        else if([jsonData isKindOfClass:[NSDictionary class]]){
            if(((NSDictionary *)jsonData)[@"Error"]){
                NSLog(@"error accepting the data %@",jsonData);
                onCompletion(NO,nil);
            }else {
                onCompletion(YES, jsonData);
            }
        }else if([jsonData isKindOfClass:[NSArray class]]){
            onCompletion(YES, jsonData);
        }else{
            onCompletion(NO, nil);

        }
        
        
    }
}
@end
@implementation HTTPHelper


static NSDictionary * dict =nil;

    


+(NSString *)urlForKey:(NSString *) key{
    if(!dict){
        [self initializeDict];
    }
    
    if(dict[key] == nil){
        NSLog(@"ERROR you need to redit the dictionary for key %@\n",key);
        exit(0);
    }
    return [NSString stringWithFormat:@"%@/%@",baseURL,dict[key]];
    
}

+(void)initializeDict{
    //GET METHODS
    //@"helloGet": [NSString stringWithFormat:@"%@helloGet",baseURL],
    //router.get("/login/:username/:password",function(req,res)
    //router.get("/getPictureInfo/:snapID",function(req,res){
    //router.get("/getLastTimeFriendsUpdatedStory/:username/:password/:lastTimeChecked",function(req,res){
    //router.get("/getContent/:username/:password/:snapID",function(req,res){
    //router.get("/queryWithProjection/:username/:password/:queryPayload/:projection",function(req,res) {
    //router.get("/query/:username/:password/:queryPayload",function(req,res){
    //router.get("/getSnapFromInbox/:username/:password/:snapID",function(req,res){
    //router.get("/getStoryContent/:snapID",function(req,res){


    
    //POST METHODS
    //router.post("/sendSnap",upload.single("contentFile"), function (req, res) {
    //router.post("/picWasScreenShotted/:objID/:byUser",function(req,res){
    //router.post("/picWasSeen/:objID/:byUser",function(req,res){
    //router.post("/storySnap",upload.single("contentFile"), function (req, res) {
    //router.post("/register/:username/:password/:email/:firstname/:lastname", function (req, res) {
    //router.post("/addFriend/:username/:friendName/:type",function(req,res){
    //router.post("/helloPost",function(req,res){
    //router.post("/action/:actionType/:user/:ownerOfSnap/:snapID", function(req,res){
    
    
    



    //DELETE METHODS
    //router.delete("/helloDelete", function (req, res) {
    //router.delete("/findOneAndDelete/:username/:password/", function (req, res) {
    //router.delete("/deleteSnapFromStory/:username/:password/:snapID", function (req, res) {
    //router.delete("/removeFriend/:username/:password/:friendUserName/:friendType", function (req, res) {

    dict = @{// BEGIN GET
             @"login"                   :@"login",
             @"getPictureInfo"          :@"getPictureInfo",
             @"lastUpdate"              :@"getLastTimeFriendsUpdatedStory",
             @"getContent"              :@"getContent",
             @"login"                   :@"login",
             @"queryProjection"         :@"queryProjection",
             @"query"                   :@"query",
             @"findUsers"               :@"findUsers",
             @"helloGet"                :@"helloGet",
             @"storyList"               :@"storyList",
             @"getStoryContent"         :@"getStoryContent",
             @"getSnapFromInbox"        :@"getSnapFromInbox",
             // BEGIN POST
             @"sendSnap"                :@"sendSnap",
             @"picWasScreenShotted"     :@"picWasScreenShotted",
             @"picWasSeen"              :@"picWasSeen",
             @"storySnap"               :@"storySnap",
             @"register"                :@"register",
             @"addFriend"               :@"addFriend",
             @"helloPost"               :@"helloPost",
             @"action"                  :@"action",
             // BEGIN DELETE
             @"helloDelete"             :@"helloDelete",
             @"findOneAndDelete"        :@"findOneAndDelete",
             @"deleteSnapFromStory"     :@"deleteSnapFromStory",
             @"removeFriend"            :@"removeFriend",
         };
    
}
+(id )URLToJson:(NSURLResponse *)resp
                   andData:(NSData *)data {
    
    NSError *err = nil;
    id toReturn;
    if (resp == nil) {
        return nil;
    } else {
        toReturn = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if (err) {
            return nil;
        } else {
            return toReturn;
        }
    }
}
+ (NSArray *)URLToArray:(NSURLResponse *)resp
                andData:(NSData *)data {
    NSError *err = nil;
    NSArray *arr;
    if (resp == nil) {
        return nil;
    } else {
        arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if (err) {
            // say thiers an err
            return nil;
        } else {
            return arr;
        }
    }
}


+ (NSDate *)stringToDate:(NSString *)str {
    
    if([str isEqualToString:@""]){
        return nil;
    }else{
        //ZZZZ is time offset
        
        
        NSDateFormatter  * formatterThree = [[NSDateFormatter alloc]init];
        formatterThree.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        
        NSDate *  d3 = [formatterThree dateFromString:str];
        return d3;
    }
    
}


+ (NSString *)dateToString:(NSDate *)date {
    //ZZZZ is time offset
    NSDateFormatter  * formatterThree = [[NSDateFormatter alloc]init];
    formatterThree.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    NSString  *  d3 = [formatterThree stringFromDate:date];
    return d3;
    
    
}
@end