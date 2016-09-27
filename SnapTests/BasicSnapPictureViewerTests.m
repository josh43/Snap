//
//  BasicSnapPictureViewerTests.m
//  BasicSnapPictureViewerTests
//
//  Created by joshua on 7/5/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Rest.h"
#import "SnapRead.h"
#import "SnapCreate.h"
#import "Content.h"

@interface BasicSnapPictureViewerTests : XCTestCase

@end

@implementation BasicSnapPictureViewerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHelloHTTP {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTestExpectation *getExpectation = [self expectationWithDescription:@"get url request open"];
    XCTestExpectation *postExpectation = [self expectationWithDescription:@"post url request open"];
    XCTestExpectation *putExpectation = [self expectationWithDescription:@"put url request open"];

    XCTAssertEqual(1 + 1, 2, "one plus one should equal two");
    [Get helloGet:^(BOOL success, id result) {
        if(success){
         //print
            NSLog(@"Results from hello Get -- %@",result);
        }else{
            NSLog(@"Failed hello get");
        }

        XCTAssert(success);
        [getExpectation fulfill];
    }];
    [Post helloPost:^(BOOL success, id result) {
        if(success){
            //print
            NSLog(@"Results from hello Post -- %@",result);
        }else{
            NSLog(@"Failed hello Post");
        }

        XCTAssert(success);
        [postExpectation fulfill];
    }];
    [Delete helloDelete:^(BOOL success, id result) {
        if(success){
            //print
            NSLog(@"Results from hello Get -- %@",result);
        }else{
            NSLog(@"Failed hello Delete");
        }

        XCTAssert(success);
        [putExpectation fulfill];
    }];



    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        NSLog(@"Timed out\n");
    }];

}
/* PLEASE REMEMBER TO RUN FROM mongoshell load("mongoTester.js") from SnapServer/Test
 
 Also when retreiving snaps from the snap inbox, if the server crashes right as you make a request to check your snapbox
 it is possible that you will lose the snap because I remove it via server side :::::::|
 
 */



- (void)testGetHTTPShouldWork {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    UserInfo * me = [SnapRead getUserInfo];
    me.password = @"password";
    XCTestExpectation *getContentInfo = [self expectationWithDescription:@"getContentInfo request open"];
    XCTestExpectation *getListOfLastUpdatedStories = [self expectationWithDescription:@"getListOfLastUpdatedStories request open"];
    XCTestExpectation *query = [self expectationWithDescription:@"query request open"];
    XCTestExpectation *getSnapChats = [self expectationWithDescription:@"snap chats request open"];
    
    XCTAssertEqual(1 + 1, 2, "one plus one should equal two");
    //5790690a0eb3b6301e0aaf96 is trailer park boys image
    
    // this won't work once you have actually gotten the content

    [Get getSnapListForUser:[SnapRead getUserInfo] withComp:^(BOOL succes, id res) {
        XCTAssertTrue(succes);
        if(succes){
            NSLog(@"Success on getting stories printing res %@",res);
        }
        [getSnapChats fulfill];
    }];
    [Get getListOfLastUpdatedStories:@"Falcon" andPass:@"password" withComp:^(BOOL succes, id res) {
        XCTAssertTrue(succes);
        if(succes){
            NSLog(@"Success on getting stories printing res %@",res);
        }
        [getListOfLastUpdatedStories fulfill];
    }];
    
    [Get query:@"Falcon" withPass:@"password" andQuery:@"{}" withComp:^(BOOL success, id res) {
        if(success){
            NSLog(@"Successfuly query %@",res);
        }
        [query fulfill];
        XCTAssertTrue(success);
    }];
    [self waitForExpectationsWithTimeout:8 handler:^(NSError *error) {
        NSLog(@"Timed out\n");

    }];
    
}
- (void)testGetHTTPShouldFail {
    XCTestExpectation *getContentInfo = [self expectationWithDescription:@"getContentInfo request open"];
    XCTestExpectation *getListOfLastUpdatedStories = [self expectationWithDescription:@"getListOfLastUpdatedStories request open"];
    XCTestExpectation *query = [self expectationWithDescription:@"query request open"];
    
    
    //5790690a0eb3b6301e0aaf96 is trailer park boys image
    [Get getContentInfo:@"5790690a0eb3b6301e0aaf96HotUpIntheSix" withComp:^(BOOL succ, Snap * theSnap) {
        [getContentInfo fulfill];
        XCTAssertFalse(succ);
    }];
    
    [Get getListOfLastUpdatedStories:@"Falcoon" andPass:@"password" withComp:^(BOOL succes, id res) {
        XCTAssertFalse(succes);
        if(succes){
            NSLog(@"Success on getting stories printing res %@",res);
        }
        [getListOfLastUpdatedStories fulfill];
    }];
    
    [Get query:@"Falcon" withPass:@"passdword" andQuery:@"231{}" withComp:^(BOOL success, id res) {
        if(success){
            NSLog(@"Successfuly query %@",res);
        }
        XCTAssertFalse(success);
        [query fulfill];
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
