//
// Created by joshua on 7/6/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "SnapTVCTester.h"
#import "AppDelegate.h"
#import "Friend.h"
#import "Snap.h"
#import "Content.h"
#import "CoreCRUD.h"
#import "Utility.h"
#import "SnapCreate.h"
#import "SnapRead.h"
#import "UserInfo.h"


NSMutableArray<NSString *>  * friendList;
@implementation SnapTVCTester {

}
/*
 *
 *  THIS CLASS WAS USED FOR LOCAL TESTING OF THE APP
 */
+ (void)test {

    /*  THIS ALSO TESTS CoreCreate
     *
     */
    friendList = [[NSMutableArray<NSString *> alloc]initWithArray:@[@"Joshua",@"Steve",@"Michael",@"DOMMM",@"Bubbles",@"J-ROC",@"Jim leahy",@"Gerbles",@"Ricky",@"Broseph"]];


//#define JOSH_PHONE


    UserInfo  * userInfo;
    if((userInfo = [SnapRead getUserInfo]) == nil){
#ifdef JOSH_PHONE
        userInfo = [SnapCreate createUserWithName:@"Joshua" andPasword:@"password"];
#else
        userInfo = [SnapCreate createUserWithName:@"Ronna" andPasword:@"password"];
#endif
    }
    AppDelegate  * TheAppDelegate = [[UIApplication sharedApplication] delegate];
    CoreDataHelper *cdh = [TheAppDelegate cdh];

    NSDate * now = [NSDate date];
    NSDate * now1 = [NSDate date];
    NSDate * now2 = [NSDate date];
    NSDate * now3 = [NSDate date];
    // about a weeek ago
    NSDate * AWeekAgo = [NSDate dateWithTimeInterval:-(60*60*24*7) sinceDate:now3];
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDate * hourTen = [calendar dateBySettingHour:10 minute:10 second:10 ofDate:now options:0];
    NSDate * hourTenAndSeconds = [calendar dateBySettingHour:10 minute:10 second:12 ofDate:now options:0];
    NSDate * hourEleven = [calendar dateBySettingHour:11 minute:10 second:10 ofDate:now options:0];


    NSArray *dates = @[now,now1,now2,hourTen,hourTenAndSeconds,hourEleven,AWeekAgo,AWeekAgo,AWeekAgo,AWeekAgo,AWeekAgo,AWeekAgo];
    UserInfo * joshInfo = [SnapRead getUserInfo];
   
    userInfo.lastServerQuery = [NSDate dateWithTimeIntervalSinceNow:-60*360];


    for (unsigned int i = 0; i < friendList.count; i ++) {

        Friend *aFriend  = [SnapCreate createNewFriendWithDisplayName:@"Balla" andFriendType:rand()%4 + 1 withUserName:friendList[i]];


        NSLog(@"Created -> %@ with friend Type %@ with first letter %@",aFriend.username,aFriend.friendType,aFriend.firstLetter);

        UIImage * leahy = [UIImage imageNamed:@"leahy"];
        Content *theContent = [CoreCreate createObject:@"Content"];
        if(!leahy){
            NSLog(@"leahy was empty boys");
            exit(0);
        }
        if(i % 3 == 0){
            theContent.contentType = [NSNumber numberWithInt:(VIDEO_CONTENT)];
            theContent.content = nil;

            // maybe this works prolly not DOH :(

             getResource(theContent.url,@"trailerParkClip",@"mov");
            theContent.url = [NSURL fileURLWithPath:theContent.url].absoluteString;
            Snap * snap = [SnapCreate createSnapWithDate:dates[i] andLength:8
                                             andSnapType:SNAP_PERSONAL_TYPE andSnapID:nil
                                              andContent:theContent andUser:aFriend];

        }else {

            //[NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:cdh.context];
            theContent.contentType = [NSNumber numberWithInt:(IMAGE_CONTENT)];
            theContent.content = UIImageJPEGRepresentation(leahy, 1.0); // dont sell jim leahy short
            Snap * snap = [SnapCreate createSnapWithDate:dates[i] andLength:1 + (rand() % 10)
                                             andSnapType:SNAP_PERSONAL_TYPE andSnapID:nil
                                              andContent:theContent andUser:aFriend];

        }




    }

    // send to all theee friends
    [SnapCreate createUserSendSnapChat:[NSDate dateWithTimeInterval:-60*60*3 sinceDate:[NSDate date]] andContentType:IMAGE_CONTENT andLength:6.0f andUser:userInfo withFriendList:friendList];

    NSPredicate  * preditor = [NSPredicate predicateWithFormat:@"dateSent > %@",AWeekAgo];
    NSPredicate  * preditorTwo = [NSPredicate predicateWithFormat:@"dateSent <= %@",AWeekAgo];

    NSError  * err = nil;
    if(err){
        NSLog(@"NOOO");
    }

    NSArray<Snap *> * results = [CoreRead findObjects:@"Snap" andKeyForEntity:@"dateSent"  andPredicate:preditorTwo andFetchedResultsController:nil useSectionKeyPath:NO];
    // I am also going to test a batch update
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"hasSeen == %@",[NSNumber numberWithBool:NO]];
    NSDictionary * properties = @{ @"hasSeen" : @YES, @"length":@0 };



    //[SnapTVCTester  batchUpdate];

}



@end