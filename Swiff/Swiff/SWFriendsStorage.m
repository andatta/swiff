//
//  SWFriendsStorage.m
//  Swiff
//
//  Created by Anutosh Datta on 06/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWFriendsStorage.h"

@implementation SWFriendsStorage

static SWFriendsStorage* instance = nil;

+(id)instance{
    if(instance == nil){
        instance = [[SWFriendsStorage alloc]init];
    }
    return instance;
}

-(id)init{
    self = [super init];
    if(self){
        self.sqlStorage = [SqliteStorage instance];
        [self loadFriends];
    }
    return self;
}

-(void)loadFriends{
    SWFriend* factory = [[SWFriend alloc]init];
    self.friends = [[NSMutableDictionary alloc]initWithDictionary:[self.sqlStorage Select:factory]];
}

-(SWFriend*)GetFriendById:(NSString *)customerId{
    for (id object in [self.friends allValues]) {
        SWFriend* friend = (SWFriend*)object;
        if([friend.customerId isEqualToString:customerId]){
            return friend;
        }
    }
    return nil;
}

-(SWFriend*)GetFriendByMsisdn:(NSString *)msisdn{
    for (id object in [self.friends allValues]) {
        SWFriend* friend = (SWFriend*)object;
        if([friend.mobile isEqualToString:msisdn]){
            return friend;
        }
    }
    return nil;
}

-(NSArray*)GetAllFriends{
    return [self.friends allValues];
}

-(int)size{
    return [self.friends count];
}

-(void)AddorReplaceFriend:(SWFriend *)frnd{
    for (NSString* key in [self.friends allKeys]) {
        SWFriend* storedFriend = (SWFriend*)[self.friends valueForKey:key];
        if([storedFriend.customerId isEqualToString:frnd.customerId]){
            NSLog(@"updating friend");
            [self.sqlStorage Update:frnd withUID:key];
            [self.friends setObject:frnd forKey:key];
            return;
        }
    }
    NSLog(@"adding friend");
    [self.sqlStorage Add:frnd];
    [self loadFriends];
}

-(void)DeleteFriend:(SWFriend *)frnd{
    for (NSString* key in [self.friends allKeys]) {
        SWFriend* storedFriend = (SWFriend*)[self.friends valueForKey:key];
        if([storedFriend.customerId isEqualToString:frnd.customerId]){
            [self.sqlStorage Delete:frnd withUID:key];
            [self.friends removeObjectForKey:key];
            break;
        }
    }
}

-(void)DeleteAllFriends{
    SWFriend* friend = [[SWFriend alloc]init];
    [self.sqlStorage DeleteAll:friend];
    [self.friends removeAllObjects];
}
@end
