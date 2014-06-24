//
//  SWRegistrationViewController.m
//  Swiff
//
//  Created by Lion User on 04/05/2014.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWRegistrationViewController.h"
#import "SettingsManager.h"
#import "LocationService.h"

@interface SWRegistrationViewController ()
@property bool isDateSelected;
@end

@implementation SWRegistrationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication]delegate];
    [self setUpViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitBtnClicked:(id)sender {
    [self showProgressIndicator];
    [self registerCustomer];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)setUpViews{
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 700)];
    [self.scrollView addSubview:self.contentView];
    self.scrollView.contentSize = CGSizeMake(320, 700);
    
    //header label
    UILabel* headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 30)];
    [headerLabel setText:@"Enter your information:"];
    [headerLabel setTextColor:[UIColor grayColor]];
    headerLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    [self.contentView addSubview:headerLabel];
    //header label
    
    //instruction label
    UILabel* instructionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 200, 30)];
    [instructionLabel setText:@"*All fields are mandatory"];
    instructionLabel.font = [UIFont systemFontOfSize:10.0f];
    [self.contentView addSubview:instructionLabel];
    //instruction label
    
    //first name label
    UILabel* firstNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, 100, 30)];
    [firstNameLabel setText:@"First Name:"];
    firstNameLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:firstNameLabel];
    //first name label
    
    //first name text field
    self.firstNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 70, 180, 30)];
    self.firstNameTextField.backgroundColor = [UIColor whiteColor];
    self.firstNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.firstNameTextField.font = [UIFont systemFontOfSize:12.0f];
    self.firstNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.firstNameTextField.placeholder = @"Enter first name";
    self.firstNameTextField.delegate = self;
    [self.contentView addSubview:self.firstNameTextField];
    //first name text field
    
    //last name label
    UILabel* lastNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, 100, 30)];
    [lastNameLabel setText:@"Last Name:"];
    lastNameLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:lastNameLabel];
    //last name label
    
    //last name text field
    self.lastNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 120, 180, 30)];
    self.lastNameTextField.backgroundColor = [UIColor whiteColor];
    self.lastNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.lastNameTextField.font = [UIFont systemFontOfSize:12.0f];
    self.lastNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.lastNameTextField.placeholder = @"Enter last name";
    self.lastNameTextField.delegate = self;
    [self.contentView addSubview:self.lastNameTextField];
    
    //last name text field
    
    //email label
    UILabel* emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 170, 100, 30)];
    [emailLabel setText:@"Email:"];
    emailLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:emailLabel];
    //email label
    
    //email text field
    self.emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(100, 170, 180, 30)];
    self.emailTextField.backgroundColor = [UIColor whiteColor];
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.font = [UIFont systemFontOfSize:12.0f];
    self.emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.emailTextField.placeholder = @"Enter email";
    self.emailTextField.delegate = self;
    [self.contentView addSubview:self.emailTextField];
    //email text field
    
    //date of birth label
    UILabel* dobLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 220, 100, 30)];
    [dobLabel setText:@"Date of birth:"];
    dobLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:dobLabel];
    //date of birth label
    
    //date of birth button
    self.datePickerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.datePickerBtn.frame = CGRectMake(100, 220, 180, 30);
    self.datePickerBtn.backgroundColor = [UIColor lightGrayColor];
    [self.datePickerBtn setTitle:@"Pick a date" forState:UIControlStateNormal];
    [self.datePickerBtn addTarget:self action:@selector(datePickerBtnClicked:) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:self.datePickerBtn];
    //date of birth button
    
    //gender label
    UILabel* genderLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 270, 100, 30)];
    [genderLabel setText:@"Gender:"];
    genderLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.contentView addSubview:genderLabel];
    //gender label
    
    //gender segmented control
    NSArray* items = [NSArray arrayWithObjects:@"Male",@"Female", nil];
    self.radioBtn = [[UISegmentedControl alloc]initWithItems:items];//initWithFrame:CGRectMake(100, 270, 100, 100)];
    self.radioBtn.frame = CGRectMake(100, 270, 150, 30);
    self.radioBtn.segmentedControlStyle = UISegmentedControlStyleBordered;
    self.radioBtn.selectedSegmentIndex = 0;
    [self.contentView addSubview:self.radioBtn];
    //gender segmented control
    
    //submit btn
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.submitBtn.backgroundColor = [UIColor lightGrayColor];
    self.submitBtn.frame = CGRectMake(100, 370, 100, 30);
    [self.submitBtn setTitle:@"SUBMIT" forState:UIControlStateNormal];
    self.submitBtn.enabled = NO;
    [self.submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:self.submitBtn];
    //submit btn
}

