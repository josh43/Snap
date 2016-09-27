//
//  SendAndReceiveSnapTVCTest.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/25/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Content.h"
#import "CoreCreate.h"
#import "SnapCreate.h"
#import "Post.h"
#import "Get.h"
#import "Command.h"

@interface SendAndReceiveSnapTVCTest : XCTestCase

@end

@implementation SendAndReceiveSnapTVCTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}


-(void)testRegisterUsers{
    
    XCTestExpectation *addFriendExp = [self expectationWithDescription:@"Creating user list this is meant to fail"];
    
    [self registerUser:@"Ronna" andPass:@"password"];[self registerUser:@"Joshua" andPass:@"password"];
    [self registerUser:@"Mark" andPass:@"password"];[self registerUser:@"Donnie" andPass:@"password"];
    [self registerUser:@"Bill" andPass:@"password"];[self registerUser:@"Steve" andPass:@"password"];
    
    [self waitForExpectationsWithTimeout:8 handler:^(NSError *error) {
        NSLog(@"Timed out\n");
        
    }];
    
}
-(void)addFriend:(NSString *)me toYou:(NSString *)person{
    [Post addFriend:me friendName:person friendType:3 withComp:^(BOOL i, id o) {
        
    }];
}
-(void)testAddAllFriendsToRonnasFriendList{
    // this should fail
    [self addFriend:@"Ronna" toYou:@"Mark"];[self addFriend:@"Ronna" toYou:@"Joshua"];
    [self addFriend:@"Ronna" toYou:@"Donnie"];[self addFriend:@"Ronnie" toYou:@"Bill"];
    [self addFriend:@"Ronna" toYou:@"Steve"];
}
-(void)testSomeUsersSawRonniesSnapWith{
    XCTestExpectation * sendToAll = [self expectationWithDescription:@"Sending to all users"];
    // change this to (YES|NO) if you want it to be a story snap :))))
    [self sendSnapsToRonnasFriendsisStory:YES andCompletion:^(Snap *snap) {
        XCTAssert(snap);
        if(snap){
            [CommandFactory thisUser:@"Donnie"  SawSnap:snap whoOwnsIt:@"Ronna"]; [CommandFactory thisUser:@"Mark" SawSnap:snap whoOwnsIt:@"Ronna"];
            
            //[CommandFactory thisUser:@"Joshua" SawSnap:snap whoOwnsIt:@"Ronna"];
        }
        [sendToAll fulfill];
    }];
    [self waitForExpectationsWithTimeout:8 handler:^(NSError *error) {
        NSLog(@"Timed out\n");
        
    }];
}
-(void)sendSnapsToRonnasFriendsisStory:(BOOL)story andCompletion:(void (^)(Snap *))onCompletion {
    
    
    NSMutableArray * friendList = [NSMutableArray arrayWithArray:@[@"Donnie",@"Mark",@"Bill",@"Joshua",@"Steve"]];
    
    [self sendSnapFrom:@"Ronna" to:friendList picture:NO isStory:story onCompletion:^(Snap *snap) {
        NSLog(@"On success");
        onCompletion(snap);
        
        
        
    }];
}


// this wont appear on your story or sent snaps..
// because I'm not puting the user field in
-(void)sendSnapFrom:(NSString *)thisPerson
                 to:(NSMutableArray<NSString *> *) freindList
            picture:(BOOL) sendPic
            isStory:(BOOL) story
       onCompletion:(void(^)(Snap *))completion{
    
    
    UIImage *leahy = [UIImage imageNamed:@"leahy"];
    Content *content = [CoreCreate createObject:@"Content"];
    if (!leahy) {
        NSLog(@"leahy was empty boys");
        exit(0);
    }
    
    
    //[NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:cdh.context];
    content.contentType = [NSNumber numberWithInt:(sendPic ? IMAGE_CONTENT : VIDEO_CONTENT)];
    content.content = sendPic ? UIImageJPEGRepresentation(leahy, 1.0) : nil; // dont sell jim leahy short
    if(!sendPic) {
        getResource(content.url,@"trailerParkClip",@"mov");
        content.url = [NSURL fileURLWithPath:content.url].absoluteString;
    }
    
    Snap * snap = [SnapCreate createUserSendSnapChat:[NSDate date] andContentType:content.contentType andLength:7.0f andUser:nil withFriendList:freindList];
    snap.content = content;
    if(!story){
        
        [Post sendSnap:snap from:thisPerson toFriends:nil orStringFriends:freindList withComp:^(BOOL success, id res) {
            
            if(!success){
                return;
            }else{
                Snap * snap = [SnapRead getSnapWithID:res[@"Success"][@"_id"]];
                if(snap) {
                    completion(snap);
                }else{
                    NSLog(@"Error with sending the snap");
                }
            }
            
        }];
        
    }else{
        snap.content = content;
        [Post storySnapByUsername:thisPerson  andSnap:snap withComp:^(BOOL success, id res){
            
            if(!success){
                return;
            }else{
                // error right here story snap is different
                Snap * snap = [SnapRead getSnapWithID:res[@"Success"][@"_id"]];
                if(snap) {
                    completion(snap);
                }else{
                    NSLog(@"Error with sending the snap");
                }
            }
        }];
    }
    
}


-(void)registerUser:(NSString *)username
            andPass:(NSString *)pass{
    [Post userRegister:username withPass:pass andEmail:@"ok@email.com"
          andFirstname:@"awesome" andLastname:@"sauce" withComp:^(BOOL i, id o) {
              
          }];
}
-(void) user:(NSString *)lookedAtSnap withID:(NSString *)snapID whoOwnsIt:(NSString *) owner{
    [CommandFactory thisUser:lookedAtSnap SawSnap:[SnapRead getSnapWithID:snapID] whoOwnsIt:owner];
    
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
