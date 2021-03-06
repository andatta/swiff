//
//  SWStartUpControllerViewController.m
//  Swiff
//
//  Created by Lion User on 04/05/2014.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWStartUpControllerViewController.h"
#import "SettingsManager.h"
#import "AddFriendsService.h"

@interface SWStartUpControllerViewController ()

@end

@implementation SWStartUpControllerViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:44/255.f green:196/255.f blue:192/255.f alpha:1.0];
    self.appdelegate = [[UIApplication sharedApplication]delegate];
    //init location service
    [LocationService instance];
	if([[SettingsManager instance]isRegistered]){
        self.activityIndicator.hidden = NO;
        self.registerButton.hidden = YES;
        [self.activityIndicator startAnimating];
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(showUserTabs) userInfo:nil repeats:NO];
    }else{
        self.activityIndicator.hidden = YES;
        self.registerButton.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showUserTabs{
    UIViewController* tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"revealViewController"];
    [self.appdelegate changeRootController:tabBarController];
    if([[SettingsManager instance] locationUpdate]){
        [[LocationService instance]startUpdatingLocation];
    }
}

@end
