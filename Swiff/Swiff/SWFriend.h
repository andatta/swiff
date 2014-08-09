//
//  SWFriend.h
//  Swiff
//
//  Created by Anutosh Datta on 06/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Serializable.h"
#import "SerializableFactory.h"
#import "SqliteStorable.h"
#import "SqliteStorableFactory.h"
#import "JsonSerializer.h"

@interface SWFriend : NSObject<Serializable, SerializableFactory, SqliteStorable, SqliteStorableFactory>
@property NSString* customerId;
@property NSString* first_name;
@property NSString* last_name;
@property NSString* dob;
@property NSString* email;
@property NSString* mobile;
@property NSString* profileImage;
@property NSString* status;
@end
