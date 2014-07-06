//
//  AddFriendsService.h
//  Swiff
//
//  Created by Anutosh Datta on 06/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SWFriend.h"
#import "SWNetworkCommunicator.h"
#import "SWNetworkDelegate.h"
#import "JsonSerializer.h"
#import "SWFriendsStorage.h"
@interface AddFriendsService : NSObject<SWNetworkDelegate>
-(void)syncFriends;
-(NSArray*)getFriends;

@property NSMutableArray* friends;
@property SWFriendsStorage* friendsStorage;
@end
