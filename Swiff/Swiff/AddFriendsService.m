//
//  AddFriendsService.m
//  Swiff
//
//  Created by Anutosh Datta on 06/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "AddFriendsService.h"

@implementation AddFriendsService
-(void)syncFriends{
    SWNetworkCommunicator* comm = [[SWNetworkCommunicator alloc]init];
    comm.delegate = self;
    [comm syncFriends:[[[UIDevice currentDevice]identifierForVendor]UUIDString]];
}

-(id)init{
    self = [super init];
    if(self){
        self.friends = [[NSMutableArray alloc]init];
        self.friendsStorage = [SWFriendsStorage instance];
    }
    return self;
}

-(void)requestComletedWithData:(NSData*)data{
    NSLog(@"sync friend completed: %@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    SWFriend* friend = [[SWFriend alloc]init];
    NSArray* objectArray = [JsonSerializer jsonarrayToObjects:data oobjectFatcory:friend];
    for (id object in objectArray) {
        SWFriend* retreivedFriend = (SWFriend*)object;
        [self.friends addObject:retreivedFriend];
    }
    [self addFriendsToStorage];
}
-(void)requestFailedWithError:(NSError*)error{
     NSLog(@"sync friend falied with error: %@", error.description);
}

-(void)addFriendsToStorage{
    for (id object in self.friends) {
        SWFriend* friend = (SWFriend*)object;
        [self.friendsStorage AddorReplaceFriend:friend];
    }
    NSLog(@"count of friends %i", [self.friendsStorage size]);
}

-(NSArray*)getFriends{
    return [self.friendsStorage GetAllFriends];
}
@end
