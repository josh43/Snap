//
// Created by joshua on 7/20/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "Post.h"
#import "Command.h"

//POST METHODS
//router.post("/sendSnap",upload.single("contentFile"), function (req, res) {
//router.post("/picWasScreenShotted/:objID/:byUser",function(req,res){
//router.post("/picWasSeen/:objID/:byUser",function(req,res){
//router.post("/storySnap",upload.single("contentFile"), function (req, res) {
//router.post("/register/:username/:password/:email/:firstname/:lastname", function (req, res) {
//router.post("/addFriend/:username/:friendName/:type",function(req,res){
//router.post("/helloPost",function(req,res){

@implementation Post {

}
+(NSURLSessionTask * ) getBasicTaskWithStringURL:(NSString *) stringURL
                               completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler{
        NSURL* url = [NSURL URLWithString:[stringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:completionHandler];
    return task;
}


+ (void)helloPost:(void (^)(BOOL, id))onCompletion {
    NSString * final = [HTTPHelper urlForKey:@"helloPost"];
    if(debugging){logMethod()NSLog(@"Final url is : %@",final);}
    NSURLSessionTask  * task = [Post getBasicTaskWithStringURL:final completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        basicHandler()

    }];
    [task resume];


}



+ (void)screenShot:(NSString *)snapID byUser:(NSString *)user
          withComp:(void (^)(BOOL, id))onCompletion {
    NSString * base = [HTTPHelper urlForKey:@"picWasScreenShotted"];
    NSString * final = [NSString stringWithFormat:@"%@/%@/%@",base,snapID,user];
    if(debugging){logMethod()NSLog(@"Final url is : %@",final);}
    NSURLSessionTask  * task = [Post getBasicTaskWithStringURL:final completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            basicHandler()
    }];

    [task resume];
}

//router.post("/action/:actionType/:user/:ownerOfSnap/:snapID",function(req,res){



+(void) sendAction:(int)type byUser:(NSString *)username toOwner:(NSString *)owner withSnap:(Snap *) theSnap
          withComp:(void (^)(BOOL,id)) onCompletion{
    
    NSString * base = [HTTPHelper urlForKey:@"action"];
   
  
    
    NSString * final = [NSString stringWithFormat:@"%@/%i/%@/%@/%@",base,type,username,owner,theSnap.snapID];
    if(debugging){logMethod()NSLog(@"Final url is : %@",final);}
    NSURLSessionTask  * task = [Post getBasicTaskWithStringURL:final completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        basicHandler()
    }];
    
    [task resume];
}


+ (void)picSeen:(NSString *)snapID byUser:(NSString *)user
       withComp:(void (^)(BOOL, id))onCompletion {
    NSString * base = [HTTPHelper urlForKey:@"picWasSeen"];
    NSString * final = [NSString stringWithFormat:@"%@/%@/%@",base,snapID,user];
    if(debugging){logMethod()NSLog(@"Final url is : %@",final);}
    NSURLSessionTask  * task = [Post getBasicTaskWithStringURL:final completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        basicHandler()
    }];

    [task resume];
}

