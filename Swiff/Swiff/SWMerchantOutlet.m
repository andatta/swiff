//
//  SWMerchantOutlet.m
//  Swiff
//
//  Created by Anutosh Datta on 25/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWMerchantOutlet.h"

@implementation SWMerchantOutlet
-(NSDictionary*)toDictionary{
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:self.latitude], @"latitude", [NSNumber numberWithFloat:self.longitude], @"longitude", self.name, @"name", self.merchant_name, @"merchant_name", self.description, @"description",nil];
    return data;
}

-(id<Serializable>)toObjectFromDictionary:(NSDictionary*)dictionary{
    //to do: implement
    return nil;
}

-(id<Serializable>)createObject{
    return [[SWMerchantOutlet alloc]init];
}

@end
