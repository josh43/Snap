//
//  Story.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/6/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "Story.h"
#import "Friend.h"
#import "Snap.h"
#import "UserInfo.h"
#import "Utility.h"

@implementation Story

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
-(void) insertSnap:(Snap *)theSnap{
        NSMutableOrderedSet* temp = [NSMutableOrderedSet orderedSetWithOrderedSet:self.snapList];
        [temp addObject:theSnap];
        self.snapList= temp;

}

-(void) removesnap:(Snap *)theSnap{
    NSMutableOrderedSet* temp = [NSMutableOrderedSet orderedSetWithOrderedSet:self.snapList];
    [temp removeObject:theSnap];
    self.snapList= temp;


}

-(void)sortBasedOnDate{
    logMethod()
    // hell on earth...
    self.snapList = [NSOrderedSet<Snap *> orderedSetWithArray:[self.snapList sortedArrayUsingComparator:^NSComparisonResult(Snap * obj1, Snap * obj2) {
// haha will this work1!?!?! but a horse of course
        if([obj1.dateSent compare:obj2.dateSent] == NSOrderedDescending){
            return NSOrderedAscending;
        }else if ([obj1.dateSent compare:obj2.dateSent] == NSOrderedAscending) {
            return NSOrderedDescending;
        }else{
            return NSOrderedSame;
        }
    }]];

    
}

@end
