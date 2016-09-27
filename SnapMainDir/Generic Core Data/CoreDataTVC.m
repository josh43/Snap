//
//  CoreDataTVC.m
//
//

#import "CoreDataTVC.h"
#define debug 1
@interface CoreDataTVC ()
/*
 Cascade propogates delete so if you have a one to many relationship it will delete the one and many
 Nullify just nulls out the deleted thing
 Deny stops you from deleting
 */
@end

@implementation CoreDataTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // I am adding a refresh controller

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - FETCHING

-(void)performFetch {
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    if(self.frc){
        NSError * err;
        [self.frc performFetch:&err];
        if(err){
            NSLog(@"%@ %@ %@ (Reason %@)",self.class,NSStringFromSelector(_cmd),err.localizedDescription,err.localizedFailureReason);
        }
        
        [self.tableView reloadData];
    }
}


#pragma mark - DATASOURCE

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    return self.frc.sections.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    return [[self.frc.sections objectAtIndex:section]numberOfObjects];
    
    
        
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    return [[[self.frc sections]objectAtIndex:section]name];
}
- (NSInteger)tableView:(UITableView *)tableView
        sectionForSectionIndexTitle:(NSString *)title
        atIndex:(NSInteger)index {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [self.frc sectionForSectionIndexTitle:title atIndex:index];
}
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    return self.frc.sectionIndexTitles;
}
#pragma mark - Delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    
    
    
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
             
                          withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
            
            
        case NSFetchedResultsChangeDelete:
            
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
             
                          withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
    }
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject

       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type

      newIndexPath:(NSIndexPath *)newIndexPath {
    
    
    
    if (debug==1) {NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));}
    
    UITableView *tableView = self.tableView;
    
    
    switch(type) {
            
            
            
        case NSFetchedResultsChangeInsert:
            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
             
                             withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
            
            
        case NSFetchedResultsChangeDelete:
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
             
                             withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
            
            
        case NSFetchedResultsChangeUpdate:
            
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
             
                             withRowAnimation:UITableViewRowAnimationNone];
            
            break;
            
            
            
        case NSFetchedResultsChangeMove:
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
             
                             withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
             
                             withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
    }
    
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [[self tableView] endUpdates];
}


@end
