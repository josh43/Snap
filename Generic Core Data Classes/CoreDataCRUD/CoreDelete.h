//
// Created by joshua on 7/12/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface CoreDelete : NSObject
+(BOOL)removeObject:(NSManagedObject *)toRemove;
+(BOOL)removeObjectsWithName:(NSString *) entityName
                andPredicate:(NSPredicate *)predicate;
@end