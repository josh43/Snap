//
//  UserInfo.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/12/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Content, Snap, Story;

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (void)addSnapToSentList:(Snap *)value;
- (void)setSnapChatSentList:(NSSet<Snap *> *)values;


@end

NS_ASSUME_NONNULL_END

#import "UserInfo+CoreDataProperties.h"
