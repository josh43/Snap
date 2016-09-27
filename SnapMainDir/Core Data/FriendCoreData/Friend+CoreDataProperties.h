//
//  Friend+CoreDataProperties.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/27/16.
//  Copyright © 2016 joshua. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Friend.h"

NS_ASSUME_NONNULL_BEGIN

@interface Friend (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *displayName;
@property (nullable, nonatomic, retain) NSString *firstLetter;
@property (nullable, nonatomic, retain) NSNumber *friendType;
@property (nullable, nonatomic, retain) NSString *username;
// The currentUserName will be a reoccuring theme, logging the content to which the data belnogs
// Although I should have used the UserInfo property
@property (nullable, nonatomic, retain) NSString *currentUserName;
@property (nullable, nonatomic, retain) Snap *newRelationship;
@property (nullable, nonatomic, retain) Snap *newRelationship1;
@property (nullable, nonatomic, retain) Content *picture;
@property (nullable, nonatomic, retain) Story *story;
@property (nullable, nonatomic, retain) UserInfo *newRelationship2;

@end

NS_ASSUME_NONNULL_END
