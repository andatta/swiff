//
//  SWFriendsListController.h
//  Swiff
//
//  Created by Anutosh Datta on 06/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddFriendsService.h"
#import "ImageLoaderListener.h"
#import "ImageLoader.h"
#import "FriendsUpdateListener.h"
#import "SWInviteFriendController.h"
#import "SWUserDetailController.h"

@interface SWFriendsListController : UIViewController<UITableViewDataSource, UITableViewDelegate, ImageLoaderListener, FriendsUpdateListener>
@property UITableView* friendsList;
@property NSArray* friends;
@property AddFriendsService* friendService;
@property UIButton* addFriendImageButton;
@property UILabel* noFriendLabel;
@property UIBarButtonItem* addfriendBarButton;
@property SWInviteFriendController* inviteController;
@property SWUserDetailController* userDetailController;
@end
