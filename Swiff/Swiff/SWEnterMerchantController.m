//
//  SWEnterMerchantController.m
//  Swiff
//
//  Created by Anutosh Datta on 25/05/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWEnterMerchantController.h"

@interface SWEnterMerchantController ()

@end

@implementation SWEnterMerchantController

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
    // load latitude and longitude
    NSString* latitude;
    NSString* longitude;
    [[LocationService instance]getCurrentLatitude:&latitude andLongitude:&longitude];
    self.latitudeTextField.text = latitude;
    self.longitudeTextField.text = longitude;
    
    self.merchantTextField.delegate = self;
    self.outletTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)enableSubmitButtonIfNeeded{
    if(self.merchantTextField.text.length > 0 && self.outletTextField.text.length > 0){
        self.submitBtn.enabled = YES;
    }else{
        self.submitBtn.enabled = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self enableSubmitButtonIfNeeded];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitBtnClicked:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelBtnClicked:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
