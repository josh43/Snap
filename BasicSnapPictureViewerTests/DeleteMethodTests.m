//
//  DeleteMethodTests.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/21/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SnapRead.h"
#import "SnapCreate.h"
#import "Content.h"
#import "Utility.h"
#import "Post.h"
#import "Delete.h"
#import "UserInfo.h"
#import "Snap.h"


@interface DeleteMethodTests : XCTestCase

@end

@implementation DeleteMethodTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// do all the same post methods just with added deletes on succes
// ITS NOT ACTUALLY DELETING 
- (void)testExampleUploadAndDeleteContent {
  
    XCTestExpectation *picStoryEx= [self expectationWithDescription:@"picStory request open"];
    XCTestExpectation *vidStoryEx= [self expectationWithDescription:@"vidStory request open"];
    XCTestExpectation *picStoryDeleteEx= [self expectationWithDescription:@"picStory delete request open"];
    XCTestExpectation *vidStoryDeleteEx= [self expectationWithDescription:@"vidStory delete request open"];
    
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
    
    
    getResource(videoContent.url,@"trailerParkClip",@"mov");
    videoContent.url = [NSURL fileURLWithPath:videoContent.url].absoluteString;
    
    Snap * vidSnap =[SnapCreate createUserStorySnapWithDate:[NSDate date]
                                                  andLength:8.0f andContent:videoContent andUser:me];
    
    
    
    
    //[NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:cdh.context];
    pictureContent.contentType = [NSNumber numberWithInt:(IMAGE_CONTENT)];
    pictureContent.content = UIImageJPEGRepresentation(leahy, 1.0); // dont sell jim leahy short
    Snap * picSnap = [SnapCreate createUserStorySnapWithDate:[NSDate date]
                                                   andLength:8.0f andContent:pictureContent andUser:me];
    
    
    
    // PIC STORY
    [Post storySnapbyUser:me andSnap:picSnap withComp:^(BOOL success, id result) {
        XCTAssert(success);
        NSLog(@"Printing the results of posting the picture!!! \n %@",result);
        [picStoryEx fulfill];
        if(success){
            Snap * theSnap = [SnapRead getSnapWithID:result[@"Success"]];
            NSLog(@"The snap is %@",theSnap);
            [Delete removeSnapFromStory:me.username andPass:me.password andSnapID:theSnap.snapID andComp:^(BOOL success, id result) {
                XCTAssert(success);
                if(success){
                    NSLog(@"Deleted snap from story %@",result);
                }
                [picStoryDeleteEx fulfill];
            }];
        }
    }];
    // VID STORY
    [Post storySnapbyUser:me andSnap:vidSnap withComp:^(BOOL success, id result) {
        XCTAssert(success);
        NSLog(@"Printing the results of posting the picture!!! \n %@",result);
        [vidStoryEx fulfill];
        if(success){
            Snap * theSnap = [SnapRead getSnapWithID:result[@"Success"]];;
            [Delete removeSnapFromStory:me.username andPass:me.password andSnapID:theSnap.snapID andComp:^(BOOL success, id result) {
                XCTAssert(success);
                if(success){
                    NSLog(@"Deleted snap from story %@",result);
                }
                [vidStoryDeleteEx fulfill];
            }];
        }
    }];
    
    
    
    
    [self waitForExpectationsWithTimeout:8 handler:^(NSError *error) {
        NSLog(@"Timed out\n");
        
    }];

}

-(void)testRegisterAndDeleteAccount{
    XCTestExpectation *registerEx= [self expectationWithDescription:@"Register request open"];
    XCTestExpectation *removeAccountEx= [self expectationWithDescription:@"Remove account request open"];

    [Post userRegister:@"Narwhaaaal" withPass:@"awesome" andEmail:@"awe@some.com" andFirstname:@"vinni" andLastname:@"vicci" withComp:^(BOOL success, id result) {
        XCTAssert(success);
        if(success){
            NSLog(@"success creating narwhaaaaaaaaaal %@",result);
            [Delete deleteAccount:@"Narwhaaaal" andPass:@"awesome" andComp:^(BOOL succcess, id result) {
                XCTAssert(success);
                if(success){
                    NSLog(@"success creating narwhaaaaaaaaaal %@",result);
                }
                [removeAccountEx fulfill];

            }];
        }
        [registerEx fulfill];
    }];

    [self waitForExpectationsWithTimeout:8 handler:^(NSError *error) {
        NSLog(@"Timed out\n");

    }];
}
-(void) registerPerson:(NSString *)person{
    // just going to assume it works
    [Post userRegister:person withPass:@"awesome" andEmail:@"awe@some.com" andFirstname:@"vinni" andLastname:@"vicci" withComp:^(BOOL success, id result) {

    }];
}
// so cruel I know!!
-(void)testAddAndRemoveFriend{
    [self registerPerson:@"Bro"];
    [self registerPerson:@"Broham"];
    
    XCTestExpectation *addFriend= [self expectationWithDescription:@"addFriendrequest open"];
    XCTestExpectation *removeFriend = [self expectationWithDescription:@"removeFriend account request open"];

    [Post addFriend:@"Bro" friendName:@"Broham" friendType:3 withComp:^(BOOL success, id result) {
        XCTAssert(success);
        if(success){
            NSLog(@"success adding a Friend %@",result);
            [Delete removeFriend:@"Bro" andPass:@"awesome" andFriend:@"Broham" andFriendType:2 andComp:^(BOOL success, id result) {
                XCTAssert(success);
                if(success){
                    NSLog(@"success creating narwhaaaaaaaaaal %@",result);
                }
                [removeFriend fulfill];

            }];
        }
        [addFriend fulfill];
    }];

    [self waitForExpectationsWithTimeout:8 handler:^(NSError *error) {
        NSLog(@"Timed out\n");

    }];
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
