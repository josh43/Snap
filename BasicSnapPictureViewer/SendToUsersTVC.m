//
// Created by joshua on 7/11/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "SendToUsersTVC.h"
#import "SendToFriendTableViewCell.h"
#import "Friend.h"
#import "ContentFinishedViewController.h"
#import "Utility.h"


@implementation SendToUsersTVC {

    UIView *sendView;
    UILabel *text;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    _usersToSendTo = [[NSMutableArray<NSIndexPath *> alloc ]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"SendToFriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"sendToFriendTableViewCell"];
    float size = self.view.frame.size.height/10;
     sendView = [[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-size,self.view.frame.size.width,size)];
    [sendView setBackgroundColor:[UIColor colorWithRed:60 green:178 blue:226 alpha:1.0]];
    // not working SIGH
    [sendView setTintColor:[UIColor colorWithRed:60 green:178 blue:226 alpha:1.0]];
    //60 178 226

    [sendView setNeedsDisplay];
    

    // hard code NOOOO
     text = [[UILabel alloc] initWithFrame:CGRectMake(10,10,self.view.frame.size.width-120,size)];
    text.text = @"Send To Users";
    text.textColor = [UIColor whiteColor];
     [text setBackgroundColor:[UIColor colorWithRed:60 green:178 blue:226 alpha:1.0]];
    [text setTintColor:[UIColor colorWithRed:60 green:178 blue:226 alpha:1.0]];

    
    
    UIButton  * sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-120,10,120,size)];

    [sendButton setImage:[UIImage imageNamed:@"sentAndSeenPurpleFill"] forState:UIControlStateNormal];
    [sendView addSubview:text];
    [sendView addSubview:sendButton];
    [sendButton addTarget:self action:@selector(userClickedSend:) forControlEvents:UIControlEventTouchUpInside];

    [self.navigationController.view addSubview:sendView];
    [self.navigationController.view bringSubviewToFront:sendView];
    sendView.hidden = YES;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}
-(void)userClickedSend:(id)x{
    NSLog(@"You should send now!!!");
    [self onFinish];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reUse = @"sendToFriendTableViewCell";
    [tableView registerNib:[UINib nibWithNibName:@"sendToFriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"friendTableViewCell"];

    SendToFriendTableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:reUse
                                            forIndexPath:indexPath];

    Friend * friend = [self.frc objectAtIndexPath:indexPath];
    // index Path will be used for easy lookups
    cell.myDelegate = self;
    cell.indexPath = indexPath;
    cell.label.text = friend.username;
    Friend * theFriend = [self.frc objectAtIndexPath:indexPath];
    [cell.label setText:theFriend.username];

    return cell;

}

-(void) onFinish{
    NSMutableArray <Friend *> * toSend = [[NSMutableArray <Friend *> alloc]init];
    logMethod()
    for(NSIndexPath * path in _usersToSendTo){
        Friend * f = [self.frc objectAtIndexPath:path];
        [toSend addObject:f];
        if(debugging) {
            NSLog(@"Seinding content to %@\n",f.username);
        }
    }

    [self.onCompletionDelegate sendContentToFriendList:toSend];
    [self dismissViewControllerAnimated:YES completion:^{
        [self->_onCompletionDelegate shouldFinish];
    }];
}

- (void)userDidCheckButton:(BOOL)state withTarget:(NSString *)username withIndexPath:(NSIndexPath *) indexPath{
    NSLog(@"We should %@ to user %@",state == YES ? @"send" :@"not send",username);

    if(state == YES) {
        NSLog(@"Added %@ to list of index paths",indexPath);
        [_usersToSendTo addObject:indexPath];


    }else if(state == NO){
        // remove
        NSLog(@"Removed %@ from list of index paths",indexPath);
        [_usersToSendTo removeObject:indexPath];
    }
    
    if(_usersToSendTo.count > 0){
        sendView.hidden = NO;
    }else{
        sendView.hidden = YES;
    }

}


@end