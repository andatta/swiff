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
@interface SWFriendsListController : UIViewController<UITableViewDataSource, UITableViewDelegate, ImageLoaderListener>
@property UITableView* friendsList;
@property NSArray* friends;
@property AddFriendsService* friendService;
@end
