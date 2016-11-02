//
// Created by joshua on 7/6/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataTVC.h"
#import "StoryViewerDelegate.h"
#import "SnapTransition.h"


@interface StoryTVC : CoreDataTVC <StoryViewerDelegate,UISearchBarDelegate,UISearchResultsUpdating, SnapTransition>
@property(nonatomic) UISearchController *searchController;



@end