+ (void)userRegister:(NSString *)username withPass:(NSString *)pass
andEmail:(NSString *)email andFirstname:(NSString *)firstname
andLastname:(NSString *)lastname withComp:(void (^)(BOOL, id))onCompletion {
    NSString * base = [HTTPHelper urlForKey:@"register"];
    NSString * final = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@",base,username,pass,email,firstname,lastname];
    if(debugging){logMethod()NSLog(@"Final url is : %@",final);}

    NSURL* url = [NSURL URLWithString:[final stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.timeoutInterval = 5;

    [urlRequest setHTTPMethod:@"POST"];

    NSURLSessionTask  * task = [[NSURLSession sharedSession]
            dataTaskWithRequest:urlRequest
              completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                  basicHandler()

              }];


    [task resume];
}

+ (void)addFriend:(NSString *)username friendName:(NSString *)friendName
       friendType:(int)type withComp:(void (^)(BOOL, id))onCompletion {
    NSString * base = [HTTPHelper urlForKey:@"addFriend"];
    NSString * final = [NSString stringWithFormat:@"%@/%@/%@/%i",base,username,friendName,type];
    if(debugging){logMethod()NSLog(@"Final url is : %@",final);}
    NSURLSessionTask  * task = [Post getBasicTaskWithStringURL:final completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        basicHandler()

    }];
    
    [task resume];
}
+ (void)sendSnap:(Snap *)toSend
       toFriends:(NSMutableArray<Friend *> *)friendList orStringFriends:(NSMutableArray<NSString *> *)stringFriends withComp:(void (^)(BOOL, id))onCompletion {
    NSDictionary  * friendDict = [Post getFriendListPayload:friendList orFriends:stringFriends];
    UserInfo * userInfo  = [SnapRead getUserInfo];
    NSString * owner = userInfo.username;
    NSDictionary  * infoDict = [Post getInfoPayload:toSend.length andtype:toSend.snapType andcontentType:toSend.content.contentType withOwner:owner];
    NSDictionary * params = @{@"userList" : friendDict , @"info":infoDict};

    NSMutableDictionary * mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString * base = [HTTPHelper urlForKey:@"sendSnap"];
    NSString * final = [NSString stringWithFormat:@"%@",base];
    if(debugging){logMethod()NSLog(@"Final url is : %@ and info and params %@",final,mutableParams);}
    [Post postHTTP:final withPicture:toSend.content andParams:mutableParams andCompletion:^(BOOL succ, id res) {
        // update the database
        NSLog(@"server response from send snap : %@",res);
        if(succ) {
            if(res[@"Success"]) {
                // since you already have the object you can just directly update it how nice :)
                
                toSend.snapID = (res[@"Success"])[@"_id"];
            }
        }
        onCompletion(succ,res);
    }];

}
+ (void)sendSnap:(Snap *)toSend
            from:(NSString *) sender
       toFriends:(NSMutableArray<Friend *> *)friendList
 orStringFriends:(NSMutableArray<NSString *> *)stringFriends withComp:(void (^)(BOOL, id))onCompletion {
    NSDictionary  * friendDict = [Post getFriendListPayload:friendList orFriends:stringFriends];
    NSString * owner = sender;
    NSDictionary  * infoDict = [Post getInfoPayload:toSend.length andtype:toSend.snapType andcontentType:toSend.content.contentType withOwner:owner];
    NSDictionary * params = @{@"userList" : friendDict , @"info":infoDict};

    NSMutableDictionary * mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString * base = [HTTPHelper urlForKey:@"sendSnap"];
    NSString * final = [NSString stringWithFormat:@"%@",base];
    if(debugging){logMethod()NSLog(@"Final url is : %@ and info and params %@",final,mutableParams);}
    [Post postHTTP:final withPicture:toSend.content andParams:mutableParams andCompletion:^(BOOL succ, id res) {
        // update the database
        NSLog(@"server response from send snap : %@",res);
        if(succ) {
            if(res[@"Success"]) {
                // since you already have the object you can just directly update it how nice :)

                toSend.snapID = (res[@"Success"])[@"_id"];
            }
        }
        onCompletion(succ,res);
    }];

}

+ (void)storySnapByUsername:(NSString *)person
                    andSnap:(Snap *)snap
                   withComp:(void (^)(BOOL, id))onCompletion {


    NSDictionary  * infoDict = [Post getInfoPayload:snap.length andtype:[NSNumber numberWithInt:SNAP_STORY_TYPE] andcontentType:snap.content.contentType withOwner:person];
    NSDictionary * params = @{@"info":infoDict};
    NSMutableDictionary * mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];

    NSString * base = [HTTPHelper urlForKey:@"storySnap"];
    NSString * final = [NSString stringWithFormat:@"%@",base];
    if(debugging){logMethod()NSLog(@"Final url is : %@ and apamars %@",final,params);}
    [Post postHTTP:final withPicture:snap.content andParams:mutableParams andCompletion:^(BOOL succ, id res) {
        // update the database
        if(succ) {
            if(res) {
                snap.snapID = (res[@"Success"])[@"_id"];
            }
        }
        onCompletion(succ,res);
    }];

}
+ (void)storySnapbyUser:(UserInfo *)user
          andSnap:(Snap *)snap withComp:(void (^)(BOOL, id))onCompletion {
    NSString * owner = [SnapRead getUserInfo].username;
    [self storySnapByUsername:user.username andSnap:snap withComp:^(BOOL i, id o) {
        onCompletion(i,o);
    }];
}




