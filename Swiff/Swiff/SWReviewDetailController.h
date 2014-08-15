//
//  SWReviewDetailController.h
//  Swiff
//
//  Created by Anutosh Datta on 10/08/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWUserReview.h"

@interface SWReviewDetailController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *outletLogoImage;
@property (weak, nonatomic) IBOutlet UILabel *outletName;
@property (weak, nonatomic) IBOutlet UILabel *reviewDate;
@property (weak, nonatomic) IBOutlet UITextView *outletReview;

@property SWUserReview* userReview;
@end
