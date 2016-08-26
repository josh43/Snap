//
//  StoryTableViewCell.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/14/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "StoryTableViewCell.h"
#import "Utility.h"
#import "Story.h"
#import "Snap.h"
#import "Friend.h"
#import "Content.h"
#import "UserInfo.h"

@implementation StoryTableViewCell
@synthesize imageView;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setupWith:(Story *)story {
    logMethod()
    if(_label == nil){
        NSLog(@"Error initializing from view!!");
    }

    //addBottomBorder(self,  [UIColor lightGrayColor].CGColor,1.25);
    //addBottomBorder(self,  SNAP_GRAY_COLOR.CGColor,1.25);
    //addLeftBorder(  self,[UIColor redColor].CGColor,1.5);
    //addRightBorder( sself,[UIColor redColor].CGColor,.75);

    //[UIColor colorWithRed:242 green:242 blue:242 alpha:1.0f].CGColor;

    //self.layer.b

    Snap * snap = story.mostRecentSnapNotSeen;
    BOOL userSentSnap = ([snap.snapType intValue] == SNAP_USER_SENT_TYPE);




    if(snap.friend){
        _label.text = snap.friend.username;
    }else{
        _label.text = @"My Story";
    }

    NSCalendar *gregorian = [[NSCalendar alloc]
            initWithCalendarIdentifier:NSGregorianCalendar];

    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;

    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:snap.dateSent
                                                  toDate:[NSDate date]options:0];
    NSInteger hours = [components hour];
    NSInteger minute = [components minute];

    if(minute == 0){
        minute = 1;
    }
    // fleeep dah sign
    if(minute <0)
        minute*=-1;
    _subLabel.text = [NSString stringWithFormat:@"%lim ago",(long)minute];
    if((long)hours != 0){
        _subLabel.text = [NSString stringWithFormat:@"%lih %@",(long)hours,_subLabel.text];
    }


    self.heightConstraint.constant = self.frame.size.height * .88;
    self.widthConstraint.constant = self.frame.size.height * .88;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    UIImage * toSet = [snap.content getStoryImage];
    if(toSet == nil){
        NSLog(@"Error, probably setting db itemsm too quickly ...");
    }
    self.imageView.image =toSet;
    self.imageView.layer.cornerRadius = self.heightConstraint.constant /2;
    self.imageView.layer.masksToBounds = YES;
    if(self.imageView.image == nil){
        if(debugging){
            NSLog(@"Error bro the image view was nil which means getStoryImage likely doesnt  work!!");
        }
    }
}




- (NSString *)daySuffixForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger dayOfMonth = [calendar component:NSCalendarUnitDay fromDate:date];
    switch (dayOfMonth) {
        case 1:
        case 21:
        case 31: return @"st";
        case 2:
        case 22: return @"nd";
        case 3:
        case 23: return @"rd";
        default: return @"th";
    }
}
@end
