//
//  Snap.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/12/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "Snap.h"
#import "Content.h"
#import "Friend.h"
#import "Story.h"
#import "UserInfo.h"


#pragma clang diagnostic ignored "-Wnullability-completeness"
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"

@implementation Snap

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

-(void) addFriendThatHasSeen:(Friend *)aFriend{
    NSMutableSet* temp = [NSMutableSet setWithSet:self.usersWhoHaveSeen];
    [temp addObject:aFriend];
    self.usersWhoHaveSeen= temp;

}

-(void) addFriendThatHasNotSeen:(Friend *)aFriend{
    NSMutableSet* temp = [NSMutableSet setWithSet:self.usersWhoHaveSeen];
    [temp addObject:aFriend];
    self.usersWhoHaveNotSeen= temp;


}
@end

//#pragma clang diagnostic pop
#pragma clang diagnostic pop
