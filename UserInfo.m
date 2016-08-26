//
//  UserInfo.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/12/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "UserInfo.h"
#import "Content.h"
#import "Snap.h"
#import "Story.h"

@implementation UserInfo

// Insert code here to add functionality to your managed object subclass
- (void)addSnapToSentList:(Snap *)value{
    NSMutableSet* temp = [NSMutableSet setWithSet:self.snapChats];
    [temp addObject:value];
    self.snapChats= temp;
}
- (void)setSnapChatSentList:(NSSet<Snap *> *)values{
    self.snapChats= values;

}

@end
