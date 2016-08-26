//
//  Content.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/11/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>


#define IMAGE_CONTENT 1
#define VIDEO_CONTENT 2
@class Friend, Snap, UserInfo;

NS_ASSUME_NONNULL_BEGIN

@interface Content : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
-(UIImage *) getUIImage;
-(NSURL *) getURL;
-(void) setURL:(NSURL *)url;

- (UIImage *)getStoryImage;
@end

NS_ASSUME_NONNULL_END

#import "Content+CoreDataProperties.h"
