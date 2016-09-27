//
//  UserInfo+CoreDataProperties.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/27/16.
//  Copyright © 2016 joshua. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfo (CoreDataProperties)
// displayname is actually not used :::|
@property (nullable, nonatomic, retain) NSString *displayName;
// the last time this user has queried the server so that they can get
// the most up to date snaps whilst not having to pull down more data than they need
@property (nullable, nonatomic, retain) NSDate *lastServerQuery;

@property (nullable, nonatomic, retain) NSString *password;

@property (nullable, nonatomic, retain) NSString *username;
// currentUser is used as a BOOL to identify the user that is currently
// logged in to the application on that device. I forgot that it is possible
// that more than one user may have their information on one phone(although unlikely)
@property (nullable, nonatomic, retain) NSNumber *currentUser;
// while it is named picture the Content described the actual content of the snap
// which might be picture data or a url to a .mov file
@property (nullable, nonatomic, retain) Content *picture;

@property (nullable, nonatomic, retain) NSSet<Snap *> *snapChats;
@property (nullable, nonatomic, retain) Story *story;

@end

@interface UserInfo (CoreDataGeneratedAccessors)

- (void)addSnapChatsObject:(Snap *)value;
- (void)removeSnapChatsObject:(Snap *)value;
- (void)addSnapChats:(NSSet<Snap *> *)values;
- (void)removeSnapChats:(NSSet<Snap *> *)values;

@end

NS_ASSUME_NONNULL_END
