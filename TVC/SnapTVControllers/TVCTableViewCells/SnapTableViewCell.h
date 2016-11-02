//
//  SnapTableViewCell.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/13/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Snap;

@interface SnapTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

- (void)cellWithSnap:(Snap *)snap;
@end
