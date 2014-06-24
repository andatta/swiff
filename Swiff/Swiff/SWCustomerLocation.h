//
//  SWCustomerLocation.h
//  Swiff
//
//  Created by Anutosh Datta on 22/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serializable.h"
#import "SerializableFactory.h"

@interface SWCustomerLocation : NSObject<Serializable, SerializableFactory>
@property float latitude;
@property float longitude;
@property NSString* device_id;
@end
