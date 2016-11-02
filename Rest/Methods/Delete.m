//
// Created by joshua on 7/20/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "Delete.h"
#import "Utility.h"
#import "SnapRead.h"
#import "Friend.h"
//DELETE METHODS
//router.delete("/findOneAndDelete/:username/:password/", function (req, res) {
//router.delete("/deleteSnapFromStory/:username/:password/:snapID", function (req, res) {
//router.delete("/removeFriend/:username/:password/:friendUserName/:friendType", function (req, res) {

@implementation Delete {

}
+(NSURLSessionTask * ) getBasicTaskWithStringURL:(NSString *) stringURL
                               completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler{
NSURL* url = [NSURL URLWithString:[stringURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"DELETE"];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:completionHandler];
    return task;
}


+ (void)helloDelete:(void (^)(BOOL, id))onCompletion {
    NSString * final = [HTTPHelper urlForKey:@"helloDelete"];
    if(debugging){logMethod()NSLog(@"Final url is : %@",final);}
    NSURLSessionTask  * task = [Delete getBasicTaskWithStringURL:final completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        basicHandler()
    }];
    [task resume];
}


+ (void)deleteAccount:(NSString *)username andPass:(NSString *)pass andComp:(void (^)(BOOL, id))onCompletion {

    NSString * base = [HTTPHelper urlForKey:@"deleteAccount"];
    NSString * final = [NSString stringWithFormat:@"%@/%@/%@",base,username,pass];
    if(debugging){logMethod()NSLog(@"Final url is : %@",final);}
    NSURLSessionTask  * task = [Delete getBasicTaskWithStringURL:final completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        basicHandler()

    }];
    [task resume];

}

+ (void)removeSnapFromStory:(NSString *)username andPass:(NSString *)pass
                  andSnapID:(NSString *)snapID andComp:(void (^)(BOOL, id))onCompletion {
    NSString * base = [HTTPHelper urlForKey:@"deleteSnapFromStory"];
    NSString * final = [NSString stringWithFormat:@"%@/%@/%@/%@",base,username,pass,snapID];
    if(debugging){logMethod()NSLog(@"Final url is : %@",final);}
    NSURLSessionTask  * task = [Delete getBasicTaskWithStringURL:final completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        basicHandler()

    }];
    [task resume];
}

+ (void)removeFriend:(NSString *)username andPass:(NSString *)pass
           andFriend:(NSString *)friend andFriendType:(int)type  andComp:(void (^)(BOOL, id))onCompletion {

    NSString * base = [HTTPHelper urlForKey:@"removeFriend"];
    NSString * final = [NSString stringWithFormat:@"%@/%@/%@/%@/%d",base,username,pass,friend,type];
    if(debugging){logMethod()NSLog(@"Final url is : %@",final);}
    NSURLSessionTask  * task = [Delete getBasicTaskWithStringURL:final completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        basicHandler()

    }];
    [task resume];
}


@end