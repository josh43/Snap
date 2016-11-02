//
//  PictureViewController.m
//  SnapchatLayout
//
//  Created by joshua on 7/3/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "PictureViewController.h"

@interface PictureViewController ()

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark HANDLE SWIPE GESTURES
- (void)swipeDown:(id)swipeDown {
    NSLog(@"Received a swipe down SVC");
    _scrollView.scrollEnabled = NO;

}

- (void)swipeUp:(id)swipeUp {
    
    NSLog(@"Received a swipe up SVC");

    
    
}

- (void)swipeLeft:(id)swipeLeft {
    // prevent swiping left and right
    
}

- (void)swipeRight:(id)swipeRight {
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
