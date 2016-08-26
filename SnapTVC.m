//
//  SnapTVC.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/5/16.
//  Copyright © 2016 joshua. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "SnapTVC.h"
#import "AppDelegate.h"
#import "Snap.h"
#import "Friend.h"
#import "Content.h"
#import "Utility.h"
#import "SnapTableViewCell.h"
#import "Command.h"
#import "SnapRead.h"
#import "UserInfo.h"

//#import "Picture.h"

@implementation TimerData


@end
@interface SnapTVC() {

}
@end
#define intVal(x) [x intValue]
#define decrement(x) [NSNumber numberWithInt:(intVal(x)-1)]
@implementation SnapTVC
{
    NSIndexPath *_lastTouchedPath;
}
#pragma mark - NAVIGATION BASICS
- (void)viewDidLoad {
    [super viewDidLoad];

    //UINavigationBar  * theBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height/6)];
    //[theBar setBarTintColor:[UIColor colorWithRed:1 green:165 blue:136 alpha:1.0]];
    // 01A588 in hex siiiiigh

    //[self.view addN
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;

    self.searchController.searchBar.autocorrectionType = NO;
    self.searchController.searchBar.autocapitalizationType = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.barTintColor = [UIColor whiteColor];
    addBottomBorder(self.searchController.searchBar,[UIColor lightGrayColor].CGColor,1.25);
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"SnapTableViewCell" bundle:nil] forCellReuseIdentifier:@"snapTableViewCell"];

//    self.refreshControl = [[UIRefreshControl alloc]init];
//    [self.refreshControl addTarget:self action:@selector(refreshHit:) forControlEvents:UIControlEventValueChanged];
//
    setRefreshController(self.refreshControl,self, refreshHit);
