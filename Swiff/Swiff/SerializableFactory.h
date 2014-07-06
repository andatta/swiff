//
//  SerializableFactory.h
//  Swiff
//
//  Created by Lion User on 28/04/2014.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Serializable.h"
@protocol SerializableFactory <NSObject>
@required
-(id<Serializable>)createObject;
@end
