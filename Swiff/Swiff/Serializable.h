//
//  Serializable.h
//  Swiff
//
//  Created by Lion User on 27/04/2014.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Serializable <NSObject>

@required
-(NSDictionary*)toDictionary;
-(id<Serializable>)toObjectFromDictionary:(NSDictionary*)dictionary;

@end