//     Do any additional setup after loading the view.
    
    
    // Respond to changes in underlying store
    [self configureLoad];
    [self performFetch];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(performFetch)
     
                                                 name:NSManagedObjectContextDidSaveNotification
     
                                               object:nil];
}
- (void)viewWillDisappear:(BOOL)animated {
   

}
- (void) configureLoad{
    CoreDataHelper *cdh = [(AppDelegate *)[[UIApplication sharedApplication] delegate] cdh];
    // look for all snaps with a  certain type
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Snap"];
//  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"wordCategory.firstLetter = %@", firstLetter];
    NSString * currUsername = [SnapRead getUserInfo].username;

    request.sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"dateSent" ascending:NO],nil];
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[
            [NSCompoundPredicate orPredicateWithSubpredicates:
                    @[
                        [NSPredicate predicateWithFormat:@"snapType = %@", [NSNumber numberWithInt:SNAP_PERSONAL_TYPE]],
                        [NSPredicate predicateWithFormat:@"snapType = %@", [NSNumber numberWithInt:SNAP_USER_SENT_TYPE]]
                    ]
            ],
            [NSPredicate predicateWithFormat:@"currentUserName = %@", currUsername]
    ]];

    
    //[request setFetchBatchSize:100];
    /*
     * request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[
            [NSPredicate predicateWithFormat:@"snapType = %@", [NSNumber numberWithInt:SNAP_PERSONAL_TYPE]],
            [NSPredicate predicateWithFormat:@"user.username contains[cd] %@", searchController.searchBar.text],
    ]];
     *
     *
     */
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                managedObjectContext:cdh.context
                                                      sectionNameKeyPath:nil
                                                            cacheName:nil];
    self.frc.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Transition
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
    return rect;
}
#pragma mark - Refresh Controller
//      refresh
-(void) refreshHit:(id)x{
    NSLog(@"Refreshing ...");
    logMethod()



    // its possible that the request fails
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(autoFinish:) userInfo:nil repeats:NO];

    [CommandFactory parseAndExecuteCommandList];
    [RestfulSnapCRUD checkAndUpdateSnapInbox:^(BOOL i) {
        [self.refreshControl endRefreshing];
        [self configureLoad];
        [self performFetch];
        [self.tableView reloadData];
    }];

}
-(void) autoFinish:(id)res{
    [self.refreshControl endRefreshing];
}
#pragma mark - Picture View Timing
-(void)finishedViewing:(id)x{

    TimerData *td = [x userInfo];
    if(intVal(td.picInfo.length) <=0){
        // wwhere done
        NSLog(@"Finished the timer");
        [td.timer invalidate];
        td.timer = nil;
    }else{
        td.picInfo.length = decrement(td.picInfo.length);
    }

}
-(void) finishedViewingPicture:(Snap *) pInfo{
    // check if their is  time left....
    // time will be picInfo -1
    // continue timer

    if([pInfo.hasSeen boolValue] == NO){
        // Make sure to ot re do the timer
        pInfo.hasSeen = [NSNumber numberWithBool:YES];

        pInfo.length = decrement(pInfo.length);
        TimerData *td = [[TimerData alloc]  init];
        td.picInfo = pInfo;

        td.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(finishedViewing:) userInfo:td repeats:YES];

    }


}
#pragma mark - TABLE VIEW DELEGATE METHODS
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reUse = @"snapTableViewCell";
    [tableView registerNib:[UINib nibWithNibName:@"SnapTableViewCell" bundle:nil] forCellReuseIdentifier:@"snapTableViewCell"];

    SnapTableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:reUse
                                            forIndexPath:indexPath];


    Snap * theSnap = [self.frc objectAtIndexPath:indexPath];

    [cell cellWithSnap:theSnap];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _lastTouchedPath = indexPath;
    Snap * item = [self.frc objectAtIndexPath:indexPath];

    if([item.snapType intValue] == SNAP_USER_SENT_TYPE){
        return; // you cant view it silly
    }

    if(intVal(item.length) > 0){


        [CommandFactory thisUserSawSnap:item];

        SnapViewerViewController * toPush = [[SnapViewerViewController  alloc] initWithData:item.content.content
                                                                            withContentType:[item.content.contentType intValue] andUrl:[item.content getURL] orSnap:item andStory:nil];
        toPush.completionDelegate =self;
        toPush.picInfo = item;
        if(toPush.contentDisplayer.usingQueuePlayer){
            [toPush.contentDisplayer startMovie];
        }

        [self presentViewController:toPush animated:YES completion:nil];
        if([item.hasSeen boolValue] == YES){
            // dont increment or decrement I am already doing that
            toPush.shouldDecrement = NO;
        }

        toPush.textField.text = [NSString stringWithFormat:@"%@",item.length];
        // make sure its no n nulll
    }

    
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



    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Snap"];
    request.sortDescriptors = [NSArray arrayWithObjects:[[NSSortDescriptor alloc]initWithKey:@"friend.firstLetter" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)],nil];
// compare and case insensative
            NSString * currUsername = [SnapRead getUserInfo].username;

    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[
             [NSCompoundPredicate orPredicateWithSubpredicates:
                    @[
                            [NSPredicate predicateWithFormat:@"snapType = %@", [NSNumber numberWithInt:SNAP_PERSONAL_TYPE]],
                            [NSPredicate predicateWithFormat:@"snapType = %@", [NSNumber numberWithInt:SNAP_USER_SENT_TYPE]]
                    ]
            ],
            [NSPredicate predicateWithFormat:@"friend.username contains[cd] %@", searchController.searchBar.text],
            [NSPredicate predicateWithFormat:@"currentUserName = %@", currUsername]

    ]];
//    request.predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@",@"name",searchController.searchBar.text];

    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                   managedObjectContext:cdh.context
                                                     sectionNameKeyPath:@"friend.firstLetter" // should do sections based on first letter case insensative
                                                              cacheName:nil];
    self.frc.delegate = self;
    [self performFetch];
}
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   /* if([segue.identifier  isEqual:  @"showSnapImage"]){
        SnapViewerViewController * vc = segue.destinationViewController;
        vc.imageField.image = _lastPicture;
        vc.textField.text = @"10";
        
    }
    */
}


@end
