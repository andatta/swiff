//
//  SWReviewDetailController.m
//  Swiff
//
//  Created by Anutosh Datta on 10/08/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWReviewDetailController.h"

#import "ImageLoader.h"
@interface SWReviewDetailController ()

@end

@implementation SWReviewDetailController

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
    self.outletLogoImage.image = [[ImageLoader instance]getImageForPath:self.userReview.outletLogo completionHandler:^(UIImage * image) {
        
    }];
    self.outletName.text = self.userReview.outletName;
    self.reviewDate.text = [self formatDate:self.userReview.reviewDate];
    self.outletReview.text = self.userReview.review;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)formatDate:(NSString*)indateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:indateString];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    return [dateFormatter stringFromDate:date];
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
