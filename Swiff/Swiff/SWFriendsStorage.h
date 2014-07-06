//
//  SWFriendsStorage.h
//  Swiff
//
//  Created by Anutosh Datta on 06/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SqliteStorage.h"
#import "SWFriend.h"
@interface SWFriendsStorage : NSObject
@property NSMutableDictionary* friends;
@property SqliteStorage* sqlStorage;

+(id)instance;
-(SWFriend*)GetFriendById:(NSString*)customerId;
-(SWFriend*)GetFriendByMsisdn:(NSString*)msisdn;
-(NSArray*)GetAllFriends;
-(int)size;
-(void)AddorReplaceFriend:(SWFriend*)frnd;
-(void)DeleteFriend:(SWFriend*)frnd;
-(void)DeleteAllFriends;
@end
