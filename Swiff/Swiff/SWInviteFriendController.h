//
//  SWInviteFriendController.h
//  Swiff
//
//  Created by Anutosh Datta on 19/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SWInviteFriendController : UIViewController<UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
@property UITableView* optionsList;
@property NSArray* options;
@end
