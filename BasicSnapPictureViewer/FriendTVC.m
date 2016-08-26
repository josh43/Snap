//
//  FriendTVC.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/5/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "FriendTVC.h"
#import "CoreDataHelper.h"
//#import "PictureInfo.h"
#import "AppDelegate.h"
#import "Friend.h"
#import "FriendTableViewCell.h"
#import "RestfulSnapCRUD.h"
//#import "Friend.h"
#define debug 1
@interface FriendTVC ()
@property(nonatomic,strong) UISearchController * searchController;
@end
@implementation FriendTVC{


}

- (void)viewDidLoad {
    [super viewDidLoad];


    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];

    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.autocorrectionType = NO;
    self.searchController.searchBar.autocapitalizationType = NO;
    CGRect rect= self.searchController.searchBar.frame;
    UIView * insetView = [[UIView alloc] initWithFrame:rect];
    [insetView setBackgroundColor:[UIColor grayColor]];

    self.searchController.searchBar.barTintColor = [UIColor whiteColor];
    self.searchController.searchBar.frame = CGRectInset(rect,0,1);
    [insetView addSubview:self.searchController.searchBar];


    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.tableView.tableHeaderView = insetView;
    self.searchController.searchBar.hidden = NO;
    self.tableView.showsVerticalScrollIndicator = YES; // YAAAASS

    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
    //self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.backgroundColor = [UIColor whiteColor];
    //[self configureLoad];
    //[self performFetch];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"friendTableViewCell"];

    _showAddButton = NO;
    FriendTVC * ftvc = self;
    [RestfulSnapCRUD checkAndUpdateFriendList:^(BOOL i) {
        if(ftvc){
            [ftvc.tableView reloadData];
        }
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {


}
-(void) configureLoad{
    @throw [NSException exceptionWithName:@"Overide method" reason:@"You have to" userInfo:nil];

}

#pragma mark - SEARCH DISPLAY CONTROLLER DELEGATE & DATA


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

    searchBar.text = @"";
    [self configureLoad];
    [self performFetch];
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {

}


#pragma mark - VIEW
static FriendTableViewCell  *STATIC_FRIEND_CELL= nil;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {


    if(!STATIC_FRIEND_CELL){
        STATIC_FRIEND_CELL = [[FriendTableViewCell alloc]init];
    }

    return STATIC_FRIEND_CELL.frame.size.height;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reUse = @"friendTableViewCell";
    [tableView registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"friendTableViewCell"];

    FriendTableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:reUse
                                            forIndexPath:indexPath];

    Friend * theFriend = [self.frc objectAtIndexPath:indexPath];


    cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    [cell.label setText:theFriend.username];
    if([theFriend.friendType intValue] == MUTUAL_FRIENDS) {
        [cell setFriendCellType:FRIEND_CELL WithInitalState:YES];
    }else{
        [cell setFriendCellType:ADDED_ME_FRIEND_CELL WithInitalState:YES];
    }

    cell.imageView.clipsToBounds = YES;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;


    return cell;

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
// dont do anything atm
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}
- (void)tableView:(UITableView *)tableView
        commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
        forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {

    }
}


@end
