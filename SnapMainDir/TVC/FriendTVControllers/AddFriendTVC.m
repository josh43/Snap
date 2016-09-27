//
//  AddFriendTVC.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/23/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "AddFriendTVC.h"
#import "Get.h"
#import "Utility.h"
#import "SnapRead.h"
#import "Friend.h"
#import "FriendTableViewCell.h"
#import <UIKit/UIKit.h>

@interface AddFriendTVC (){
    double lastTime;
}
@property(nonatomic,strong) UISearchController * searchController;

@end

@implementation AddFriendTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lastTime =    CFAbsoluteTimeGetCurrent();
    if(self.navigationController){
        UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(doneWithTVC:)];
        self.navigationItem.leftBarButtonItem = back;
        self.navigationItem.title = @"Add Friends";
    }
    
    self.friendResults = [[NSMutableArray  alloc]init];
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
    self.tableView.backgroundColor = [UIColor whiteColor];

    [self.tableView registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"friendTableViewCell"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)doneWithTVC:(id)X{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.friendResults.count;
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    // If you cant find him in you friendList than  you guys are not  friends...
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    AddFriendTVC * weakMe = self;
    [Get findUsers:searchText withCompletion:^(BOOL success,id  friendsFound){
        if(success){
            
            NSArray * peopleFound = (NSArray *)friendsFound[@"Success"];
            NSMutableArray * toSwitchTo = [[NSMutableArray  alloc]init];
            if(peopleFound.count == 0){
                if([AddFriendTVC time:CFAbsoluteTimeGetCurrent() differsFrom:weakMe->lastTime byMoreThan:8]){
                    dispatch_async(dispatch_get_main_queue(),^{
                        
                        UIAlertView *av = [[UIAlertView alloc]
                                           initWithTitle:@"Title" message:@"Unable to find any users"
                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        [av show];
                        weakMe->lastTime = CFAbsoluteTimeGetCurrent();
                    });
                }
                return;
            }
            for(NSDictionary  * keyVal in peopleFound){
                NSString * str = keyVal[@"username"];
                NSLog(@"Found %@\n",str);
                Friend * f = nil;
                if((f = [SnapRead findFriendWithUsername:str]) == nil){
                    
                    [toSwitchTo addObject:str];
                }else if([f.friendType intValue]== I_ADDED_THIS_FRIEND){
                    [toSwitchTo addObject:str];
                    // test if hes already a friend
                    
                }    // otherwise we are mutal friends, or i added this person..
                
                
            }
            dispatch_async(dispatch_get_main_queue(),^{
                // don't edit data from background queue...
                weakMe.friendResults = toSwitchTo.copy;
            });
        }else{
            AddFriendTVC * weakSelf = self;
                if([AddFriendTVC time:CFAbsoluteTimeGetCurrent() differsFrom:weakSelf->lastTime byMoreThan:8]){
                    dispatch_async(dispatch_get_main_queue(),^{

                        UIAlertView *av = [[UIAlertView alloc]
                                           initWithTitle:@"Title" message:@"Unable to find any users"
                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        [av show];
                weakSelf->lastTime = CFAbsoluteTimeGetCurrent();
                    });
                }
                
            
               
            
        }
                           
        dispatch_async(dispatch_get_main_queue(),^{
            
            [weakMe.tableView reloadData];
        });
        
    }];
    
}
+(BOOL) time:(double)t1 differsFrom:(double)t2 byMoreThan:(int)seconds{
    return t1 -t2 > seconds;
}
//-Wno-nullability-completeness
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"friendTableViewCell"
                                    forIndexPath:indexPath];
    
    Friend * f = nil;
    cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    
    if((f = [SnapRead findFriendWithUsername:self.friendResults[indexPath.row]]) == nil){
        
        [cell.label setText:self.friendResults[indexPath.row]];
        [cell setFriendCellType:ADD_FRIEND_CELL WithInitalState:YES];
    }else{
        // test if hes already a friend
        [cell.label setText:f.username];
        
        [cell setFriendCellType:ADD_FRIEND_CELL WithInitalState:NO];
        
    }
    
    
    cell.imageView.clipsToBounds = YES;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    return cell;
    
    
}


@end
