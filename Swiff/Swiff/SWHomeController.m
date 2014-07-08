//
//  SWHomeController.m
//  Swiff
//
//  Created by Anutosh Datta on 07/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWHomeController.h"
#import "SWRevealViewController.h"
@interface SWHomeController ()

@end

@implementation SWHomeController

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
    self.title = NSLocalizedString(@"home_tab", nil);
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(revealToggle:);
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:44/255.f green:196/255.f blue:192/255.f alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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

@end
