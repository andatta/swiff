//
//  TestObject.m
//  Swiff
//
//  Created by Lion User on 27/04/2014.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "TestObject.h"

@implementation TestObject
-(NSDictionary*)toDictionary{
    NSMutableArray* carTypeJson = [[NSMutableArray alloc]init];
    for (RelatedObject *rel in self.carTypes) {
        [carTypeJson addObject:[rel toDictionary]];
    }
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:self.id, @"id", self.name, @"name", self.string_array, @"cars", [self.rel toDictionary], @"carType", carTypeJson, @"carTypes",nil];
    return data;
}
@end
