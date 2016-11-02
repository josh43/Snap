//
//  SnapTableViewCell.m
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/13/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "SnapTableViewCell.h"
#import "Snap.h"
#import "Content.h"
#import "Friend.h"

@implementation SnapTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellWithSnap:(Snap *)snap{
    if(self.mainLabel == nil){
        NSLog(@"Error initializing from view!!");
    }

    BOOL userSentSnap = ([snap.snapType intValue] == SNAP_USER_SENT_TYPE);

    self.mainLabel.text =  snap.friend.username;
    NSDateFormatter  * getDay = [[NSDateFormatter  alloc]init];
    [getDay setDateFormat:@"dd"];
    NSDateFormatter  * getMonth = [[NSDateFormatter  alloc]init];
    [getMonth setDateFormat:@"MMMM"];
    NSString * date = [getDay stringFromDate:snap.dateSent];
    NSString * month = [getMonth stringFromDate:snap.dateSent];
    if(![snap.hasSeen boolValue]) {
        self.subLabel.text = [NSString stringWithFormat:@"%@ %@ %@%@", !userSentSnap ? @"Recieved" : @"Sent",
                                                        month, date, [self daySuffixForDate:snap.dateSent]];
    }else{
        self.subLabel.text = [NSString stringWithFormat:@"Opened %@ %@%@", month, date, [self daySuffixForDate:snap.dateSent]];
    }

    if([snap.content.contentType intValue] == IMAGE_CONTENT){

        if([snap.hasSeen boolValue] == YES){
            // change the icon
            self.picture.image = [ UIImage imageNamed:( !userSentSnap ? @"red" : @"sentAndSeenRed")];
        }else{
            self.picture.image = [ UIImage imageNamed:(!userSentSnap ? @"redFill" : @"sentAndSeenRedFill")];
        }
    }else{// video
        if([snap.hasSeen boolValue] == YES){
            // change the icon
            self.picture.image = [ UIImage imageNamed:(!userSentSnap ? @"purple" : @"sentAndSeenPurple")];
        }else{
            self.picture.image = [ UIImage imageNamed:(!userSentSnap ? @"purpleFill" : @"sentAndSeenPurpleFill")];
        }
    };
}

// http://stackoverflow.com/questions/1283045/ordinal-month-day-suffix-option-for-nsdateformatter-setdateformat
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
