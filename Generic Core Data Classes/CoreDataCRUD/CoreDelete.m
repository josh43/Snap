//
// Created by joshua on 7/12/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "CoreDelete.h"
#import "Utility.h"


@implementation CoreDelete {

}

+(BOOL)removeObject:(NSManagedObject *)toRemove {
       logMethod()
       AppDelegate  * TheAppDelegate = [[UIApplication sharedApplication] delegate];
        CoreDataHelper *cdh = [TheAppDelegate cdh];
        [cdh.context deleteObject:toRemove];

        return YES;
}

// BATCH DELETE

//https://developer.apple.com/videos/play/wwdc2015/220/
//Explains this ish
+(BOOL)removeObjectsWithName:(NSString *) entityName
                andPredicate:(NSPredicate *)predicate{
    logMethod()


    AppDelegate  * TheAppDelegate = [[UIApplication sharedApplication] delegate];
    CoreDataHelper *cdh = [TheAppDelegate cdh];
    NSFetchRequest *  fetch = [[NSFetchRequest alloc] initWithEntityName:entityName];
    fetch.predicate = predicate;

    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetch];
    delete.resultType = NSBatchDeleteResultTypeObjectIDs;
    NSError *deleteError = nil;
   // [cdh.context executeRequest:delete error:&deleteError];

    NSBatchDeleteResult *result = [cdh.coordinator executeRequest:delete withContext:cdh.context error:&deleteError];

    if (result == nil) {

        NSLog(@"Error: %@", [deleteError localizedDescription]);
        return NO;
    } else {

        if(debugging) {
            NSLog(@"Objects update %@", result.result);
        }

        //[cdh.context refreshObject:<#(NSManagedObject *)object#> merg];
        [result.result enumerateObjectsUsingBlock:^(NSManagedObjectID *objID, NSUInteger idx, BOOL *stop) {
            NSManagedObject *obj = [cdh.context objectWithID:objID];
            if (![obj isFault]) {
                [cdh.context refreshObject:obj mergeChanges:YES];
            }
        }];

        // this is the money maker, it updates all objects in the context to reflect the delete request
        [cdh.context refreshAllObjects];

        // Batch update succeeded
    }
    
    
    [cdh saveContext];
    return YES;
}
@end
