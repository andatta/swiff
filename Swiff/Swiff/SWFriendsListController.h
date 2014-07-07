//
//  SWFriendsListController.h
//  Swiff
//
//  Created by Anutosh Datta on 06/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddFriendsService.h"

@interface SWFriendsListController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property UITableView* friendsList;
@property NSArray* friends;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property AddFriendsService* friendService;
@end
