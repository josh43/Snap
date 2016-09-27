//
// Created by joshua on 7/15/16.
// Copyright (c) 2016 joshua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TextDelegateHandler;
@class ContentFinishedViewController;

@interface PictureEditorView : UIView

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *enableTextButton;


@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property(nonatomic, weak) ContentFinishedViewController * cfvc;

@property (weak, nonatomic) IBOutlet UITextField *textLabel;

//http://stackoverflow.com/questions/4334233/how-to-capture-uiview-to-uiimage-without-loss-of-quality-on-retina-display
-(void) hideAllForPicture;
+ (UIImage *) imageWithView:(UIView *)view;

- (void)removeAllForPicView;
@property(nonatomic,strong) TextDelegateHandler * textDelegate;


@end