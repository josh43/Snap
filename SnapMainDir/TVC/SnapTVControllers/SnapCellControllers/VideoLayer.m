//
// Created by joshua on 7/26/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import "VideoLayer.h"


@implementation VideoLayer {

}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer*)player {
    return [(AVPlayerLayer *)[self layer] player];
}
- (void)setPlayer:(AVQueuePlayer *)player {
    [((AVPlayerLayer *)[self layer]) setPlayer:player];
}


@end