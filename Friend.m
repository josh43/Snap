//
//  Friend.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/12/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "Friend.h"
#import "Content.h"
#import "Snap.h"
#import "Story.h"
#import "UserInfo.h"

@implementation Friend

// Insert code here to add functionality to your managed object subclass
#ifdef debugging
- (void)awakeFromFetch {
    logMethod();
    NSLog(@"Story Fetched");
}
- (void)awakeFromInsert {
    
    logMethod();
    NSLog(@"Story Inserted kewl beans");
}
#endif
@end
