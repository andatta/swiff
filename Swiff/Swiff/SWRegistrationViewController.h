//
//  SWRegistrationViewController.h
//  Swiff
//
//  Created by Lion User on 04/05/2014.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWAppDelegate.h"
#import "SWCustomer.h"
#import "SWNetworkCommunicator.h"
#import "SWNetworkException.h"
#import "SWProgressIndicator.h"
#import "SWGeneralStateDialog.h"

@interface SWRegistrationViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property UIView* contentView;
@property UITextField* firstNameTextField;
@property UITextField* lastNameTextField;
@property UITextField* emailTextField;
@property UIButton* datePickerBtn;
@property UISegmentedControl* radioBtn;
@property UIButton* submitBtn;
@property UIDatePicker* datePicker;
@property SWProgressIndicator* progressIndicator;
@property SWAppDelegate* appDelegate;
@property SWGeneralStateDialog* errorRibbon;
@end
