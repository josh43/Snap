//
//  SendToFriendTableViewCell.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/11/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "SendToFriendTableViewCell.h"

@implementation SendToFriendTableViewCell
static UIImage * unchecked= nil;
static UIImage * checked = nil;
- (void)awakeFromNib {
    [super awakeFromNib];
    _hasBeenPressed = NO;
    if(unchecked == nil){
        unchecked = [UIImage imageNamed:@"uncheckedBox"];
        checked = [UIImage imageNamed:@"checkedBox"];
        
    }
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonPressed:(id)sender {
    if(!_hasBeenPressed){

        [self.button setImage:checked forState:UIControlStateNormal];

    }else{
        [self.button setImage:unchecked forState:UIControlStateNormal];

    }
    _hasBeenPressed = !_hasBeenPressed;
    [_myDelegate userDidCheckButton:_hasBeenPressed withTarget:_label.text withIndexPath:_indexPath];
}

@end
