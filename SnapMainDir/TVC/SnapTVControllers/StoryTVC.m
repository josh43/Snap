//
// Created by joshua on 7/6/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "StoryTVC.h"
#import "AppDelegate.h"
#import "Story.h"
#import "StorySnapViewController.h"
#import "Utility.h"
#import "Snap.h"
#import "Content.h"
#import "Friend.h"
#import "SnapTransitionDelegate.h"
#import "MainViewController.h"
#import "SnapRead.h"
#import "UserInfo.h"
#import "StoryTableViewCell.h"
#import "RestfulSnapCRUD.h"
#import "Command.h"

/* The story TVC's job is simply to fetch what is in the data store
 * it is not responsible for updating and deleting the data this goes for all TVCS
 *
 */
@implementation StoryTVC {
    
    NSIndexPath *_lastTouchedPath;
    SnapTransitionDelegate *tranDel;
}
#pragma mark - BASIC NAV

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.autocorrectionType = NO;
    self.searchController.searchBar.autocapitalizationType = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.barTintColor = [UIColor whiteColor];
    addTopBorder(self.searchController.searchBar,[UIColor lightGrayColor].CGColor,1.25);
    addBottomBorder(self.searchController.searchBar,[UIColor lightGrayColor].CGColor,1.25);
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
    [self configureLoad];
    [self performFetch];
    setRefreshController(self.refreshControl,self, refreshHit);
    [self.tableView registerNib:[UINib nibWithNibName:@"StoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"atoryTableViewCell"];
    
    // Do any additional setup after loading the view.
}

/*
 
 +(Friend *) findFriendWithUsername:(NSString *)username andDisplayName:(NSString * )displayName;
 +(UserInfo * )getUserInfo;
 +(Snap * )getSnapWithID:(NSString *) snapID;
 +(Story * )getStoryWithUsername:(NSString *) username andDisplayName:(NSString *) displayName;
 */
- (void)viewDidAppear:(BOOL)animated {
    
    
}
/* TODO if you want sections for only stories that have or have not been viewed just use this method I think
 * - (NSArray *)itemsInSection:(NSInteger)section
 
 {
 
 NSPredicate *predicate = [NSPredicate predicateWithFormat:
 // change this line... @ The Core IOS developers cookbook
 @"SELF beginswith[cd] %@", [self firstLetter:section]];
 
 return [crayonColors.allKeys
 
 filteredArrayUsingPredicate:predicate];
 
 }
 *
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    
    
}
-(void) configureLoad{
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Story"];
    logMethod()
    // fetch all
    // not sure if this is going to work with an ordered set :::|
    request.sortDescriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc]initWithKey:@"mostRecentSnapNotSeen.dateSent" ascending:NO selector:nil],nil];
    
    NSString * currUsername = [SnapRead getUserInfo].username;
//    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"dateSent" ascending:NO],nil];
    request.predicate = [NSPredicate predicateWithFormat:@"currentUserName = %@", currUsername];
    
    
    
    // NSError * error = nil;
    // NSArray<Story *> * storyList = [cdh.context executeFetchRequest:request error:&error];
    // if(error != nil){
    //     errorMessage(@"when fetching the story list we encountered an error");
    // }
    
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                   managedObjectContext:cdh.context
                                                     sectionNameKeyPath:nil  // should do sections based on first letter case insensative
                                                              cacheName:nil];
    
    self.frc.delegate = self;
}
#pragma  mark - Refresh Control
-(void) refreshHit:(id)x{
    // refresh please
    NSLog(@"Refreshing ...");
    logMethod()
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoFinish:) userInfo:nil repeats:NO];
    
    [CommandFactory parseAndExecuteCommandList];
    [RestfulSnapCRUD checkAndUpdateSnapStory:^(BOOL i) {
        [self.refreshControl endRefreshing];
        [self configureLoad];
        [self performFetch];
        [self.tableView reloadData];
    }];
    
    
}
-(void) autoFinish:(id)res{
    [self.refreshControl endRefreshing];
}


#pragma mark - SEARCH DISPLAY CONTROLLER DELEGATE & DATA
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    searchBar.text = @"";
    [self configureLoad];
    [self performFetch];
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    
    if([searchController.searchBar.text isEqualToString:@""]){
        return;//dont do anything
    }
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Story"];
    request.sortDescriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc]initWithKey:@"mostRecentSnapNotSeen.friend.firstLetter" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],nil];
    
    
    NSString * currUsername = [SnapRead getUserInfo].username;
    // compare and case insensative
    request.predicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:@[
                                                         [NSPredicate predicateWithFormat:@"mostRecentSnapNotSeen.friend.username contains[cd] %@", searchController.searchBar.text],
                                                         [NSPredicate predicateWithFormat:@"currentUserName = %@", currUsername]
                                                         
                                                         ]
     ];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                   managedObjectContext:cdh.context
                                                     sectionNameKeyPath:@"user.firstLetter" // should do sections based on first letter case insensative
                                                              cacheName:nil];
    self.frc.delegate = self;
    [self performFetch];
    
}
#pragma mark - VIEW

- (UIImage *)myPicture {
    return nil;
}

- (CGRect)getFrameOfPicture {
    if(_lastTouchedPath == nil){
        NSLog(@"Error ");
        exit(0);
    }
    // this will return the whole
    CGRect rect = [self.tableView rectForRowAtIndexPath:_lastTouchedPath];
    // i should only use this for the xy and have the picture views width buuuuuut yolo
    // height of the cell will be like 80
    CGRect newRect = CGRectMake(rect.origin.x + 40,rect.origin.y+40,80,80);
    return newRect;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * reUse = @"storyTableViewCell";
    [tableView registerNib:[UINib nibWithNibName:@"StoryTableViewCell" bundle:nil] forCellReuseIdentifier:reUse];
    
    StoryTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:reUse
                                    forIndexPath:indexPath];
    
    
    Story *theStory = [self.frc objectAtIndexPath:indexPath];
    [cell setupWith:theStory];
    
    
    return cell;
    
}

#pragma mark - Story Viewer delegate
- (void)doneWithStory:(NSSet<Snap *> *)snapList {
    // [self.view.superview bringSubviewToFront:self.view];
}


#pragma mark story viewing methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // for transition
    _lastTouchedPath = indexPath;
    if(_lastTouchedPath == nil){
        NSLog(@"Error ");
        exit(0);
    }
    Story * story = [self.frc objectAtIndexPath:indexPath];
    
    [story sortBasedOnDate];
    logMethod()
    
    if(story.snapList.count ) {
        Snap *snap = story.mostRecentSnapNotSeen;
        [CommandFactory thisUserSawSnap:snap];
        StorySnapViewController * toPush = [[StorySnapViewController alloc] initWithFrame:self.view.frame andData:snap.content.content
                                                                          withContentType:[snap.content.contentType intValue]
                                                                                   andUrl:[snap.content getURL] orWithSnap:nil andStory:story];
        // StorySnapViewController *toPush = [self.storyboard instantiateViewControllerWithIdentifier:@"storySnapViewController"];
        // tranDel = [[SnapTransitionDelegate  alloc] initWithFromVC:self toVC:toPush];
        // toPush.modalPresentationStyle = UIModalPresentationCustom;
        //toPush.transitioningDelegate = tranDel;
        //toPush.transitioningDelegate = tranDel; // ionno bosss
        toPush.completionDelegate = self;
        toPush.story = story;
        // if this works OHH BOY first shot?!?!?
        toPush.textField.text = [NSString stringWithFormat:@"%@", snap.length];
        
        
        [toPush start];
        [self presentViewController:toPush animated:YES completion:nil];
        
        
        //[self presentViewController:toPush animated:YES completion:nil];
        
        
    }else{
        errorMessage(@"The snap chat story was empty not neccessarily an error")
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        Story * story = [self.frc objectAtIndexPath:indexPath];
        
        UserInfo * user = [SnapRead getUserInfo];
        if(user){
            if(user.story){
                if(user.story == story){
                    //delete it
                    [self.frc.managedObjectContext deleteObject:user.story];
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                          withRowAnimation:UITableViewRowAnimationFade];
                    user.story = nil;
                }
                NSLog(@"User has a story show it!!");
            }
        }
        // delete
        /*
         Friend *deleteTarget = [self.frc objectAtIndexPath:indexPath];
         [self.frc.managedObjectContext deleteObject:deleteTarget];
         [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
         withRowAnimation:UITableViewRowAnimationFade];
         */
    }
}

@end