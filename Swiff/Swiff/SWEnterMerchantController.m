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
    [self showProgressIndicator];
    [self saveMerchantOutlet];
    
}

- (IBAction)cancelBtnClicked:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


-(void)showProgressIndicator{
    if(self.progressIndicator == nil){
        self.progressIndicator = [[SWProgressIndicator alloc]initWithFrame:CGRectMake(20, 180, 280, 80)];
        self.progressIndicator.label.text = NSLocalizedString(@"merchant_processing_text", nil);
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
        self.errorRibbon.label.text = NSLocalizedString(@"merchant_error_text", nil);
    }
    [self.errorRibbon setHidden:NO];
    [self.view addSubview:self.errorRibbon];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(removeErrorRibbon) userInfo:nil repeats:NO];
}

-(void)removeErrorRibbon{
    [self.errorRibbon setHidden:YES];
    [self.errorRibbon removeFromSuperview];
}

-(void)saveMerchantOutlet{
    SWMerchantOutlet* outlet = [[SWMerchantOutlet alloc]init];
    outlet.name = self.outletTextField.text;
    outlet.merchant_name = self.merchantTextField.text;
    outlet.latitude = [[LocationService instance]latitude];
    outlet.longitude = [[LocationService instance]longitude];
    SWNetworkCommunicator* comm = [[SWNetworkCommunicator alloc]init];
    comm.delegate = self;
    [comm saveMercahntOutlet:outlet completionHandler:^(NSData *data, NSError *error) {
        if(error == NULL){
            [self requestComletedWithData:data];
        }else{
            [self requestFailedWithError:error];
        }
    }];
}

-(void)requestComletedWithData:(NSData*)data{
    NSLog(@"request completed: %@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    [self removeProgressIndicator];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)requestFailedWithError:(NSError*)error{
    [self removeProgressIndicator];
    [self showErrorRibbon];
}



@end
