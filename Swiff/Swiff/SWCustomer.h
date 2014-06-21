//
//  SWCustomer.h
//  Swiff
//
//  Created by Anutosh Datta on 15/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Serializable.h"
#import "SerializableFactory.h"

@interface SWCustomer : NSObject<Serializable, SerializableFactory>
@property NSString* customerId;
@property NSString* first_name;
@property NSString* last_name;
@property NSString* dob;
@property NSString* email;
@property NSString* gender;
@property NSString* mobile;
@property NSString* deviceOsName;
@end
