//
// Created by joshua on 7/8/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "AddedMeTVC.h"
#import "Friend.h"
#import "AppDelegate.h"
#import "SnapRead.h"
#import "UserInfo.h"

@implementation AddedMeTVC {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.navigationController){
        UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(doneWithTVC:)];
        self.navigationItem.leftBarButtonItem = back;
        self.navigationItem.title = @"Users That Added Me";
    }
    [self configureLoad];
    [self performFetch];
}
-(void)doneWithTVC:(id)X{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configureLoad {
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Friend"];
    request.sortDescriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc]initWithKey:@"firstLetter" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],nil];
    
    NSString * currUsername = [SnapRead getUserInfo].username;
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"friendType = %d", THIS_FRIEND_ADDED_ME],
                        [NSPredicate predicateWithFormat:@"currentUserName = %@", currUsername]
                          ]
                         ];

    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                   managedObjectContext:cdh.context
                                                     sectionNameKeyPath:nil // should do sections based on first letter case insensative
                                                              cacheName:nil];
    self.frc.delegate = self;

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
                    [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"username", searchController.searchBar.text],
                    [NSPredicate predicateWithFormat:@"friendType = %d", THIS_FRIEND_ADDED_ME, searchController.searchBar.text],
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