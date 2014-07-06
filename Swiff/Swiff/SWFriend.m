//
//  SWFriend.m
//  Swiff
//
//  Created by Anutosh Datta on 06/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWFriend.h"

#import <stdlib.h>
@implementation SWFriend

//Serializable methods
-(NSDictionary*)toDictionary{
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:self.customerId, @"customerId", self.first_name, @"first_name", self.last_name, @"last_name", self.dob, @"dob", self.email, @"email", self.mobile, @"mobile", self.profileImage, @"profileImage", nil];
    return data;
}

-(id<Serializable>)toObjectFromDictionary:(NSDictionary*)dictionary{
    SWFriend* friend = [[SWFriend alloc]init];
    friend.customerId = [dictionary valueForKey:@"customerId"];
    friend.first_name = [dictionary valueForKey:@"first_name"];
    friend.last_name = [dictionary valueForKey:@"last_name"];
    friend.dob = [dictionary valueForKey:@"dob"];
    friend.email = [dictionary valueForKey:@"email"];
    friend.mobile = [dictionary valueForKey:@"mobile"];
    friend.profileImage = [dictionary valueForKey:@"profileImage"];
    
    return friend;
}

//Serializable factory methods
-(id<Serializable>)createObject{
    return [[SWFriend alloc]init];
}

//SqliteStorable methods
-(NSString*)createUID{
    return [NSString stringWithFormat:@"%d", arc4random()];
}

-(NSString*)objectToJson{
    NSString* jsonString;
    [JsonSerializer objectToJson:self String:&jsonString];
    return jsonString;
}

-(NSString*)className{
    return @"SWFriend";
}

-(id<SqliteStorable>)jsonToObject:(NSString*)json{
    NSData* jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    return (SWFriend*)[JsonSerializer jsonToObject:jsonData objectFatcory:self];
}

-(id<SqliteStorable>)getObject{
   return [[SWFriend alloc]init];
}

@end
