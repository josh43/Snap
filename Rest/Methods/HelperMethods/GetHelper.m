//
// Created by joshua on 7/20/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "GetHelper.h"
#import "SnapCreate.h"
#import "Snap.h"
#import "SnapRead.h"
#import "HTTPHelper.h"
#import "Utility.h"
#import "Content.h"


@implementation GetHelper {

}

+ (Snap *)createSnapWithResponse:(NSDictionary *)dictionary andMeta:(NSDictionary *)meta {
    // CREATE IT WITHOUT INSERTING INTO DATASTORE!!
    logMethod()
    NSDate * date = [HTTPHelper stringToDate:meta[@"date"]];
    NSString * id = dictionary[@"_id"];
    NSString * sentBy = meta[@"uploadedBy"];
    int snapType = [(NSNumber *) meta[@"contentType"] intValue];
    if(snapType == SNAP_USER_SENT_TYPE){
        snapType = SNAP_PERSONAL_TYPE;
    }
    int dataType = [(NSNumber *) meta[@"dataFormat"] intValue];
    
    float length = [(NSNumber *) meta[@"length"] floatValue];

    Friend * userWhoSent = [SnapRead findFriendWithUsername:sentBy];

    if(!debugging){
        if(userWhoSent == nil){
            NSLog(@"This is probably an error we could not find the user who sent this snap chat :(");
            return nil;
        }
    }
    Content * cont = [SnapCreate createContentWith:nil andStringURL:nil withType:dataType];

    Snap * toReturn = [SnapCreate createSnapWithDate:date andLength:length andSnapType:snapType andSnapID:id andContent:cont andUser:userWhoSent];

    return toReturn;
}


//array of {"snapID":snapID}
// returns array of username,date,username,date
// a[0] == typeof(NSString) a[1] == typeof(NSDate and repat the cycle
+ (NSMutableArray *)createListOfStoryUpdates:(NSArray *)array {
    logMethod()
    NSMutableArray * toReturn = [[NSMutableArray alloc]init];
    for(NSDictionary * pair in array){
        // convert date
        if(debugging){
            NSLog(@"Converting %@",pair);
        }

        

        [toReturn addObject:pair[@"snapID"]];
        

    }
    return toReturn;
}

+ (NSString *)downloadMovieToFile:(NSData *)data {
    NSArray *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [documentsDirectory objectAtIndex:0];

    NSString *videoName = [NSString stringWithFormat:@"%@story.mov",[NSProcessInfo processInfo].globallyUniqueString];
    NSString *videoPath = [docPath stringByAppendingPathComponent:videoName];
    NSURL *outputURL = [NSURL fileURLWithPath:videoPath];
    [data writeToURL:outputURL atomically:YES];

    return [outputURL absoluteString];

}

+ (void)downloadWithRequest:(NSURL *)request withCompletion:(void (^)(BOOL, id))onCompletion{
    NSURLSession  * session = [NSURLSession sharedSession];
   NSURLSessionTask * download = [session downloadTaskWithURL:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {

       if(location == nil || error){
           NSLog(@"Error failed downloading with url %@ and err %@",request,error);
           return;
       }
       
       NSLog(@"Session %@ download task %@ finished downloading to URL %@\n",
               session, response, location);

       NSError *err = nil;
       NSFileManager *fileManager = [NSFileManager defaultManager];
       //NSString *cacheDir = [[NSHomeDirectory()
            ///   stringByAppendingPathComponent:@"Library"]
             //  stringByAppendingPathComponent:@"Caches"];
      // NSURL *cacheDirURL = [NSURL fileURLWithPath:cacheDir];
       // getting an error moving the url..... laaame
       NSURL * url;
       createUniqueMovieUrl(url);
       
       if ([fileManager moveItemAtURL:location
                                toURL:url
                                error: &err]) {

           onCompletion(YES,[url absoluteString]);
           /* Store some reference to the new URL */
       } else {
           if(debugging){
               NSLog(@"Error moving the file url :( with err %@",error);
           }
           onCompletion(NO,nil);
       }
   }];
    [download resume];
}
@end