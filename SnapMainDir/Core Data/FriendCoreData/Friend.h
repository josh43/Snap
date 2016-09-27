//
//  Friend.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/12/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#define MUTUAL_FRIENDS 1
#define I_ADDED_THIS_FRIEND 2
#define THIS_FRIEND_ADDED_ME 3
#define NOT_FRIENDS 4
@class Content, Snap, Story, UserInfo;

NS_ASSUME_NONNULL_BEGIN

@interface Friend : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Friend+CoreDataProperties.h"
