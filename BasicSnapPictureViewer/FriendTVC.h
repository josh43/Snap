//
//  FriendTVC.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/5/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "CoreDataTVC.h"

@interface FriendTVC : CoreDataTVC <UISearchBarDelegate,UISearchResultsUpdating>
@property BOOL showAddButton;
-(void) configureLoad;
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController;
@end
