//
//  JsonSerializer.h
//  Swiff
//
//  Created by Lion User on 27/04/2014.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Serializable.h"
#import "SerializableFactory.h"
@interface JsonSerializer : NSObject
+(BOOL)objectToJson:(id<Serializable>)object String:(NSString**)string;

+(BOOL)objectArrayToJson:(NSArray*)objectArray String:(NSString**)string;

+(id<Serializable>)jsonToObject:(NSData*)jsonData objectFatcory:(id<SerializableFactory>)factory;

+(NSArray*)jsonarrayToObjects:(NSData*)jsonArray oobjectFatcory:(id<SerializableFactory>)factory;
@end
