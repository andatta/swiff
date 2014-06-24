//
//  SWMerchantOutlet.h
//  Swiff
//
//  Created by Anutosh Datta on 25/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SerializableFactory.h"
#import "Serializable.h"

@interface SWMerchantOutlet : NSObject<Serializable, SerializableFactory>
@property NSString* name;
@property NSString* merchant_name;
@property NSString* description;
@property float latitude;
@property float longitude;
@end
