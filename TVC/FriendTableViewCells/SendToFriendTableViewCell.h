//
//  SendToFriendTableViewCell.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/11/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendToUsersTVC.h"

@interface SendToFriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak,nonatomic) SendToUsersTVC * myDelegate;
@property BOOL hasBeenPressed;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property(nonatomic, strong) NSIndexPath *indexPath;
@end