-(void)datePickerBtnClicked:(id)sender{
    if(self.datePicker == nil){
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 100, 320, 216)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.backgroundColor = [UIColor lightGrayColor];
    [self.datePicker addTarget:self action:@selector(datePickerClicked:) forControlEvents:UIControlEventValueChanged];
    }
    self.datePicker.hidden = NO;
    [self.contentView addSubview:self.datePicker];
}

-(void)datePickerClicked:(id)sender{
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"dd/MM/yyyy"];
    NSString* dateString = [dateformatter stringFromDate:self.datePicker.date];
    [self.datePickerBtn setTitle:dateString forState:UIControlStateNormal];
    self.isDateSelected = YES;
    self.datePicker.hidden = YES;
    [self.datePicker removeFromSuperview];
    [self enableSubmitBtnIfNeeded];
}

-(void)enableSubmitBtnIfNeeded{
    if(self.firstNameTextField.text.length > 0 && self.lastNameTextField.text.length > 0 && self.emailTextField.text.length > 0 && self.isDateSelected){
        self.submitBtn.enabled = YES;
    }else{
        self.submitBtn.enabled = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self enableSubmitBtnIfNeeded];
}

-(void)registerCustomer{
    SWCustomer* customer = [[SWCustomer alloc]init];
    customer.customerId = @"123456789";//[[[UIDevice currentDevice]identifierForVendor]UUIDString];
    customer.first_name = self.firstNameTextField.text;
    customer.last_name = self.lastNameTextField.text;
    customer.dob = @"1990-01-01";//self.datePickerBtn.titleLabel.text;
    customer.email = self.emailTextField.text;
    customer.gender = self.radioBtn.selectedSegmentIndex == 0 ? @"Male" : @"Female";
    customer.mobile = @"7200490071"; //To do: need to get mobile number
    customer.deviceOsName = @"IOS";
    SWNetworkCommunicator* comm = [[SWNetworkCommunicator alloc]init];
    if([comm registerCustomer:customer]){
        if([comm registerForPush:customer.customerId withToken:[[SettingsManager instance]deviceToken]]){
            [self removeProgressIndicator];
            [[SettingsManager instance]setIsRegistered:YES];
            UITabBarController* tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
            [self.appDelegate changeRootController:tabBarController];
            [[LocationService instance]startUpdatingLocation];
        }else{
            [self removeProgressIndicator];
            [self showErrorRibbon];
        }
    }else{
        [self removeProgressIndicator];
        [self showErrorRibbon];
    }

}

-(void)showProgressIndicator{
    if(self.progressIndicator == nil){
        self.progressIndicator = [[SWProgressIndicator alloc]initWithFrame:CGRectMake(20, 180, 280, 80)];
        self.progressIndicator.label.text = @"Please wait while you are being registered";
    }
    [self.progressIndicator setHidden:NO];
    [self.view addSubview:self.progressIndicator];
}

-(void)removeProgressIndicator{
    if(self.progressIndicator != nil){
        [self.progressIndicator setHidden:YES];
        [self.progressIndicator removeFromSuperview];
    }
}

-(void)showErrorRibbon{
    if(self.errorRibbon == nil){
        self.errorRibbon = [[SWGeneralStateDialog alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
        self.errorRibbon.label.text = @"Error in registration. Please try again";
    }
    [self.errorRibbon setHidden:NO];
    [self.view addSubview:self.errorRibbon];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(removeErrorRibbon) userInfo:nil repeats:NO];
}

-(void)removeErrorRibbon{
    [self.errorRibbon setHidden:YES];
    [self.errorRibbon removeFromSuperview];
}




@end
