//
//  SWUploadProfilePicController.m
//  Swiff
//
//  Created by Anutosh Datta on 29/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWUploadProfilePicController.h"

@interface SWUploadProfilePicController ()

@end

@implementation SWUploadProfilePicController

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
    if(self.image != nil){
        self.profileImageView.image = self.image;
    }
    UIBarButtonItem* uploadBtn = [[UIBarButtonItem alloc]initWithTitle:@"Upload" style:UIBarButtonItemStylePlain target:self action:@selector(uploadImage)];
    self.navigationItem.rightBarButtonItem = uploadBtn;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)uploadImage{
    [self showProgressIndicator];
    SWNetworkCommunicator* comm = [[SWNetworkCommunicator alloc]init];
    comm.delegate = self;
    [comm uploadProfileImage:self.image customerId:[[[UIDevice currentDevice]identifierForVendor]UUIDString]];
}

-(void)showProgressIndicator{
    if(self.progressIndicator == nil){
        self.progressIndicator = [[SWProgressIndicator alloc]initWithFrame:CGRectMake(20, 180, 280, 80)];
        self.progressIndicator.label.text = @"Please wait while image is saved in our servers";
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
        self.errorRibbon.label.text = @"Error in saving image. Please try again";
    }
    [self.errorRibbon setHidden:NO];
    [self.view addSubview:self.errorRibbon];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(removeErrorRibbon) userInfo:nil repeats:NO];
}

-(void)removeErrorRibbon{
    [self.errorRibbon setHidden:YES];
    [self.errorRibbon removeFromSuperview];
}

-(void)requestComletedWithData:(NSData*)data{
    NSLog(@"request completed: %@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    [self removeProgressIndicator];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)requestFailedWithError:(NSError*)error{
    [self removeProgressIndicator];
    [self showErrorRibbon];
}


@end
