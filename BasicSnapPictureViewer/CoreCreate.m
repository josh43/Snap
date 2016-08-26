//
// Created by joshua on 7/12/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "CoreCreate.h"
#import "Utility.h"



@implementation CoreCreate {

}
// __kindof makes it so the compiler does not generate warnings when its being cast to a derived class
+(__kindof NSManagedObject *)createObject:(NSString *)coreDataName{
    logMethod()
    AppDelegate  * TheAppDelegate = [[UIApplication sharedApplication] delegate];
    CoreDataHelper *cdh = [TheAppDelegate cdh];
    NSManagedObject * toReturn =  [NSEntityDescription insertNewObjectForEntityForName:coreDataName inManagedObjectContext:cdh.context];
    return toReturn;
}


@end