//
// Created by joshua on 7/8/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "MyFriendsTVC.h"
#import "AppDelegate.h"
#import "Friend.h"
#import "RestfulSnapCRUD.h"
#import "Delete.h"
#import "SnapRead.h"
#import "UserInfo.h"
#import "SnapCreate.h"
#import "Utility.h"
#import "SnapDelete.h"

@implementation MyFriendsTVC {

}


- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.navigationController){
        UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(doneWithTVC:)];
        self.navigationItem.leftBarButtonItem = back;
        self.navigationItem.title = @"My Friends";
    }
    [self configureLoad];
    [self performFetch];
    [RestfulSnapCRUD checkAndUpdateFriendList:^(BOOL i) {

    }];
}
-(void)doneWithTVC:(id)X{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)configureLoad {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    request.sortDescriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc]initWithKey:@"firstLetter" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],nil];
    
        NSString * currUsername = [SnapRead getUserInfo].username;

    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                                                                        @[
                                                                             [NSPredicate predicateWithFormat:@"friendType = %d", (MUTUAL_FRIENDS)],
                                                                             [NSPredicate predicateWithFormat:@"currentUserName = %@", currUsername]
                                                                         ]
                         ];

    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                   managedObjectContext:cdh.context
                                                     sectionNameKeyPath:@"firstLetter" // should do sections based on first letter case insensative
                                                              cacheName:nil];
    self.frc.delegate = self;

}

- (void)tableView:(UITableView *)tableView
        commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete){
        // delete it
        CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];

        Friend *  theFriend = [self.frc objectAtIndexPath:indexPath];
        UserInfo * me = [SnapRead getUserInfo];


        [Delete removeFriend:me.username  andPass:me.password andFriend:theFriend.username andFriendType:1 andComp:^(BOOL success, id o) {
            if(success){
                NSLog(@"Succesfuly removed friend %@",theFriend.username);
                dispatchAsyncMainQueue([SnapDelete deleteFriend:theFriend.username withUserName:theFriend.username andFriendID:nil];);

            }else{
                dispatchAsyncMainQueue(basicAlertMessage(@"unable to remove friend please try again later"););
                // add him back
            }
        }];
    }
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if([searchController.searchBar.text isEqualToString:@""]){
        return;//dont do anything
    }
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    request.sortDescriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc]initWithKey:@"firstLetter" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],nil];
// compare and case insensative
    
    NSString * currUsername = [SnapRead getUserInfo].username;

    
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
            @[
                    [NSPredicate predicateWithFormat:@"username contains[cd] %@", searchController.searchBar.text],
                    [NSPredicate predicateWithFormat:@"friendType = %d",(MUTUAL_FRIENDS), searchController.searchBar.text],
                    [NSPredicate predicateWithFormat:@"currentUserName = %@", currUsername]


            ]
    ];

    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                   managedObjectContext:cdh.context
                                                     sectionNameKeyPath:@"firstLetter" // should do sections based on first letter case insensative
                                                              cacheName:nil];
    self.frc.delegate = self;
    [self performFetch];
}
@end