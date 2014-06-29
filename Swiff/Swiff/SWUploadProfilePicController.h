//
//  SWUploadProfilePicController.h
//  Swiff
//
//  Created by Anutosh Datta on 29/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWProgressIndicator.h"
#import "SWGeneralStateDialog.h"
#import "SWNetworkCommunicator.h"
#import "SWNetworkDelegate.h"

@interface SWUploadProfilePicController : UIViewController<SWNetworkDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property UIImage* image;
@property SWProgressIndicator* progressIndicator;
@property SWGeneralStateDialog* errorRibbon;
@end
