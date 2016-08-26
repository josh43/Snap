//
//  SnapTVC.h
//  BasicSnapPictureViewer
//
//  Created by joshua on 7/5/16.
//  Copyright © 2016 joshua. All rights reserved.
//

#import "CoreDataTVC.h"
#import "SnapViewerViewController.h"
#import "Snap.h"
#import "PictureViewerInterface.h"
#import "SnapTransition.h"
#import "RestfulSnapCRUD.h"

@interface SnapTVC : CoreDataTVC <PictureViewerInterface,SnapTransition,UISearchBarDelegate,UISearchDisplayDelegate, UISearchResultsUpdating,UITabBarDelegate>
@property(nonatomic,weak) UIImage * lastPicture;
@property(nonatomic,strong) UISearchController * searchController;

@end


@interface TimerData : NSObject
@property(nonatomic, retain) Snap *picInfo;
@property(nonatomic,retain) NSTimer *timer;

@end