+(NSDictionary *) getInfoPayload:(NSNumber *) snapLength andtype:(NSNumber *)snapType
                                andcontentType:(NSNumber *)contentType withOwner:(NSString *)owner{
    return @{@"snapLength":snapLength, @"snapType":snapType, @"contentType":contentType,@"owner":owner};

}
+(NSDictionary *) getFriendListPayload:(NSMutableArray<Friend *> *)friends
                             orFriends:(NSMutableArray<NSString *> *)stringFriends{
    NSMutableArray  * convert = [[NSMutableArray  alloc]init];

    
    
    if(friends){
        for(Friend  * f in friends){
             [convert addObject:f.username];
        }

    }else{
        convert = stringFriends;
    }

    return @{@"users":convert};

}
// I got most of this postHTTP method from a post on stack overflow
// after trying myself for a long time with nothing working I decided to just use their code :D
+(void)postHTTP:(NSString *)actualURL
    withPicture:(Content *) content
      andParams:(NSMutableDictionary *) params
  andCompletion:(void(^)(BOOL,id)) onCompletion{


// the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";

// string constant for the post parameter contentFile
    NSString* FileParamConstant = @"contentFile";

// the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:[actualURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];

// create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];

// set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];

// post body
    NSMutableData *body = [NSMutableData data];

// add params (all params are strings)
    for (NSString *param in params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        // convert to json
        NSError * err= nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject:[params objectForKey:param] options:0 error:&err];
        NSString * toAppend = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        if(err){
            NSLog(@"Error converting into json");
            // sending empty data.. whatvs
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];

        }else{
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", toAppend] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }


    // Send the img or video data
    NSData * data;
    if([content.contentType intValue] == IMAGE_CONTENT) {
        data= content.content;
    }else{
        data = [NSData dataWithContentsOfURL:[content getURL]];
    }

    if(debugging && data == nil){
        NSLog(@"This is likely an error, the content your trying to uplaod is nil");
    }



    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: image.jpeg \r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];

        // get the data
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];

// setting the body of the post to the reqeust
    [request setHTTPBody:body];

   
// set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", ( int)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];

// set URL
    [request setURL:requestURL];

    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 // check error and/or handle response here
                                                                 BasicHandler  * handler = [[BasicHandler  alloc]init];
                                                                 if (error) {
                                                                     [handler acceptURL:nil
                                                                               withData:nil
                                                                              withBlock:onCompletion];
                                                                 } else {
                                                                     [handler acceptURL:response
                                                                               withData:data
                                                                              withBlock:onCompletion];
                                                                 }
                                                             }];

    [task resume];



}

+(void)postHTTP:(NSString *)actualURL
      andParams:(NSDictionary *) params
  andCompletion:(void(^)(BOOL,id)) onCompletion{
    
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter contentFile
   // NSString* FileParamConstant = @"contentFile";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:[actualURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    for (NSString *param in params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        // convert to json
        NSError * err= nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject:[params objectForKey:param] options:0 error:&err];
        NSString * toAppend = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        if(err){
            NSLog(@"Error converting into json");
            // sending empty data.. whatvs
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
        }else{
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", toAppend] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];

    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", ( int)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 // check error and/or handle response here
                                                                 BasicHandler  * handler = [[BasicHandler  alloc]init];
                                                                 if (error) {
                                                                     [handler acceptURL:nil
                                                                               withData:nil
                                                                              withBlock:onCompletion];
                                                                 } else {
                                                                     [handler acceptURL:response
                                                                               withData:data
                                                                              withBlock:onCompletion];
                                                                 }
                                                             }];
    
    [task resume];
    
    
    
}




@end