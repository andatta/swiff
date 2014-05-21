//
//  TestObject.h
//  Swiff
//
//  Created by Lion User on 27/04/2014.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Serializable.h"
#import "RelatedObject.h"
@interface TestObject : NSObject<Serializable>
@property NSNumber* id;
@property NSString* name;
@property NSArray* string_array;
@property RelatedObject* rel;
@property NSArray* carTypes;
@end
