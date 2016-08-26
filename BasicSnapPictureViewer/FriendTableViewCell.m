//
//  FriendTableViewCell.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/7/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "FriendTableViewCell.h"

#import "Friend.h"
#import "Post.h"
#import "SnapRead.h"
#import "UserInfo.h"
#import "SnapCreate.h"
#import "Delete.h"
#import "SnapDelete.h"
#import "Utility.h"




static UIImage * deleteImage;

@implementation FriendTableViewCell{
    BOOL initalState;
    int cellType;
}


-(void)setFriendCellType:(int)type WithInitalState:(BOOL)inital {
    initalState = inital;
    cellType = type;
    [self initSelfManually];
    _addButton.tintColor = [UIColor greenColor];

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    if(!deleteImage){
        deleteImage = [UIImage imageNamed:@"delete-button"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected defaultState
}


- (IBAction)hitAddFriend:(id)sender {
    NSString *friendNameToQuery = _label.text;
    [self toggleButton];
}
-(void)toggleButton{


    FriendTableViewCell * weakSelf = self;
    switch(cellType) {
        case FRIEND_CELL: {
            if(initalState){
                UserInfo *me = [SnapRead getUserInfo];

                // than delete friend
                [Delete removeFriend:me.username andPass:me.password andFriend:weakSelf.label.text andFriendType:NOT_FRIENDS andComp:^(BOOL success, id res) {
                    if (success) {
                        // than
                        dispatch_async(dispatch_get_main_queue(),^{
                            [SnapDelete deleteFriend:weakSelf.label.text withUserName:weakSelf.label.text andFriendID:nil];
                           // weakSelf.addButton.tintColor = [UIColor greenColor];
                           // [weakSelf.addButton setImage:[UIImage imageNamed:@"correct-mark"] forState:UIControlStateNormal];
                        });

                    }else{
                        basicAlertMessage(@"Failed to remove Friend")

                    }


                }];
            }else{
                // do nothing
            }
            // set it to add button
            break;
        }
        case ADD_FRIEND_CELL: {
            UserInfo *me = [SnapRead getUserInfo];

            if(initalState){ // add friend
                // we are not friends if initalstate is YES

                [Post addFriend:me.username friendName:self.label.text friendType:I_ADDED_THIS_FRIEND withComp:^(BOOL success, id res) {
                    if(success){
                        dispatch_async(dispatch_get_main_queue(),^{
                            [SnapCreate createNewFriendWithDisplayName:weakSelf.label.text andFriendType:I_ADDED_THIS_FRIEND withUserName:weakSelf.label.text];
                            weakSelf.addButton.tintColor = [UIColor greenColor];
                            [weakSelf.addButton setImage:[UIImage imageNamed:@"correct-mark"] forState:UIControlStateNormal];
                        });

                    }else{
                        basicAlertMessage(@"Failed to add Friend")
                    }
                }];


            }else{ // delete friend
                // DONT SEND weakself.label THIS SHOULD BE AN ERROR
                // what the hell xcode

                [Delete removeFriend:me.username andPass:me.password andFriend:weakSelf.label.text andFriendType:I_ADDED_THIS_FRIEND andComp:^(BOOL success, id res) {
                    if (success) {
                        // than
                        dispatch_async(dispatch_get_main_queue(),^{
                            [SnapDelete deleteFriend:weakSelf.label.text withUserName:weakSelf.label.text andFriendID:nil];
                            weakSelf.addButton.tintColor = [UIColor greenColor];
                            [weakSelf.addButton setImage:[UIImage imageNamed:@"add-user"] forState:UIControlStateNormal];
                        });

                    }else{
                        basicAlertMessage(@"Failed to remove Friend")

                    }


                }];
            }
            break;
        }
        case ADDED_ME_FRIEND_CELL : {
            UserInfo *me = [SnapRead getUserInfo];

            [Post addFriend:me.username friendName:self.label.text friendType:THIS_FRIEND_ADDED_ME withComp:^(BOOL success, id res) {
                if(success){
                    dispatch_async(dispatch_get_main_queue(),^{
                        [SnapCreate createNewFriendWithDisplayName:weakSelf.label.text andFriendType:MUTUAL_FRIENDS withUserName:weakSelf.label.text];
                        weakSelf.addButton.tintColor = [UIColor greenColor];
                        [weakSelf.addButton setImage:[UIImage imageNamed:@"correct-mark"] forState:UIControlStateNormal];
                    });

                }else{
                    basicAlertMessage(@"Failed to add Friend")
                }
            }];
        }
        default:
            // great code below
            NSLog(@"This is probably an err");
            break;
    }
    initalState = !initalState;


}
- (void)initSelfManually {

    switch(cellType) {
        case FRIEND_CELL: {

            [_addButton setImage:[UIImage imageNamed:@"correct-mark"] forState:UIControlStateNormal];
            // set it to add button
            break;
        }
        case ADD_FRIEND_CELL: {

            if(!initalState){
                // we are not friends if initalstate is YES
                _addButton.tintColor = [UIColor greenColor];
                [_addButton setImage:[UIImage imageNamed:@"correct-mark"] forState:UIControlStateNormal];
            }else{
                [_addButton setImage:[UIImage imageNamed:@"add-user"] forState:UIControlStateNormal];
            }
            break;
        }
        case ADDED_ME_FRIEND_CELL: {
            if (initalState) {
                _addButton.tintColor = [UIColor greenColor];
                [_addButton setImage:[UIImage imageNamed:@"add-user"] forState:UIControlStateNormal];
            }
            break;
        }
        default:
            NSLog(@"This is probably an err");
            break;
    }



}
@end
