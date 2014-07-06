//
//  SWCustomer.m
//  Swiff
//
//  Created by Anutosh Datta on 15/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWCustomer.h"

@implementation SWCustomer
-(NSDictionary*)toDictionary{
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:self.customerId, @"customerId", self.first_name, @"first_name", self.last_name, @"last_name", self.dob, @"dob", self.email, @"email", self.gender, @"gender", self.mobile, @"mobile", self.deviceOsName, @"deviceOsName", nil];
    return data;
}

-(id<Serializable>)toObjectFromDictionary:(NSDictionary*)dictionary{
    //to do: implement
    return nil;
}

-(id<Serializable>)createObject{
    return [[SWCustomer alloc]init];
}
@end
