//
//  SWStartUpControllerViewController.h
//  Swiff
//
//  Created by Lion User on 04/05/2014.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWAppDelegate.h"

@interface SWStartUpControllerViewController : UIViewController
@property IBOutlet UIActivityIndicatorView* activityIndicator;
@property IBOutlet UIButton* registerButton;

@property SWAppDelegate* appdelegate;
@end
