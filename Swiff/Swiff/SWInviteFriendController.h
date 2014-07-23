//
//  SWInviteFriendController.h
//  Swiff
//
//  Created by Anutosh Datta on 19/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWInviteFriendController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property UITableView* optionsList;
@property NSArray* options;
@end
