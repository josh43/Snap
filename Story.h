//
//  Story.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/6/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Friend, Snap, UserInfo;

NS_ASSUME_NONNULL_BEGIN

@interface Story : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
-(void)sortBasedOnDate;
-(void) insertSnap:(Snap *)theSnap;
-(void) removeSnap:(Snap *)theSnap;

@end

NS_ASSUME_NONNULL_END

#import "Story+CoreDataProperties.h"
