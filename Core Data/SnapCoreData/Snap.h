//
//  Snap.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/12/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Content, Friend, Story, UserInfo;
#define SNAP_PERSONAL_TYPE 1
#define SNAP_STORY_TYPE 2
#define SNAP_USER_SENT_TYPE 3
static const NSString * DUMMY_SNAP_ID = @"1";
NS_ASSUME_NONNULL_BEGIN

@interface Snap : NSManagedObject
-(void) addFriendThatHasSeen:(Friend *)aFriend;
-(void) addFriendThatHasNotSeen:(Friend *)aFriend;
// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Snap+CoreDataProperties.h"
