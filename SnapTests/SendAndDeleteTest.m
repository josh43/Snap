//
//  SendAndDeleteTest.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/23/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Rest.h"
#import "SnapRead.h"
#import "SnapCreate.h"
#import "Content.h"
#import "Snap.h"

@interface SendAndDeleteTest : XCTestCase

@end

@implementation SendAndDeleteTest

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

- (void)testGetSnap {
    
    
    XCTestExpectation *deleteEx = [self expectationWithDescription:@"deleteEx request open"];
    XCTestExpectation *getContentInfo = [self expectationWithDescription:@"getContentInfo request open"];
    XCTestExpectation *getContent = [self expectationWithDescription:@"getContent request open"];
    XCTestExpectation *postContent = [self expectationWithDescription:@"postContent request open"];
    
    UserInfo *me = [SnapRead getUserInfo];
    if (me == nil) {
        me = [SnapCreate createUserWithName:@"Falcon" andPasword:@"password"];
    }
    
    UIImage *leahy = [UIImage imageNamed:@"leahy"];
    Content *pictureContent = [CoreCreate createObject:@"Content"];
    if (!leahy) {
        NSLog(@"leahy was empty boys");
        exit(0);
    }
    
    NSMutableArray <NSString *> *stringBUDDIES = [NSMutableArray arrayWithArray:@[@"Falcon", @"Joshua", @"Mark", @"Auto"]];
    
    
    
    
    
    //[NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:cdh.context];
    pictureContent.contentType = [NSNumber numberWithInt:(IMAGE_CONTENT)];
    pictureContent.content = UIImageJPEGRepresentation(leahy, 1.0); // dont sell jim leahy short
    Snap *picSnap = [SnapCreate createUserSendSnapChat:[NSDate date] andContentType:IMAGE_CONTENT andLength:5.0f andUser:me withFriendList:stringBUDDIES];
    
    
    
    [Post sendSnap:picSnap toFriends:nil orStringFriends:stringBUDDIES withComp:^(BOOL success, id res) {
        
        
        [postContent fulfill];
        if(!success){
            return;
        }
        
        NSLog(@"result from posting the snap",res);
        
        [Get getContentInfo:picSnap.snapID withComp:^(BOOL succ, Snap *theSnap) {
            XCTAssertTrue(succ);
            
            if (succ) {
                NSLog(@"getcontent info worked printing the snap %@", theSnap);
                [getContentInfo fulfill];
                
                [Get getContent:@"Falcon" withPass:@"password" forSnap:theSnap withComp:^(BOOL succ, id res) {
                    XCTAssertTrue(succ);
                    if (succ) {
                        NSLog(@"Succesfuly got content %@", res);
                    }else{
                        return;
                    }
                    [getContent fulfill];
                    
                    
                    // delete it afterr/// this should work although it will come back as an error it should delete the content
                    [Delete removeSnapFromStory:@"Falcon" andPass:@"password" andSnapID:picSnap.snapID andComp:^(BOOL res, id result) {
                        XCTAssertTrue(res);
                        NSLog(@"ON removing snap from story %@", result);
                        [deleteEx fulfill];
                    }];
                    
                }];
                
                
                NSLog(@"Timed out\n");
            }
            
            
        }];
        
        
        
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
