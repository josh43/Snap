//
//  AppDelegate.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/5/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "AppDelegate.h"
#import "Friend.h"
#import "SnapTVCTester.h"
#import "StoryTVCTester.h"
#import "RestfulSnapCRUD.h"
#import "SnapRead.h"
#import "MainViewController.h"
#import "Utility.h"
#import "LoginAndRegisterViewController.h"

#define debug 1
@interface AppDelegate ()

@end

@implementation AppDelegate{
    UIWindow * window;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self cdh];
    //[SnapTVCTester test];
    //[StoryTVCTester  test];
    //[RestfulSnapCRUD checkAll];
    //[self test];
    window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds] ];
    UIViewController * rootVC;

    if([SnapRead getUserInfo]){

        rootVC = loadViewController(@"mainViewController");
    }else{
        rootVC = loadViewController(@"loginViewController");
    }

    window.rootViewController = rootVC;
    [window makeKeyAndVisible];

    //http://stackoverflow.com/questions/10501358/objective-c-getting-line-number-or-full-stack-trace-from-debugger-error
    NSSetUncaughtExceptionHandler(&exceptionHandler);

    if([SnapRead getUserInfo]){
        // probably want to do this in the background ..
        // I could put this up above but i want to do this ^^
        // so its a reminder
        [RestfulSnapCRUD checkAll];

    }

    return YES;
}
void exceptionHandler(NSException *exception)
{
    NSLog(@"%@",[exception name]);
    NSLog(@"%@",[exception reason]);
    NSLog(@"%@",[exception userInfo]);
    NSLog(@"%@",[exception callStackSymbols]);
    NSLog(@"%@",[exception callStackReturnAddresses]);
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive defaultState. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background defaultState.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application defaultState information to restore your application to its current defaultState in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[self cdh] saveContext];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive defaultState; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self cdh];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[self cdh] saveContext];

}
- (CoreDataHelper*)cdh {
    if (debug==1) {
        NSLog(@"Running X%@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (!_coreDataHelper) {
        _coreDataHelper = [CoreDataHelper new];
        [_coreDataHelper setupCoreData];
    }
    return _coreDataHelper;
}
@end
