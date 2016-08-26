//
//  AddFriendTVC.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/23/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendTVC : UITableViewController <UISearchBarDelegate, UISearchResultsUpdating>
@property(nonatomic,strong) NSMutableArray * friendResults;


@end
