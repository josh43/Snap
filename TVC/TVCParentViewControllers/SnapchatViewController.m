//
//  SnapchatViewController.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/26/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "SnapchatViewController.h"
#import "MainViewController.h"

@interface SnapchatViewController ()

@end

@implementation SnapchatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cameraTouched:(id)sender {
    [self.onCameraTouchDelegate onCameraTouch];
    
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
