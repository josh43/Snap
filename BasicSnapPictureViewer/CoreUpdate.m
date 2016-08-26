//
// Created by joshua on 7/12/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "CoreUpdate.h"
#import "Utility.h"


@implementation CoreUpdate {

}

+(BOOL) update:(NSString *)entityName
 withProprties:(NSDictionary *) dict{
    logMethod()
    return [self batchUpdate:entityName withPredicate:nil andUpdateProperties:dict];

}
+(BOOL) batchUpdate:(NSString *)entityName
          withPredicate:(NSPredicate *) predicate
    andUpdateProperties:(NSDictionary *) properties{
    logMethod()
    AppDelegate  * TheAppDelegate = [[UIApplication sharedApplication] delegate];
    CoreDataHelper *cdh = [TheAppDelegate cdh];

    [cdh saveContext];

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:cdh.context];

    NSBatchUpdateRequest *batchRequest = [[NSBatchUpdateRequest alloc] initWithEntity:entityDescription];

    batchRequest.propertiesToUpdate = properties;
    batchRequest.resultType = NSUpdatedObjectIDsResultType;
    batchRequest.predicate = predicate;

    NSError *requestError;
    NSBatchUpdateResult *result = (NSBatchUpdateResult *)[cdh.context executeRequest:batchRequest error:&requestError];

    if (result == nil) {

        NSLog(@"Error: %@", [requestError localizedDescription]);
        return NO;
    } else {

        if(debugging) {
            NSLog(@"Objects update %@", result.result);
        }
        [result.result enumerateObjectsUsingBlock:^(NSManagedObjectID *objID, NSUInteger idx, BOOL *stop) {
            NSManagedObject *obj = [cdh.context objectWithID:objID];
            if (![obj isFault]) {
                [cdh.context refreshObject:obj mergeChanges:YES];
            }
        }];
        // Batch update succeeded
        return YES;
    }
}

+(void) save{
    AppDelegate  * TheAppDelegate = [[UIApplication sharedApplication] delegate];
    CoreDataHelper *cdh = [TheAppDelegate cdh];
    [cdh saveContext];
}

@end