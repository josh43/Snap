//
//  SettingsViewController.m
//  SnapchatLayout
//
//  Created by joshua on 7/3/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "SettingsViewController.h"
#import "AccountSettingsTVC.h"
#import "MiddleViewController.h"
#import "Utility.h"
#import "FriendTVC.h"
#import "MyFriendsTVC.h"
#import "AddedMeTVC.h"
#import "AddFriendTVC.h"


 
@interface SettingsViewController ()

@end

@implementation SettingsViewController {
    BOOL comingFromAccountSettings;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(tappedProfilePic:)];
    [_profilePic addGestureRecognizer:singleTap];
    [_profilePic setMultipleTouchEnabled:YES];
    [_profilePic setUserInteractionEnabled:YES];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL) isInBounds:(CGRect) rect withPoint:(CGPoint) point{
    if(point.x < rect.origin.x || point.y < rect.origin.y){
        return NO;
    }else if(point.x > (rect.origin.x + rect.size.width) || point.y > (rect.origin.y + rect.size.height) ){
        return NO;
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for(UITouch * t in touches){
        CGPoint point = [t locationInView:self.view];
        if([self isInBounds:_addedMeView.frame withPoint:point]){
            [self tappedAddedMe];
        }else if([self isInBounds:_addFriendsView.frame withPoint:point]){
            [self tappedAddFriend];
        }else if([self isInBounds:_myFriendsView.frame withPoint:point]){
            [self tappedFriendList];
        }
    }
}

#pragma mark button presss
#pragma mark - helper methods for tab bar
-(void)adjustTabScroll{
    if([self.parentViewController isKindOfClass:[MiddleViewController class]]){
        MiddleViewController  * mvc = (MiddleViewController*)self.parentViewController;
        // make sure its at 2 * height
        if(mvc.tabBar.frame.origin.y < 1000) {
            // absolutely sooo hacky
            CGRect toSetTo = CGRectMake(mvc.tabBar.frame.origin.x, mvc.tabBar.frame.origin.y + self.view.frame.size.height, mvc.tabBar.frame.size.width, mvc.tabBar.frame.size.height);
            mvc.tabBar.frame = toSetTo;
            NSLog(@"%@", NSStringFromCGRect(mvc.tabBar.frame));
        }
    }else{
        errorMessage(@"Error when adjusting scroll the parent view controller was not a Middle View Controlelr")
    }
}
-(void) adjustScroll{
    //_tabBar

    logMethod()

}

- (void)setTabBarHidden:(BOOL)b {
    if([self.parentViewController isKindOfClass:[MiddleViewController class]]){
        MiddleViewController  * mvc = (MiddleViewController *)self.parentViewController;
            mvc.tabBar.hidden = b;

    }
}
// I might have to make a custom transition just so i can keep the freaking tab bar down.... :(
#pragma  mark - transitions
- (IBAction)settingsButtonPressed:(id)sender {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    AccountSettingsTVC  * aTVC = [[AccountSettingsTVC alloc]init];
    UINavigationController  * toPush = [[UINavigationController alloc] initWithRootViewController:aTVC];
    aTVC.adjustScrollDelegate = self;
    // when I present this view controller it changes my tab automagically...... Even when i kvo observe I do not get notified
    // yay apple
    [self setTabBarHidden:YES];
    [self showViewController:toPush sender:self];
}

-(void) tappedAddedMe{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    AddedMeTVC * addedMeTVC= [[AddedMeTVC alloc]init];

    [self setTabBarHidden:YES];
    UINavigationController  * nav = [[UINavigationController alloc] initWithRootViewController:addedMeTVC];
    [self showViewController:nav sender:self];
}
-(void) tappedFriendList{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    MyFriendsTVC * friendTVC = [[MyFriendsTVC alloc]init];

    [self setTabBarHidden:YES];
    UINavigationController  * nav = [[UINavigationController alloc] initWithRootViewController:friendTVC];
    [self showViewController:nav sender:self];
}
-(void) tappedAddFriend{

    AddFriendTVC * friendTVC = [[AddFriendTVC alloc]init];

    [self setTabBarHidden:YES];
    UINavigationController  * nav = [[UINavigationController alloc] initWithRootViewController:friendTVC];
    [self showViewController:nav sender:self];

    NSLog(@"%@",NSStringFromSelector(_cmd));
}
-(void)tappedProfilePic:(id)sender{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (IBAction)tappedTrophy:(id)sender {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (IBAction)tappedUserInfo:(id)sender {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}


#pragma mark HANDLE SWIPE GESTURES
- (void)swipeDown:(id)swipeDown {


    NSLog(@"Received a swipe down SVC");
    
}

- (void)swipeUp:(id)swipeUp {
    _scrollView.scrollEnabled = YES;
    // This shit doesn't work which leads me to belive auto constraints are fucking killing me
    [self setTabBarHidden:NO];
    [self adjustTabScroll];
    NSLog(@"Received a swipe up SVC");
    
    
}

- (void)swipeLeft:(id)swipeLeft {
    _scrollView.scrollEnabled = NO;

    // prevent swiping left and right
    
}

- (void)swipeRight:(id)swipeRight {
    _scrollView.scrollEnabled = NO;
    // prevent swiping left and right
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
