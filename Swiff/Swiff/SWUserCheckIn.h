//
//  SWUserCheckIn.h
//  Swiff
//
//  Created by Anutosh Datta on 09/08/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Serializable.h"
#import "SerializableFactory.h"

@interface SWUserCheckIn : NSObject<Serializable, SerializableFactory>
@property NSString* outletName;
@property NSString* checkInDate;
@end
