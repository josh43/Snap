//
// Created by joshua on 7/12/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface CoreRead : NSObject

+( nullable NSArray<__kindof NSManagedObject *> *)findObjects:(NSString *)coreDataName
                           andKeyForEntity:(NSString *) key
                              andPredicate:(NSPredicate *)predicate
               andFetchedResultsController:(NSFetchedResultsController *) fetched
                         useSectionKeyPath:(BOOL) answer;

+( nullable NSArray< __kindof NSManagedObject *> *)findObjects:(NSString *)coreDataName
                                    andKeyForEntity:(NSString *) key
                                       andAscending:(BOOL) ascending
                                       andPredicate:(NSPredicate *)predicate
                        andFetchedResultsController:(NSFetchedResultsController *) fetched
                                  useSectionKeyPath:(BOOL) answer;
@end