//
//  SWEnterMerchantController.h
//  Swiff
//
//  Created by Anutosh Datta on 25/05/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LocationService.h"
#import "SWNetworkCommunicator.h"
#import "SWProgressIndicator.h"
#import "SWGeneralStateDialog.h"
#import "SWNetworkDelegate.h"

@interface SWEnterMerchantController : UIViewController<UITextFieldDelegate, SWNetworkDelegate>
@property (weak, nonatomic) IBOutlet UITextField *merchantTextField;
@property (weak, nonatomic) IBOutlet UITextField *outletTextField;
@property (weak, nonatomic) IBOutlet UITextField *latitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *longitudeTextField;

@property SWProgressIndicator* progressIndicator;
@property SWGeneralStateDialog* errorRibbon;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitBtn;
- (IBAction)submitBtnClicked:(id)sender;
- (IBAction)cancelBtnClicked:(id)sender;

@end
