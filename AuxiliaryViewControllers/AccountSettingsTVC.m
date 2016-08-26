//
// Created by joshua on 7/7/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "AccountSettingsTVC.h"
#import "AccountCell.h"
#import "Utility.h"
#import "SettingsViewController.h"
#import "UserInfo.h"
#import "SnapRead.h"
#import "SnapDelete.h"
#import "LoginAndRegisterViewController.h"
#import "Utility.h"
typedef void (^Notification)(void);


@implementation AccountSettingsTVC {
    NSArray<NSString *>  *settingList;
    NSArray<NSString *>  * matchingList;
    NSArray<Notification> * blockList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(doneWithTVC:)];
    self.navigationItem.leftBarButtonItem = back;
    self.navigationItem.title = @"Settings";
    settingList = @[@"Name",@"Username",@"Email",@"Mobile Number",@"Password",@"Notifications",@"Log Out"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountCell" bundle:nil] forCellReuseIdentifier:@"accountSettingsCell"];
    [self setupBlockList];
    self.tableView.scrollEnabled = NO;

    UserInfo * me = [SnapRead getUserInfo];
    matchingList = @[me.username,me.username,@"Placeholder",@"",@"",@"Placeholder",@"Placeholder"];



}
-(void) setupBlockList{
    blockList = @[^{
            NSLog(@"name block");
    },^{
            NSLog(@"username block");
    },^{
            NSLog(@"email block");
    },^{
            NSLog(@"mobile number block");
    },^{
            NSLog(@"password block");
    },^{
            NSLog(@"Notification block");
    },^{
            [SnapDelete deleteDefaultUser];


        LoginAndRegisterViewController * lvc = loadViewController(@"loginViewController");
        [self presentViewController:lvc animated:YES   completion:nil];
            NSLog(@"Log out block");
    }];
}
-(void)doneWithTVC:(id)x{

    [_adjustScrollDelegate adjustScroll];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return settingList.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    blockList[indexPath.row]();

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuse = @"accountSettingsCell";

    AccountCell * cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    if(cell == nil){

        cell = loadNibNamed(@"AccountCell");
                //
        // [[NSBundle mainBundle] loadNibNamed:@"AccountCell" owner:self options:nil][0];
    }
    cell.leftField.text = settingList[indexPath.row];
    cell.rightField.text = matchingList[indexPath.row];
    cell.rightField.textColor = [UIColor grayColor];




    return cell;
}


@end