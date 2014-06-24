//
//  SWCustomerLocation.m
//  Swiff
//
//  Created by Anutosh Datta on 22/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWCustomerLocation.h"

@implementation SWCustomerLocation
-(NSDictionary*)toDictionary{
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.latitude], @"latitude", [NSNumber numberWithFloat:self.longitude], @"longitude", self.device_id, @"device_id", nil];
    return data;
}

-(id<Serializable>)toObjectFromDictionary:(NSDictionary*)dictionary{
    //to do: implement
    return nil;
}

-(id)createObject{
    return [[SWCustomerLocation alloc]init];
}

@end
