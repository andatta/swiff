//
//  RelatedObject.h
//  Swiff
//
//  Created by Lion User on 27/04/2014.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Serializable.h"

@interface RelatedObject : NSObject<Serializable>
@property NSNumber* id;
@property NSString* make;
@end
