//
//  RelatedObject.m
//  Swiff
//
//  Created by Lion User on 27/04/2014.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "RelatedObject.h"

@implementation RelatedObject
-(NSDictionary*)toDictionary{
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:self.id, @"id", self.make, @"make", nil];
    return data;
}
@end
