//
// Created by joshua on 7/14/16.
// Copyright (c) 2016 joshua. All rights reserved.
// ---------------- THIS CLASS IS UNUSED ---------------------

#import "TabBarObserver.h"





@implementation TabBarObservable{

}


- (instancetype)init {
    self = [super init];
    if (self) {
        _observers = [[NSMutableArray <id<TabBarObserver> > alloc]init];
    }

    return self;
}

- (void)addObserverForTabBarSelection:(id<TabBarObserver>)obs {
    [_observers addObject:obs];
}

- (void)    removeTabBarObserver:(id<TabBarObserver>)obs {
    [_observers removeObject:obs];
}

- (void)notify:(int) selection {
    for(id<TabBarObserver> obs in _observers){
        [obs didSelectItem:selection];
    }
}
@end