//
// Created by joshua on 7/24/16.
// Copyright (c) 2016 joshua. All rights reserved.
// Used for sending things like a user has opened a story or deleted a story or has screen shotted
// (although I do not show who screen shotted visually the data is there

#import <Foundation/Foundation.h>

@class Snap;

#define USER_SAW 1
#define USER_SCREEN_SHOTTED 2
#define USER_DELETED 3


@interface CommandFactory : NSObject

+(void)thisUserSawSnap:(Snap *) theSnap;
+(void)thisUserScreenShottedSnap:(Snap *) theSnap;
+(void)thisUserDeletedSnapFromStory:(Snap *) theSnap;

+(void)parseAndExecuteCommandList;

// below are used for testing
+(void)thisUser:(NSString *) user SawSnap:(Snap *) theSnap whoOwnsIt:(NSString*) owner;
+(void)thisUser:(NSString *) user ScreenShottedSnap:(Snap *) theSnap  whoOwnsIt:(NSString*)owner;
+ (void)thisUser:(NSString *)user andPass:(NSString *)pass DeletedSnapFromStory:(Snap *)theSnap;





@end
@interface Command : NSObject
-(void)execute;
@end