//
//  Content+CoreDataProperties.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/20/16.
//  Copyright © 2016 joshua. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Content.h"

NS_ASSUME_NONNULL_BEGIN

@interface Content (CoreDataProperties)

// if the content field is used than it will be of type image data
@property (nullable, nonatomic, retain) NSData *content;
// content type is either PICTURE_CONTENT or VIDEO_CONTENT
@property (nullable, nonatomic, retain) NSNumber *contentType;
// url will be used if it is a movie
@property (nullable, nonatomic, retain) NSString *url;
// whether it can be played/viewed or not
@property (nullable, nonatomic, retain) NSNumber *hasDownloaded;
@property (nullable, nonatomic, retain) Snap *newRelationship;
@property (nullable, nonatomic, retain) Friend *newRelationship1;
@property (nullable, nonatomic, retain) UserInfo *newRelationship2;

@end

NS_ASSUME_NONNULL_END
