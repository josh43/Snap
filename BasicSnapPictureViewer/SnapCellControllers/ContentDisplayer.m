//
// Created by joshua on 7/11/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "ContentDisplayer.h"
#import "Content+CoreDataProperties.h"
#import "Story.h"
#import "Snap.h"
#import "VideoLayer.h"
#import "Utility.h"


@implementation ContentDisplayer {
    int totalTracksWaitingOn;

    int currentTrack;
    BOOL readyToPlay;

    // keep a reference to them so i can remove the kvo relationship
    NSArray<AVPlayerItem *> *items;
    BOOL userRequestedPlay;
}

-(instancetype) initWithFrame:(CGRect) frame andData:(NSData *) data withContentType:(int)content_type
                       andUrl:(NSURL *)url orWithSnap:(Snap *)snap andStory:(Story *)story{

    if(self = [super init]) {
        _myView = [[UIView alloc] initWithFrame:frame];

        _data = data.copy;
        _contentType = content_type;
        _url = url.copy;
    }

    readyToPlay = YES;
    totalTracksWaitingOn= 0;
    if(_contentType == IMAGE_CONTENT){
        self.iView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:_data]];
        self.iView.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        self.iView.image = [UIImage imageWithData:data];
        [self.myView addSubview:_iView];
        [self.myView bringSubviewToFront:_iView];

    }

  
     _usingQueuePlayer = NO;
    if(snap){
        if([snap.content.contentType intValue]== VIDEO_CONTENT){
            items = @[[AVPlayerItem playerItemWithURL:[snap.content getURL]]];
            [items[0] addObserver:self forKeyPath:@"status" options:0 context:nil];
            totalTracksWaitingOn++;
            readyToPlay = NO;
            _usingQueuePlayer = YES;

        }
    }else{
        NSMutableArray <AVPlayerItem *>  * tempItems = [[NSMutableArray <AVPlayerItem *> alloc]init];


        for(Snap * snap in story.snapList){
            if([snap.content.contentType intValue] == VIDEO_CONTENT){
                [tempItems addObject:[AVPlayerItem playerItemWithURL:[snap.content getURL]]];
                [tempItems[totalTracksWaitingOn++] addObserver:self forKeyPath:@"status" options:0 context:nil];
                readyToPlay = NO;
                _usingQueuePlayer = YES;
            }

        }
        items = [NSArray arrayWithArray:tempItems];

        // check all snaps of story
    }

    // GETTING THE TIME [[[[[playerItem tracks] objectAtIndex:0] assetTrack] asset] duration];
    //  maybe more like this ---> [[[_moviePlayer.items objectAtIndex:0] asset] duration]
    // If you want to skip to the next item, you send the queue player an advanceToNextItem message
    if(_usingQueuePlayer) {
        _vidLayer = [[VideoLayer  alloc] initWithFrame:self.myView.frame];
        [_vidLayer setPlayer:[[AVQueuePlayer alloc] initWithItems:items]];
        [self.myView addSubview:_vidLayer];

    }


    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(id )change context:(void *)context {
    if([keyPath isEqualToString:@"status"]){
        totalTracksWaitingOn--;
        if(items.count > totalTracksWaitingOn){
            readyToPlay = YES;
            if(userRequestedPlay){
                [self startMovie];
            }
        }
    }

}
-(void) unObserveKeyValues{
    if(!_usingQueuePlayer){return;}
    //AVQueuePlayer * player = [self.vidLayer player];
    for(AVPlayerItem * item in items){
        //    [self.stillImageOutput removeObserver:self forKeyPath:@"capturingStillImage" context:CapturingStillImageContext];
        [item removeObserver:self forKeyPath:@"status" context:nil];

    }
}
- (instancetype)init {

    NSException* myException = [NSException
            exceptionWithName:@"Dont use this init"
                       reason:@"You need to provide proper data files"
                     userInfo:nil];
    @throw myException;
}

- (void)viewDidLoad {

}

- (void)startMovie {
    if(!readyToPlay) {
        userRequestedPlay = YES;
        return;
    }
    [[self.vidLayer player]play];
}
-(void)playNextMovie{
    [[self.vidLayer player]advanceToNextItem];
}
-(void) stopMovie{
    [[self.vidLayer player] pause];
}
-(void) bringMovieViewToFront{
    logMethod()
    if(_usingQueuePlayer){
        [self.myView bringSubviewToFront:_vidLayer];
    }else{
        NSLog(@"This is probably an error you are calling this while not using the queue player");
    }
}

-(void) bringImageViewToFront{
    logMethod()
    if(_usingQueuePlayer){
        [self.myView bringSubviewToFront:_iView];
    }else{
        NSLog(@"This is probably an error you are calling this while not using the queue player");
    }
}
-(void)loadAndDisplayImage:(UIImage *)image{
    if(!self.iView){
        [self loadImageView];
        if(_usingQueuePlayer){
            [self stopMovie];
            [self.myView sendSubviewToBack:_vidLayer];

        }
    }
    [self.myView bringSubviewToFront:self.iView];

    self.iView.image = image;
}

- (void)loadImageView {
    self.iView = [[UIImageView alloc] init];
    self.iView.frame = CGRectMake(0,0,self.myView.frame.size.width,self.myView.frame.size.height);
    [self.myView addSubview:_iView];
    [self.myView bringSubviewToFront:_iView];

}



@end