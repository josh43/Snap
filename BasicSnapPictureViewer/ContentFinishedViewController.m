//
//  ContentFinishedViewController.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/11/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "ContentFinishedViewController.h"
#import "Content+CoreDataProperties.h"
#import "SendToUsersTVC.h"
#import "AppDelegate.h"
#import <AVKit/AVKit.h>
#import "AppDelegate.h"
#import "Story.h"
#import "Snap.h"
#import "Utility.h"
#import "UserInfo.h"
#import "SnapCreate.h"
#import "SnapRead.h"
#import "Friend.h"
#import "PictureEditorView.h"
#import "TextDelegateHandler.h"
#import "Post.h"
#import "SnapDelete.h"

@import AVFoundation;


@interface ContentFinishedViewController ()

@end

@implementation ContentFinishedViewController {
    MPMoviePlayerController *_moviePlayer;
    UIImageView * iView;
    PictureEditorView * picView;
}


- (void)viewDidLoad {
    [super viewDidLoad];




    if(_contentType == IMAGE_CONTENT){
        iView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:_data]];
        iView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);

        [self.view addSubview:iView];
        [self.view sendSubviewToBack:iView];



        picView = loadNibNamed(@"PictureEditorView");
        picView.cfvc = self;

        picView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height * 5/6);
        [self.view addSubview:picView];

        [self.view layoutIfNeeded];
        [picView layoutIfNeeded];

    }else{ // type == VIDEO_CONTENT
        // this is depricated but the other stuff looks like it would take a couple of
        // hours to implement sooooooooo
        _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:_url];
        [_moviePlayer setControlStyle:MPMovieControlStyleNone];

        [_moviePlayer prepareToPlay];
        [_moviePlayer.view setFrame:self.view.frame];
        [self.view addSubview:_moviePlayer.view];
        [self.view sendSubviewToBack:_moviePlayer.view];
        // deprecated but whats the alternative?
        _moviePlayer.repeatMode = MPMovieRepeatModeOne;
        [_moviePlayer play];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)userHitSend:(id)sender {
    SendToUsersTVC  * toPresent = [[SendToUsersTVC alloc]init];
    toPresent.onCompletionDelegate = self;
    UINavigationController  * toBase = [[UINavigationController alloc] initWithRootViewController:toPresent];
    [self presentViewController:toBase animated:YES completion:nil];
    

    NSLog(@"user hit send");
}
-(void) sendContentToFriendList:(NSMutableArray<Friend * > *) friendList{
    logMethod()
    BOOL isSnapPicture = (_moviePlayer == nil ? YES : NO);
    UserInfo * me= [SnapRead getUserInfo];
    if(me == nil && debugging){
        me = [SnapCreate createUserWithName:@"Joshua" andPasword:@"Password"];
    }


    Snap *snap;
    if(isSnapPicture){
        // picture
        UIImage *resultImage = [self getFinalImage:self];
        Content * content = [SnapCreate createContentWith:resultImage andStringURL:@"" withType:IMAGE_CONTENT];
        snap = [SnapCreate createUserSendSnapChat:[NSDate date]
                                   andContentType:IMAGE_CONTENT andLength:self.slider.value
                                          andUser:me withActualFriendList:friendList];
        snap.content = content;
        snap.snapID = DUMMY_SNAP_ID; // dummy default
        [Post sendSnap:snap toFriends:friendList orStringFriends:nil withComp:^(BOOL succ, id res) {
            // if not succes delete all snaps... muahhahha
            if(succ){
                if(res[@"Success"]){
                    return;
                }
            }
            // else we failed in some way
            [SnapDelete deleteSnapWithID:DUMMY_SNAP_ID];

        }];


    }else{
        Content * content = [SnapCreate createContentWith:nil andStringURL:_url.absoluteString withType:VIDEO_CONTENT];
        snap = [SnapCreate createUserSendSnapChat:[NSDate date]
                                   andContentType:VIDEO_CONTENT andLength:_moviePlayer.duration
                                          andUser:me withActualFriendList:friendList];
        [self generaturePermanantURLStringFrom:_url onCompletion:^(BOOL success, NSURL *theURL) {
           if(success){
               snap.snapID = DUMMY_SNAP_ID; // dummy default
               snap.content.url = theURL.absoluteString;
               [Post sendSnap:snap toFriends:friendList orStringFriends:nil withComp:^(BOOL succ, id res) {
                   // if not succes delete all snaps... muahhahha
                   if(succ){
                       if(res[@"Success"]){
                           return;
                       }
                   }
                   // else we failed in some way
                   [SnapDelete deleteSnapWithID:DUMMY_SNAP_ID];

               }];
           }else{
               basicAlertMessage(@"Failed to send video snap chat :(((");
           }
        }];


    }


    // You still have to actually send out the content!!!!
}

