//
//  MiddleViewController.m
//  SnapchatLayout
//
//  Created by joshua on 7/3/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "MiddleViewController.h"
#import "SettingsViewController.h"
#import "PictureViewController.h"
#import "Utility.h"


@interface MiddleViewController ()
@property CGPoint last;
@end

@implementation MiddleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 2 * self.view.frame.size.height);
    self.scrollView.pagingEnabled = YES;
    
    SettingsViewController * top = [self.storyboard instantiateViewControllerWithIdentifier:@"topViewController"];
    PictureViewController * bottom = [self.storyboard instantiateViewControllerWithIdentifier:@"pictureViewController"];
     
    top.scrollView = self.parentScrollView;
    bottom.scrollView = self.parentScrollView;

    CGRect curr = self.view.frame;
    bottom.cameraButtonBounds = CGRectMake(curr.size.width/4,curr.size.height*4/5,curr.size.width/2,curr.size.height*1/5);


    [top.view setFrame:curr];
    curr = CGRectOffset(curr, 0,curr.size.height);
    [bottom.view setFrame:curr];
    [_scrollView setContentOffset:curr.origin];
    _last = curr.origin;



    [top didMoveToParentViewController:self];
    [bottom didMoveToParentViewController:self];



    [self addChildViewController:top];
    [self addChildViewController:bottom];

   
    
    
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    [_scrollView addSubview:top.view];
    [_scrollView addSubview:bottom.view];

    [_scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];


    // Do any additional setup after loading the view.
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"frame"]){
        NSLog(@"MiddleViewController.scroll.frame %@",change);
    }else if([keyPath isEqualToString:@"bounds"]){
        // bounds
        NSLog(@"MiddleViewController.scroll.bounds %@",change);
    }else if([keyPath isEqualToString:@"contentOffset"]){
        // bounds
        if(_scrollView.contentOffset.y < self.view.frame.size.height/2){
            // re-enforcing view scrollability
            self.parentScrollView.scrollEnabled = NO;
            
        }else{
            self.parentScrollView.scrollEnabled = YES;
        }
        NSLog(@"MiddleViewController.scroll.contentOffset %@",change);
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Scroll View Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint newVal = scrollView.contentOffset;
    CGPoint theDelta;
    delta(_last,newVal,theDelta)
    _last = newVal;


    CGRect toSetTo = _tabBar.frame;
    
    // toSetTo.origin.x = curr.x;
    NSLog(@"Thew new location of scroll bar is %@", NSStringFromCGRect(toSetTo));
    NSLog(@"Thew new location of scroll  is %@", NSStringFromCGPoint(scrollView.contentOffset));
    
    CGRect trect = _tabBar.frame;
    trect.origin.y -= theDelta.y;
    [_tabBar setFrame:trect];

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
