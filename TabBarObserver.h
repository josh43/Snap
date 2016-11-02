//
// Created by joshua on 7/14/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol TabBarObserver
-(void) didSelectItem:(int) itemNo;
@end



@interface TabBarObservable : NSObject
@property(nonatomic,strong) NSMutableArray< id<TabBarObserver> > * observers;

- (void) addObserverForTabBarSelection:(id<TabBarObserver>) obs;
-(void) removeTabBarObserver:(id<TabBarObserver>) obs;
-(void) notify:(int) selection;
@end