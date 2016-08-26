//
//  AppDelegate.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/5/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) CoreDataHelper *coreDataHelper;
-(CoreDataHelper *)cdh;

@end

