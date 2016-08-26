//
// Created by joshua on 7/6/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "StoryTVCTester.h"
#import "AppDelegate.h"
#import "Friend.h"
#import "Snap.h"
#import "Content.h"
#import "Story.h"

NSArray * dates;
@implementation StoryTVCTester{

}

+ (void)test {
    // JUST MAKE SURE SNAP TVC IS CALLED BEFORE TO GENERATE THE FRIEND LIST hollllaaa

    NSDate * now = [NSDate date];

    NSDate * now2 = [NSDate dateWithTimeInterval:100 sinceDate:now];
    NSDate * now3 = [NSDate dateWithTimeInterval:200 sinceDate:now];
    NSDate * now4 = [NSDate dateWithTimeInterval:400 sinceDate:now];

    NSDate * now5 = [NSDate dateWithTimeInterval:600 sinceDate:now];
    NSDate * now6 = [NSDate dateWithTimeInterval:800 sinceDate:now];
    // about a weeek ago


    // in last to first
    dates = @[now,now2,now3,now4,now5,now6];
    [self loadTrailerStory];
    [self loadNatureStory];
}

+(void) loadTrailerStory{
    AppDelegate  * TheAppDelegate = [[UIApplication sharedApplication] delegate];
    CoreDataHelper *cdh = [TheAppDelegate cdh];
    // get jim leahy
    NSFetchRequest  * fetch = [[NSFetchRequest alloc] initWithEntityName:@"Friend"];
    fetch.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"username" ascending:YES selector:nil] ];
    fetch.predicate = [NSPredicate predicateWithFormat:@"username == %@",@"Jim leahy"];
    NSError  * err = nil;
    Friend * jim = [[cdh.context executeFetchRequest:fetch error:&err] firstObject];

    if(err || jim == nil){
        NSLog(@"Error retrieving Jim leahy check your query\n");
        exit(0);
    }

    Story *jimStory = [NSEntityDescription insertNewObjectForEntityForName:@"Story" inManagedObjectContext:cdh.context];
    UIImage * images[6];

    NSMutableOrderedSet<Snap *> * mutableSnapList = [[NSMutableOrderedSet<Snap *> alloc ]init];

    jimStory.user = jim;
    for(int i = 1; i <=4 ; i ++){
        Snap *snap = [NSEntityDescription insertNewObjectForEntityForName:@"Snap" inManagedObjectContext:cdh.context];
        snap.dateSent = dates[i];
        snap.friend = jim;
        snap.content = [NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:cdh.context];

        images[i] = [UIImage imageNamed:[NSString stringWithFormat:@"tpb%i",i]];

        snap.content.content = UIImageJPEGRepresentation(images[i],.5);
        snap.content.contentType = [NSNumber numberWithInt:IMAGE_CONTENT];
        snap.length = [NSNumber numberWithInt:7];
        snap.snapType = [NSNumber numberWithInt:SNAP_STORY_TYPE];
        snap.hasSeen = [NSNumber numberWithBool:NO];

        [mutableSnapList addObject:snap];
        jimStory.mostRecentSnapNotSeen = snap;
    }
    jimStory.snapList = mutableSnapList.copy;

}
+(void) loadNatureStory{
    AppDelegate  * TheAppDelegate = [[UIApplication sharedApplication] delegate];
    CoreDataHelper *cdh = [TheAppDelegate cdh];
    // get jim leahy
    NSFetchRequest  * fetch = [[NSFetchRequest alloc] initWithEntityName:@"Friend"];
    fetch.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"username" ascending:YES selector:nil] ];
    fetch.predicate = [NSPredicate predicateWithFormat:@"username == %@",@"Ricky"];
    NSError  * err = nil;
    Friend * boma = [[cdh.context executeFetchRequest:fetch error:&err] firstObject];
    if(err || boma == nil){
        NSLog(@"Error retrieving Ricky  check your query\n");
        exit(0);
    }
    UIImage * images[7];

    NSMutableOrderedSet<Snap *> * mutableSnapList = [[NSMutableOrderedSet<Snap *> alloc ]init];
    Story *bomaStory = [NSEntityDescription insertNewObjectForEntityForName:@"Story" inManagedObjectContext:cdh.context];
    bomaStory.user = boma;
    for(int i = 1; i <=6 ; i ++){
        Snap *snap = [NSEntityDescription insertNewObjectForEntityForName:@"Snap" inManagedObjectContext:cdh.context];
        snap.dateSent = dates[i-1];
        snap.friend = boma;
        snap.content = [NSEntityDescription insertNewObjectForEntityForName:@"Content" inManagedObjectContext:cdh.context];


        images[i] = [UIImage imageNamed:[NSString stringWithFormat:@"nat%i",i]];
        snap.content.content = UIImageJPEGRepresentation(images[i],0.5);
        snap.content.contentType = @IMAGE_CONTENT;
        snap.length = [NSNumber numberWithInt:7];
        snap.snapType = [NSNumber numberWithInt:SNAP_STORY_TYPE];
        snap.hasSeen = [NSNumber numberWithBool:NO];

        bomaStory.mostRecentSnapNotSeen = snap;
        [mutableSnapList addObject:snap];

    }
    bomaStory.snapList = mutableSnapList.copy;
}
@end