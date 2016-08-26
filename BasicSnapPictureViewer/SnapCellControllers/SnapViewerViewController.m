//
//  SnapViewerViewController.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/5/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "SnapViewerViewController.h"
//#import "PictureInfo.h"
//#import "../PictureInfo.h"
#import "SnapTVC.h"
#import "PictureViewerInterface.h"
#import "Snap.h"

@interface SnapViewerViewController ()

@end
#define intVal(x) [x intValue]
#define decrement(x) [NSNumber numberWithInt:(intVal(x)-1)]

@implementation SnapViewerViewController





-(instancetype) initWithData:(NSData *) data withContentType:(int)content_type
                      andUrl:(NSURL *)url orSnap:(Snap *)snap andStory:(Story *) story{
    if(self = [super init]){
        _contentDisplayer = [[ContentDisplayer alloc] initWithFrame:self.view.frame andData:data withContentType:content_type andUrl:url orWithSnap:snap andStory:story];

        [self.view addSubview:_contentDisplayer.myView];
        [self.view sendSubviewToBack:_contentDisplayer.myView];


        int textFieldWidth = 30;
        int textX= self.view.frame.size.width  - textFieldWidth - 10;
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(textX,20,textFieldWidth,textFieldWidth)];
        _textField.layer.cornerRadius = textFieldWidth/2;
        _textField.layer.borderColor = [UIColor whiteColor].CGColor;
        _textField.textColor = [UIColor whiteColor];
        _textField.layer.borderWidth = 2.0f;
        _textField.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.textField];

    }

    return self;
}
- (instancetype)init {
   @throw [NSException exceptionWithName:@"Don't use this" reason:@"Because you need to init it with data" userInfo:nil];
    return nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _shouldDecrement = YES;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(finishedViewing:) userInfo:nil repeats:YES];


}

- (UIImage *)myPicture {
    return nil;
}

- (CGRect)getFrameOfPicture {
    return self.view.frame;
}
-(void)setSubviewsTo:(CGRect)rect{
    //TODO this
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_timer invalidate];
    _timer = nil;
    [self finishedViewing:self];

}
//TODO: change this method
-(void) finishedViewing:(id) x{

    if(intVal(_picInfo.length) <= 0 || x== self) {
        [_timer invalidate];
        _timer = nil;
        if(_contentDisplayer.usingQueuePlayer) {
            [_contentDisplayer stopMovie];

        }

        [self.contentDisplayer unObserveKeyValues];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.completionDelegate finishedViewingPicture:self->_picInfo];
        }];
    }else{
        if(_shouldDecrement){
            _picInfo.length = decrement(_picInfo.length);
        }
        NSLog(@"The timeleft is %@",_picInfo.length);
        _textField.text = [NSString stringWithFormat:@"%@",_picInfo.length];
    }

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
