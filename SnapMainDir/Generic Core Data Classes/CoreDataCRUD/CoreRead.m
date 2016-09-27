//
// Created by joshua on 7/12/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "CoreRead.h"
#import "Utility.h"


@implementation CoreRead {

}

+(nullable NSArray<NSManagedObject *> *)findObjects:(NSString *)coreDataName
                           andKeyForEntity:(NSString *) key
                              andPredicate:(NSPredicate *)predicate
               andFetchedResultsController:(NSFetchedResultsController *) fetched
                         useSectionKeyPath:(BOOL) answer{


    logMethod()
    AppDelegate  * TheAppDelegate = [[UIApplication sharedApplication] delegate];
    CoreDataHelper *cdh = [TheAppDelegate cdh];

    NSFetchRequest  * fetch = [[NSFetchRequest alloc] initWithEntityName:coreDataName];
    fetch.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:key ascending:YES selector:nil] ];
    fetch.predicate = predicate;
    NSError  * err = nil;
    if(fetched){
        fetched =[[NSFetchedResultsController alloc] initWithFetchRequest:fetch
                                            managedObjectContext:cdh.context
                                              sectionNameKeyPath:(answer ? key : nil)
                                                       cacheName:nil];

        [fetched performFetch:&err];
        if(err){
            if(debugging){
                NSLog(@"Error performing fetch for CRUD method read");
            }
        }

        // should be expected
        return nil;
    }else {
        return [cdh.context executeFetchRequest:fetch error:&err];
    }


}

+(nullable NSArray<NSManagedObject *> *)findObjects:(NSString *)coreDataName
                                    andKeyForEntity:(NSString *) key
                                       andAscending:(BOOL) ascending
                                       andPredicate:(NSPredicate *)predicate
                        andFetchedResultsController:(NSFetchedResultsController *) fetched
                                  useSectionKeyPath:(BOOL) answer{


    logMethod()
    AppDelegate  * TheAppDelegate = [[UIApplication sharedApplication] delegate];
    CoreDataHelper *cdh = [TheAppDelegate cdh];

    NSFetchRequest  * fetch = [[NSFetchRequest alloc] initWithEntityName:coreDataName];
    fetch.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:key ascending:ascending selector:nil] ];
    fetch.predicate = predicate;
    NSError  * err = nil;
    if(fetched){
        fetched =[[NSFetchedResultsController alloc] initWithFetchRequest:fetch
                                                     managedObjectContext:cdh.context
                                                       sectionNameKeyPath:(answer ? key : nil)
                                                                cacheName:nil];

        [fetched performFetch:&err];
        if(err){
            if(debugging){
                NSLog(@"Error performing fetch for CRUD method read");
            }
        }

        // should be expected
        return nil;
    }else {
        return [cdh.context executeFetchRequest:fetch error:&err];
    }


}
@end