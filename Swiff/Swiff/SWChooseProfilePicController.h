//
//  SWChooseProfilePicController.h
//  Swiff
//
//  Created by Anutosh Datta on 28/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWNetworkCommunicator.h"
#import "SWNetworkDelegate.h"
#import "SWUploadProfilePicController.h"
@interface SWChooseProfilePicController : UIViewController<UIImagePickerControllerDelegate>
- (IBAction)uploadExisting:(id)sender;
- (IBAction)takeNewPhoto:(id)sender;
@property SWUploadProfilePicController* uploadPicController;
@end
