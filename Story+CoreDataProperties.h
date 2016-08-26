//
//  Story+CoreDataProperties.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/27/16.
//  Copyright © 2016 joshua. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Story.h"

NS_ASSUME_NONNULL_BEGIN

@interface Story (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *numberOfSnaps;
@property (nullable, nonatomic, retain) NSNumber *numberViewed;
// The currentUserName will be a reoccuring theme, logging the content to which the data belnogs
// Although I should have used the UserInfo property
@property (nullable, nonatomic, retain) NSString *currentUserName;
@property (nullable, nonatomic, retain) Snap *mostRecentSnapNotSeen;
@property (nullable, nonatomic, retain) UserInfo *myInfo;
@property (nullable, nonatomic, retain) NSOrderedSet<Snap *> *snapList;
@property (nullable, nonatomic, retain) Friend *user;

@end

@interface Story (CoreDataGeneratedAccessors)

- (void)insertObject:(Snap *)value inSnapListAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSnapListAtIndex:(NSUInteger)idx;
- (void)insertSnapList:(NSArray<Snap *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSnapListAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSnapListAtIndex:(NSUInteger)idx withObject:(Snap *)value;
- (void)replaceSnapListAtIndexes:(NSIndexSet *)indexes withSnapList:(NSArray<Snap *> *)values;
- (void)addSnapListObject:(Snap *)value;
- (void)removeSnapListObject:(Snap *)value;
- (void)addSnapList:(NSOrderedSet<Snap *> *)values;
- (void)removeSnapList:(NSOrderedSet<Snap *> *)values;

@end

NS_ASSUME_NONNULL_END
