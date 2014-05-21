//
//  JsonSerializer.m
//  Swiff
//
//  Created by Lion User on 27/04/2014.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "JsonSerializer.h"

@implementation JsonSerializer

+(BOOL)objectToJson:(id<Serializable>)object String:(NSString**)string{
    NSDictionary* data = [object toDictionary];
    NSError* error = nil;
    if([NSJSONSerialization isValidJSONObject:data]){
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    *string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return YES;
    }
    return NO;
}

+(BOOL)objectArrayToJson:(NSArray *)objectArray String:(NSString **)string{
    NSMutableArray* dataArray = [[NSMutableArray alloc]init];
    for (id obj in objectArray) {
        if([obj respondsToSelector:@selector(toDictionary)]){
            [dataArray addObject:[obj toDictionary]];
        }
    }
    NSError* error = nil;
    if([NSJSONSerialization isValidJSONObject:dataArray]){
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingPrettyPrinted error:&error];
        *string = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return YES;
    }
    return NO;
}

+(id<Serializable>)jsonToObject:(NSData *)jsonData objectFatcory:(id<SerializableFactory>)factory{
    id<Serializable>retObject;
    id factoryObject;
    NSError* error = nil;
    NSDictionary* parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(parsedData != nil){
        if([NSJSONSerialization isValidJSONObject:parsedData]){
            factoryObject = [factory createObject];
            if([factoryObject respondsToSelector:@selector(toObjectFromDictionary:)]){
            retObject = [factoryObject toObjectFromDictionary:parsedData];
            }
        }
    }
    return retObject;
}

+(NSArray*)jsonarrayToObjects:(NSData *)jsonArray oobjectFatcory:(id<SerializableFactory>)factory{
    NSMutableArray* arrayOfObjects = [[NSMutableArray alloc]init];
}
@end