- (IBAction)userChangedTimeValue:(id)sender {
    NSLog(@"Changed slider val to %f",_slider.value);
    self.timerLabel.text = [NSString stringWithFormat:@"%i",(int)_slider.value];
}
- (IBAction)userPostedToStory:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Story"
                                                                   message:@"Post snap to story?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    __weak ContentFinishedViewController * cFVC = self;
    logMethod()
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              ContentFinishedViewController * strong = cFVC;
                                                                if(cFVC){
                                                                    if(debugging){
                                                                        NSLog(@"User clicked post to story WHOWOOOOOOO fun fun!");
                                                                    }
                                                                }else{
                                                                    if(debugging){
                                                                        NSLog(@"Error ContentFinishedController weak reference was null returning!");
                                                                        return;
                                                                    }
                                                                }

                                                               UserInfo * me= [SnapRead getUserInfo];
                                                              if(me == nil && debugging){
                                                                  me = [SnapCreate createUserWithName:@"Joshua" andPasword:@"Password"];
                                                              }



                                                                    if(!strong->_moviePlayer){
                                                                        // picture

                                                                        Snap *snap;


                                                                        UIImage *resultImage = [self getFinalImage:strong];
                                                                        Content * content = [SnapCreate createContentWith:resultImage andStringURL:@"" withType:IMAGE_CONTENT];
                                                                        snap = [SnapCreate createUserStorySnapWithDate:[NSDate date]
                                                                                                      andLength:strong->_slider.value
                                                                                                     andContent:content
                                                                                                        andUser:me];
                                                                        snap.snapID = DUMMY_SNAP_ID; // dummy default
                                                                        [Post storySnapbyUser:me andSnap:snap withComp:^(BOOL succ, id res) {
                                                                            if(succ){
                                                                                if(res[@"Success"]){
                                                                                    return;
                                                                                }
                                                                            }
                                                                            // else we failed in some way
                                                                            [SnapDelete deleteSnapWithID:DUMMY_SNAP_ID];
                                                                        }];

                                                                    }else{
                                                                        // this method will place it in the story when it is actually possible to do soo :D
                                                                        [self generaturePermanantURLStringFrom:strong->_url onCompletion:^(BOOL succ, NSURL * url){

                                                                            Snap *snap;

                                                                            Content * content = [SnapCreate createContentWith:nil andStringURL:url.absoluteString withType:VIDEO_CONTENT];
                                                                            snap = [SnapCreate createUserStorySnapWithDate:[NSDate date]
                                                                                                                 andLength:strong->_moviePlayer.duration
                                                                                                                andContent:content
                                                                                                                   andUser:me];
                                                                            snap.snapID = DUMMY_SNAP_ID; // dummy default

                                                                            if(!succ || url == nil){
                                                                                basicAlertMessage(@"Failed to upload story :(");
                                                                                return;
                                                                            }

                                                                            [Post storySnapbyUser:me andSnap:snap withComp:^(BOOL succ, id res) {
                                                                                if(succ){
                                                                                    if(res[@"Success"]){
                                                                                        return;
                                                                                    }else {
                                                                                        basicAlertMessage(@"Failed to upload story :(");

                                                                                        [SnapDelete deleteSnapWithID:DUMMY_SNAP_ID];
                                                                                    }

                                                                                }
                                                                                // else we failed in some way
                                                                            }];


                                                                        }];


                                                                    }







                                                                [self userHitX:self];


                                                          }];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"NO THANKYOU! :)" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {

                                                              if(debugging){
                                                                NSLog(@"User clicked no thankyou!");
                                                             }
                                                          }];

    [alert addAction:defaultAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];    NSLog(@"Hit post to story");
}

- (UIImage *)getFinalImage:(ContentFinishedViewController *)strong {
    [strong->picView removeAllForPicView];
    UIImage  * drawImage = [PictureEditorView imageWithView:strong->picView];
    //[UIImage image

    //UIGraphicsBeginImageContext(strong.view.frame.size);
    UIGraphicsBeginImageContextWithOptions(strong.view.frame.size,NO,0.0f);

    [strong->iView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, strong.view.frame.size.height)];
    [drawImage drawInRect:CGRectMake(0, 0,self.view.frame.size.width,strong.view.frame.size.height)];
    UIImage * toReturn = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return toReturn;
}

- (NSString *)generaturePermanantURLStringFrom:(NSURL *)url onCompletion:(void(^)(BOOL,NSURL *)) completion {
    NSArray *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [documentsDirectory objectAtIndex:0];

    NSString *videoName = [NSString stringWithFormat:@"%@story.mov",[NSProcessInfo processInfo].globallyUniqueString];
    NSString *videoPath = [docPath stringByAppendingPathComponent:videoName];
    NSURL *outputURL = [NSURL fileURLWithPath:videoPath];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];

    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetPassthrough];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    ContentFinishedViewController * weak = self;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if(exportSession.status == AVAssetExportSessionStatusCompleted){
            NSLog(@"Successfully transfered contents of video");

            completion(YES,outputURL);
        }else{
            NSLog(@"Error with transfering contents of video");// %@ with error %@",exportSession.status,exportSession.error);
            completion(NO,outputURL);
        }

    }];
    return outputURL.absoluteString;

}



- (IBAction)userHitX:(id)sender {
    [self shouldFinish];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)shouldFinish{

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)userTouchedPoint:(CGPoint)point{
    if(CGRectContainsPoint(self.exButton.frame,point)){
        [self userHitX:self];
    }
}
@end
