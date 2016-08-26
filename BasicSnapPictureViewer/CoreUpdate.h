//
// Created by joshua on 7/12/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface CoreUpdate : NSObject

+(BOOL) update:(NSString *)entityName
 withProprties:(NSDictionary *) dict;
+(BOOL) batchUpdate:(NSString *)entityName
      withPredicate:(NSPredicate *) predicate
andUpdateProperties:(NSDictionary *) properties;
+(void) save;
@end