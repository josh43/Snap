//
//  MainViewController.m
//  SnapchatLayout
//
//  Created by joshua on 7/3/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "MainViewController.h"
#import "MiddleViewController.h"
#import "Utility.h"
#import "SnapchatViewController.h"
#import "SnapStoryViewController.h"

void *scrollContext = &scrollContext;

@interface MainViewController ()
@property CGPoint last;

@end

@implementation MainViewController {
     SnapStoryViewController *right;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UIView * contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3*self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:contentView];
    [_scrollView setContentSize:CGSizeMake(3*self.view.frame.size.width, self.view.frame.size.height)];
    NSLog(@"self.view.frame -- %@",NSStringFromCGRect(self.view.frame));
          
     self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    SnapchatViewController * left = [self.storyboard instantiateViewControllerWithIdentifier:@"leftViewController"];
    MiddleViewController * middle = [self.storyboard instantiateViewControllerWithIdentifier:@"middleViewController"];
    right = [self.storyboard instantiateViewControllerWithIdentifier:@"rightViewController"];

    left.onCameraTouchDelegate = self;
    right.onCameraTouchDelegate = self;
    
    middle.parentScrollView = self.scrollView;
    middle.tabBar = self.tabBar;
    
    NSLog(@"Scrollviews current view %@",NSStringFromCGRect(_scrollView.frame));
    CGRect curr = self.view.frame;
    _last = curr.origin;
    [left.view setFrame:curr];
    curr = CGRectOffset(curr, curr.size.width, 0);
    [middle.view setFrame:curr];
    curr = CGRectOffset(curr, curr.size.width, 0);
    [right.view setFrame:curr];
    
    [left didMoveToParentViewController:self];
    [middle didMoveToParentViewController:self];
    [right didMoveToParentViewController:self];
    
    [self addChildViewController:left];
    [self addChildViewController:middle];
    [self addChildViewController:right];
    
    
    
    [_scrollView addSubview:left.view];
    [_scrollView addSubview:middle.view];
    [_scrollView addSubview:right.view];
    _scrollView.alwaysBounceVertical = NO;
  

    [self customizeTabBar];

    [_tabBar addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:scrollContext];
    [_scrollView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:scrollContext];

    self.scrollView.bounces= NO;


    [self.view bringSubviewToFront:_tabBar];
    self.tabBar.delegate = self;

   UITapGestureRecognizer * tapPressRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScreen:)];
   tapPressRecognizer.numberOfTapsRequired = 1;
   tapPressRecognizer.delegate = self;

   [self.view addGestureRecognizer:tapPressRecognizer];

    // Do any additional setup after loading the view.
}



- (void)customizeTabBar {
    //[_tabBar setTintColor:[UIColor clearColor]];
    _tabBar.backgroundImage = [UIImage new];
    [_tabBar setShadowImage:[UIImage new]];



}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    if(context == scrollContext){
        if([keyPath isEqualToString:@"bounds"]){
            NSLog(@"scrollview.bounds %@",change);
        }else {
            NSLog(@"scrollview.frame %@",change);
        }
    }
    else if([keyPath isEqualToString:@"frame"]){
        NSLog(@"The bar rect changed \n %@",change);

    }

}

-(void)onCameraTouch{
    [self tabBar:self.tabBar didSelectItem:_middleItem];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger  curr = ((int)self.scrollView.bounds.origin.x / (int)self.view.frame.size.width);
    if(curr > 2)
        curr = 2;

    NSInteger  loc = 0;
    if(item == _leftItem){
        if(curr == 0){
            return;
        }
        loc = 0;
    }else if(item == _middleItem){
        // make sure its still visible
        if(curr == 1){
            return;
        }
        loc = 1;
    }else if(item == _rightItem){
        if(curr == 2){
            return;
        }
        loc = 2;
    }
   
        // go right


        // loc is destination
        float dx = ((int)(loc-curr)) * self.view.frame.size.width;
        
        CGRect toScrollTo = CGRectOffset(self.scrollView.bounds, dx, 0);
        [self.scrollView scrollRectToVisible:toScrollTo animated:YES];
        
  
    
}
#pragma mark - Custom transitions

- (UIImage *)myPicture {
    return nil;
}

- (CGRect)getFrameOfPicture {
    return _transitionRect;
}

#pragma mark - Scroll View delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger  curr = ((int)self.scrollView.bounds.origin.x / (int)self.view.frame.size.width);

    [_tabBar setSelectedItem:curr == 0 ? _leftItem : curr == 1 ? _middleItem : curr == 2 ? _rightItem : _rightItem];
    [_tabBar setNeedsDisplay];
    [_scrollView bringSubviewToFront:_tabBar];
  

}







- (void)tappedScreen:(UITapGestureRecognizer *)tappedScreen {

    CGPoint location = [tappedScreen locationInView:self.view];

            for(UIView * view in _tabBar.subviews) {


                CGRect frame = CGRectOffset(view.frame,_tabBar.frame.origin.x,_tabBar.frame.origin.y);
                if(CGRectContainsPoint(frame,location)){
                    if([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                        int index = (int) (frame.origin.x / (_tabBar.frame.size.width / 3));
                        NSLog(@"Congratulations you have clicked index %i",index);
                        [self tabBar:_tabBar didSelectItem:_tabBar.items[index]];
                    }

                }


            }

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    CGPoint location = [touch locationInView:self.view];
    if(CGRectContainsPoint(_tabBar.frame,location)){
        if(gestureRecognizer.view == self.view){
            return  YES;
        }

    }
    return NO;

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceivePress:(UIPress *)press {

    return NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return true;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
