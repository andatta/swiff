//
//  SWSettingsController.h
//  Swiff
//
//  Created by Anutosh Datta on 24/05/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "SettingsManager.h"
#import "SWEnterMerchantController.h"
#import "SWChooseProfilePicController.h"

@interface SWSettingsController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate>

@property UITableView* settingsView;
@property NSArray* settings;
@property UITableView* locationIntervalsView;
@property NSArray* locationUpdateIntervals;
@property SWEnterMerchantController* merchantController;
@property SWChooseProfilePicController* profilePicController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;

-(void)dismissMerchantForm;
@end
