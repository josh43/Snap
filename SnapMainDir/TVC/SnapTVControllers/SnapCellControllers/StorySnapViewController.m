#import "Snap.h"//
// Created by joshua on 7/6/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "StorySnapViewController.h"
#import "Content.h"
#import "StoryViewerDelegate.h"
#import "Story.h"
#import "Command.h"


#define intVal(x) [x intValue]
#define decrement(x) [NSNumber numberWithInt:(intVal(x)-1)]
@implementation StorySnapViewController {

    BOOL haveNoPlayedYet;
}
-(instancetype) initWithFrame:(CGRect) frame andData:(NSData *) data withContentType:(int)content_type
                       andUrl:(NSURL *)url orWithSnap:(Snap *)snap andStory:(Story *)story{
    if(self = [super init]){
        _contentDisplayer = [[ContentDisplayer alloc] initWithFrame:self.view.frame andData:data
                                                    withContentType:content_type andUrl:url
                                                         orWithSnap:snap andStory:story];

        [self.view addSubview:_contentDisplayer.myView];
        [self.view sendSubviewToBack:_contentDisplayer.myView];


        _story = story;
        int textFieldWidth = 30;
        int textX= self.view.frame.size.width  - textFieldWidth - 10;
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(textX,20,textFieldWidth,textFieldWidth)];
        _textField.layer.cornerRadius = textFieldWidth/2;
        _textField.layer.borderColor = [UIColor whiteColor].CGColor;
        _textField.textColor = [UIColor whiteColor];
        _textField.layer.borderWidth = 2.0f;
        _textField.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.textField];
        haveNoPlayedYet = YES;

    }

    return self;
}


- (instancetype)init {
    @throw [NSException exceptionWithName:@"Don't use this" reason:@"Because you need to init it with data" userInfo:nil];
    return nil;
}

-(void) start{
    if([_story.mostRecentSnapNotSeen.content.contentType intValue] == IMAGE_CONTENT){
        [_contentDisplayer bringImageViewToFront];
    }else{
        // load up video
        haveNoPlayedYet = NO;
        [_contentDisplayer startMovie];
    }

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _shouldDecrement = YES;
    _currentPictureInList = [_story.snapList  indexOfObject:_story.mostRecentSnapNotSeen];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(everySecond:) userInfo:nil repeats:YES];
    _currentPictureViewTime = 0;



}
#pragma mark - Transition

- (void)setSubviewsTo:(CGRect)rect {


}


- (void)setCornerRadiusTo:(CGFloat)radius {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.duration = 4.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //animation.fromValue = @(_imageField.layer.cornerRadius);
    animation.toValue = @(0);
    animation.removedOnCompletion = YES;
    //[_imageField.layer addAnimation:animation forKey:@"cornerRadius"];
}
- (void)setSubviewsTo:(CGRect)rect withCornerRadius:(CGFloat)radius {
    [self setSubviewsTo:rect];

}

- (UIImage *)myPicture {
    return nil;
}

- (CGRect)getFrameOfPicture {
    return self.view.frame;
}
// TODO make it so it detects swipes so you can get ouXt of viewing
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // skip picture basically

        [self everySecond:self];
}
-(void)everySecond:(id) x{
    Snap * curr = [_story.snapList  objectAtIndex:_currentPictureInList];
    if(intVal(curr.length) <= _currentPictureViewTime || x== self) {
        if(_currentPictureInList+ 1 >= _story.snapList.count){
            //were done
            [_timer invalidate];
            _timer = nil;
            // reset the story
            _story.mostRecentSnapNotSeen = [_story.snapList  firstObject];
            if(_contentDisplayer.usingQueuePlayer) {
                [_contentDisplayer stopMovie];
            }
            [self.contentDisplayer unObserveKeyValues];
            [self dismissViewControllerAnimated:YES completion:^{

            }];
        }else{
            // switch pictures and keep going
            _currentPictureViewTime = 0;
            _currentPictureInList++;
            Snap * mostRecent = [_story.snapList objectAtIndex:_currentPictureInList];
            [CommandFactory thisUserSawSnap:mostRecent];

            _story.mostRecentSnapNotSeen = mostRecent;
            _textField.text = [NSString stringWithFormat:@"%@", mostRecent.length];
            if([mostRecent.content.contentType intValue]== IMAGE_CONTENT) {
                // automatically calls bringImageViewToFront! :)
                [_contentDisplayer loadAndDisplayImage:[mostRecent.content getUIImage]];
            }else{

                [_contentDisplayer bringMovieViewToFront];
                if(haveNoPlayedYet){
                    haveNoPlayedYet = NO;
                    [_contentDisplayer startMovie];

                }else {
                    [_contentDisplayer playNextMovie];
                }

            }
        // it could be the case that after initalizing a new view you need to reload
            [self.view reloadInputViews];

        }
    }else{
        _currentPictureViewTime++;
        NSLog(@"The timeleft is %i",_currentPictureViewTime);
        // visibility time
        _textField.text = [NSString stringWithFormat:@"%i",[curr.length intValue] - _currentPictureViewTime];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Cancel by swipe
-(void) onSwipe{
    [_timer invalidate];
    _timer = nil;

    // canceled the story
    if(_currentPictureInList < _story.snapList.count -1) {
        // the touch is going to automatically increment it one
        _story.mostRecentSnapNotSeen = [_story.snapList  objectAtIndex:(_currentPictureInList+1)];
    }else{
        _story.mostRecentSnapNotSeen = [_story.snapList  firstObject];

    }
    if(_contentDisplayer.usingQueuePlayer) {
        [_contentDisplayer stopMovie];
    }
    [self.contentDisplayer unObserveKeyValues];
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
#pragma mark - SWIPE VIEW CONTROLLER methods
- (void)swipeDown:(id)swipeDown {

    [self onSwipe];
}

- (void)swipeUp:(id)swipeUp {

}

- (void)swipeLeft:(id)swipeLeft {
    [self onSwipe];
}

- (void)swipeRight:(id)swipeRight {
}

@end