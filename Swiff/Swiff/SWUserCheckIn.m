//
//  SWUserCheckIn.m
//  Swiff
//
//  Created by Anutosh Datta on 09/08/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWUserCheckIn.h"

@implementation SWUserCheckIn
//Serializable methods
-(NSDictionary*)toDictionary{
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:self.outletName, @"outletName", self.checkInDate, @"checkInDate", self.outletLogo, @"outletLogo", nil];
    return data;
}

-(id<Serializable>)toObjectFromDictionary:(NSDictionary*)dictionary{
    SWUserCheckIn* userCheckIn = [[SWUserCheckIn alloc]init];
    userCheckIn.outletName = [dictionary valueForKey:@"outletName"];
    userCheckIn.checkInDate = [dictionary valueForKey:@"checkInDate"];
    userCheckIn.outletLogo = [dictionary valueForKey:@"outletLogo"];
    return userCheckIn;
}

//Serializable factory methods
-(id<Serializable>)createObject{
    return [[SWUserCheckIn alloc]init];
}
@end
