//
//  FriendTableViewCell.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/7/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ADD_FRIEND_CELL 1
#define FRIEND_CELL 2
#define ADDED_ME_FRIEND_CELL 3

@interface FriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *label;

- (void) setFriendCellType:(int) type WithInitalState:(BOOL) inital;
@end
