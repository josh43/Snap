//
//  Content.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/11/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "Content.h"
#import "Friend.h"
#import "Snap.h"
#import "UserInfo.h"
#import "Utility.h"


@import MediaPlayer;
@import AVFoundation;

@implementation Content

// Insert code here to add functionality to your managed object subclass
-(UIImage *) getUIImage{
    logMethod()
    UIImage * toReturn = nil;
    if(IMAGE_CONTENT){
        toReturn = [UIImage imageWithData:self.content scale:1.0f];
        
    }else{
        errorMessage(@"When trying to get the UI image the content type is declared as VIDEO Content which I don't implement")
    }
    
    return toReturn;
}
-(void) setURL:(NSURL *)url{
    self.url = [url.copy absoluteString];
}
-(NSURL *) getURL{
    if(!self.url){
        return nil;
    }

    // you have to use this when dealing with file paths....
    // thank you apple you are the best
    NSURL *toReturn  =  [[NSURL alloc]initWithString:self.url];
    
    return toReturn;
}

- (UIImage *)getStoryImage {
    logMethod()
    if([self.contentType intValue] == IMAGE_CONTENT){
        return [self getUIImage];
    }else{

        NSURL * url = [self getURL];
        AVURLAsset * movie = [[AVURLAsset alloc] initWithURL:url options:nil];


        AVAssetImageGenerator * gen = [AVAssetImageGenerator assetImageGeneratorWithAsset:movie];

        gen.appliesPreferredTrackTransform = YES;


        CMTime time = CMTimeMake(0.0,600);
        NSError* err=  nil;
        CGImageRef img = [gen copyCGImageAtTime:time actualTime:nil error:&err];
        if(err){
            NSLog(@"Failed to load image thumbnail with error %@", err);
            return nil;
        }

        UIImage * toReturn = [UIImage imageWithCGImage:img];

        return toReturn;



    }
}
@end
