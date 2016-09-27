//
// Created by joshua on 7/20/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Snap;
@class Snap;


@interface GetHelper : NSObject
+ (Snap *)createSnapWithResponse:(NSDictionary *)dictionary andMeta:(NSDictionary *)meta;

+ (NSMutableArray *)createListOfStoryUpdates:(NSArray *)array;

+ (NSString *)downloadMovieToFile:(NSData *)data;

+ (void)downloadWithRequest:(NSURL *)request withCompletion:(void (^)(BOOL, id))onCompletion;
@end