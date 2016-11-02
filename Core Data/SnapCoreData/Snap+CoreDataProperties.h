//
//  Snap+CoreDataProperties.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/27/16.
//  Copyright © 2016 joshua. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Snap.h"

NS_ASSUME_NONNULL_BEGIN

@interface Snap (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *dateSent;
@property (nullable, nonatomic, retain) NSNumber *hasSeen;
@property (nullable, nonatomic, retain) NSNumber *length;
@property (nullable, nonatomic, retain) NSString *snapID;
@property (nullable, nonatomic, retain) NSNumber *snapType;
// The currentUserName will be a reoccuring theme, logging the content to which the data belnogs
// Although I should have used the UserInfo property
@property (nullable, nonatomic, retain) NSString *currentUserName;
@property (nullable, nonatomic, retain) Content *content;
@property (nullable, nonatomic, retain) Friend *friend;
@property (nullable, nonatomic, retain) Story *newRelationship;
@property (nullable, nonatomic, retain) Story *newRelationship2;
@property (nullable, nonatomic, retain) UserInfo *thisUser;
@property (nullable, nonatomic, retain) NSSet<Friend *> *usersWhoHaveNotSeen;
@property (nullable, nonatomic, retain) NSSet<Friend *> *usersWhoHaveSeen;

@end

@interface Snap (CoreDataGeneratedAccessors)

- (void)addUsersWhoHaveNotSeenObject:(Friend *)value;
- (void)removeUsersWhoHaveNotSeenObject:(Friend *)value;
- (void)addUsersWhoHaveNotSeen:(NSSet<Friend *> *)values;
- (void)removeUsersWhoHaveNotSeen:(NSSet<Friend *> *)values;

- (void)addUsersWhoHaveSeenObject:(Friend *)value;
- (void)removeUsersWhoHaveSeenObject:(Friend *)value;
- (void)addUsersWhoHaveSeen:(NSSet<Friend *> *)values;
- (void)removeUsersWhoHaveSeen:(NSSet<Friend *> *)values;

@end

NS_ASSUME_NONNULL_END
