//
//  SWUserDetailController.h
//  Swiff
//
//  Created by Anutosh Datta on 09/08/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWFriend.h"
#import "SWNetworkCommunicator.h"
#import "SWNetworkDelegate.h"
#import "SWUserCheckIn.h"
#import "SWUserReview.h"
#import "ImageLoaderListener.h"

@interface SWUserDetailController : UIViewController<SWNetworkDelegate, UITableViewDataSource, UITableViewDelegate, ImageLoaderListener>
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userStatus;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segments;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *noRecordsLabel;

@property SWFriend* friendObject;
@property BOOL zoomedIn;
@property BOOL checkInSyncInProgress;
@property BOOL reviewSyncInProgress;
@property int currentRequest;
@property NSMutableArray* checkIns;
@property NSMutableArray* reviews;

@property UITableView* checkInView;
@property UITableView* reviewTableView;

//@property
@end
