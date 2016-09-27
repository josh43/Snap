//
//  SnapViewerViewController.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/5/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "CoreDataTVC.h"
#import "SnapTransition.h"
#import "ContentDisplayer.h"

@class PictureInfo;
@class SnapTVC;
@protocol PictureViewerInterface;
@class Snap;

@interface SnapViewerViewController : UIViewController <SnapTransition>
@property(nonatomic,strong) ContentDisplayer * contentDisplayer;

@property (strong, nonatomic) UITextField *textField;
@property(nonatomic,strong) NSTimer * timer;
@property(nonatomic,weak) Snap * picInfo;
@property (nonatomic) BOOL shouldDecrement;
@property(nonatomic, weak) id<PictureViewerInterface> completionDelegate;

-(instancetype) init;
-(instancetype) initWithData:(NSData *) data withContentType:(int)content_type
                      andUrl:(NSURL *)url orSnap:(Snap *)snap andStory:(Story *) story;
@end
