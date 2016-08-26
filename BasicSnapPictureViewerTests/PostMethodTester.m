//
//  PostMethodTester.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/21/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Rest.h"
#import "CoreCreate.h"
#import "Content.h"
#import "Utility.h"
#import "SnapCreate.h"
#import "Snap.h"
#import "SnapRead.h"

@interface PostMethodTester : XCTestCase

@end

@implementation PostMethodTester

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

-(void)createJoshUser{
    UserInfo  * me = [SnapRead getUserInfo];
    if(me == nil){
        me = [SnapCreate createUserWithName:@"Joshua" andPasword:@"password"];
    }
}
- (void)testPostHTTPNoBodyShouldWork {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTestExpectation *addFriendExp = [self expectationWithDescription:@"addFriendExp request open"];
    XCTestExpectation *seenPictureExp = [self expectationWithDescription:@"seenPictureExp request open"];
    XCTestExpectation *screenShottedPictureExp = [self expectationWithDescription:@"screenShottedPictureExp request open"];
    
    XCTAssertEqual(1 + 1, 2, "one plus one should equal two");
    //5790690a0eb3b6301e0aaf96 is trailer park boys image
    // registering should only work first test so it will likely be removed.
   

    [Post addFriend:@"Dookatie" friendName:@"Falcon" friendType:2 withComp:^(BOOL success, id result) {
        XCTAssertTrue(success);
        NSLog(@"On adding friend %@",result);
        [addFriendExp fulfill];

    }];
    [Post screenShot:@"579080a70eb3b631a27f687d" byUser:@"Dookatie" withComp:^(BOOL success, id result) {
        XCTAssertTrue(success);
        NSLog(@"On screenShot  %@",result);
        [screenShottedPictureExp fulfill];
    }];
    [Post picSeen:@"579080a70eb3b631a27f687d" byUser:@"Dookatie" withComp:^(BOOL success, id result) {
        XCTAssertTrue(success);
        NSLog(@"On picSeen %@",result);
        [seenPictureExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:8 handler:^(NSError *error) {
        NSLog(@"Timed out\n");
        
    }];
    
}
-(void)testPostHTTPBodyShouldWork{
    XCTestExpectation *picSnapEx = [self expectationWithDescription:@"picSnap request open"];
    XCTestExpectation *vidSnapEx= [self expectationWithDescription:@"vidSnap request open"];
    XCTestExpectation *picStoryEx= [self expectationWithDescription:@"picStory request open"];
    XCTestExpectation *vidStoryEx= [self expectationWithDescription:@"vidStory request open"];

    UserInfo  * me = [SnapRead getUserInfo];
    if(me == nil){
        me = [SnapCreate createUserWithName:@"Falcon" andPasword:@"password"];
    }

    UIImage * leahy = [UIImage imageNamed:@"leahy"];
    Content *pictureContent = [CoreCreate createObject:@"Content"];
    Content *videoContent = [CoreCreate createObject:@"Content"];
    if(!leahy){
        NSLog(@"leahy was empty boys");
        exit(0);
    }

    videoContent.contentType = [NSNumber numberWithInt:(VIDEO_CONTENT)];
    videoContent.content = nil;

    // maybe this works prolly not DOH :(
    NSMutableArray <NSString *> * stringBUDDIES = [NSMutableArray arrayWithArray:@[@"Falcon",@"Joshua",@"Mark",@"Auto"]];
    

    getResource(videoContent.url,@"trailerParkClip",@"mov");
    videoContent.url = [NSURL fileURLWithPath:videoContent.url].absoluteString;
    
    Snap * vidSnap =[SnapCreate createUserSendSnapChat:[NSDate date]
                                        andContentType:VIDEO_CONTENT
                                             andLength:8.0f andUser:me withFriendList:stringBUDDIES];
    
    


    //[NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:cdh.context];
    pictureContent.contentType = [NSNumber numberWithInt:(IMAGE_CONTENT)];
    pictureContent.content = UIImageJPEGRepresentation(leahy, 1.0); // dont sell jim leahy short
    Snap * picSnap = [SnapCreate createUserStorySnapWithDate:[NSDate date] andLength:5.0f andContent:pictureContent andUser:me];



    // PICTURE SNAP
    // im sending it to me this will be good for debugging
    [Post sendSnap:picSnap toFriends:nil orStringFriends:stringBUDDIES withComp:^(BOOL success, id result) {
        XCTAssert(success);
        NSLog(@"Printing the results of sending picture!!! \n %@",result);
        [picSnapEx fulfill];

    }];

    // VIDEO SNAP
    // im sending it to me this will be good for debugging
    [Post sendSnap:vidSnap toFriends:nil orStringFriends:stringBUDDIES withComp:^(BOOL success, id result) {
        XCTAssert(success);
        NSLog(@"Printing results of sending video!!! \n %@",result);
        [vidSnapEx fulfill];
    }];

    [Post storySnapbyUser:me andSnap:picSnap withComp:^(BOOL success, id result) {
        XCTAssert(success);
        NSLog(@"Printing the results of posting the picture!!! \n %@",result);
        [picStoryEx fulfill];
    }];

    [Post storySnapbyUser:me andSnap:vidSnap withComp:^(BOOL success, id result) {
        XCTAssert(success);
        NSLog(@"Printing the results of posting the video!!! \n %@",result);
        [vidStoryEx fulfill];
    }];




    [self waitForExpectationsWithTimeout:8 handler:^(NSError *error) {
        NSLog(@"Timed out\n");

    }];
}

-(void)testPostHTTPShouldFail{
    XCTestExpectation *registeExp = [self expectationWithDescription:@"registeExp request open"];

    [Post userRegister:@"Joshua" withPass:@"password" andEmail:@"awesome@awesome.com" andFirstname:@"bill" andLastname:@"guy" withComp:^(BOOL success, id result) {
        NSLog(@"On registering %@\n",result);
        XCTAssertTrue(!success);
        [registeExp fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:8 handler:^(NSError *error) {
        NSLog(@"Timed out\n");
        
    }];
}
/*
-(void)testFillJoshSnapInbox{
    XCTestExpectation *picSnapEx = [self expectationWithDescription:@"picSnap request open"];


    UserInfo  * me = [SnapRead getUserInfo];
    if(me == nil){
        me = [SnapCreate createUserWithName:@"Joshua" andPasword:@"password"];
    }

    Friend * falcon = [SnapRead findFriendWithUsername:@"Falcon"];
    if(falcon == nil){
        // register him
        falcon = [SnapCreate createUserWithName:@"Falcon" andPasword:@"password"];
        [Post userRegister:@"Falcon" withPass:@"password" andEmail:@"falcon@email.com" andFirstname:@"falcon" andLastname:@"awesome" withComp:^(BOOL i, id o) {

        }];
    }

    UIImage * leahy = [UIImage imageNamed:@"leahy"];
    Content *pictureContent = [CoreCreate createObject:@"Content"];
    Content *videoContent = [CoreCreate createObject:@"Content"];
    if(!leahy){
        NSLog(@"leahy was empty boys");
        exit(0);
    }

    videoContent.contentType = [NSNumber numberWithInt:(VIDEO_CONTENT)];
    videoContent.content = nil;

    // maybe this works prolly not DOH :(
    NSMutableArray <NSString *> * stringBUDDIES = [NSMutableArray arrayWithArray:@[@"Falcon",@"Joshua",@"Mark",@"Auto"]];


    getResource(videoContent.url,@"trailerParkClip",@"mov");
    videoContent.url = [NSURL fileURLWithPath:videoContent.url].absoluteString;


    [self waitForExpectationsWithTimeout:8 handler:^(NSError *error) {
        NSLog(@"Timed out\n");

    }];

    //[NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:cdh.context];
    pictureContent.contentType = [NSNumber numberWithInt:(IMAGE_CONTENT)];
    pictureContent.content = UIImageJPEGRepresentation(leahy, 1.0); // dont sell jim leahy short
    Snap * picSnap; [[Snap alloc]init];
    picSnap.content = pictureContent;
    picSnap.dateSent = [NSDate date];
    picSnap.friend = falcon;
    picSnap.

    Snap * vidSnap;

    // PICTURE SNAP
    // im sending it to me this will be good for debugging
    for(int i = 0; i < 5; i++) {

            [Post sendSnap:(i%2 ? picSnap : vidSnap)  toFriends:nil orStringFriends:stringBUDDIES withComp:^(BOOL success, id result) {
                XCTAssert(success);
                NSLog(@"Printing the results of sending picture!!! \n %@", result);
                [picSnapEx fulfill];

            }];

    }
    [self waitForExpectationsWithTimeout:8 handler:^(NSError *error) {
        NSLog(@"Timed out\n");

    }];
}
*/

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
