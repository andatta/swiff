//
//  SettingsManager.m
//  Swiff
//
//  Created by Lion User on 03/05/2014.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SettingsManager.h"

@implementation SettingsManager

static SettingsManager* instance = nil;

NSString* KEY_TEST_VALUE = @"testKey";
NSString* KEY_IS_REGISTERED = @"isRegistered";
NSString* KEY_LOCATION_UPDATE = @"locationUpdate";
NSString* KEY_LOCATION_UPDATE_INTERVAL = @"locationUpdateInterval";
NSString* KEY_DEVICE_TOKEN = @"deviceToken";

+(id)instance{
    if(instance == nil){
        instance = [[SettingsManager alloc]init];
    }
    return instance;
}

-(id)init{
    self = [super init];
    if(self){
        
        [self initWithData];
    }
    return self;
}

-(void)initWithData{
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    self.settings = (NSMutableDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!self.settings) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        self.settings = [[NSMutableDictionary alloc]init];
    }
}

-(void)setValue:(id)value forKey:(NSString *)key{
    [self.settings setValue:value forKey:key];
}

-(id)valueForKey:(NSString *)key withDefault:(id)defaultValue{
    if([self.settings valueForKey:key] == nil){
        return defaultValue;
    }
    return [self.settings valueForKey:key];
}

-(void)saveData{
    NSString* error;
    NSData* data = [NSPropertyListSerialization dataFromPropertyList:self.settings format:NSPropertyListXMLFormat_v1_0  errorDescription:&error];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString* plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    bool result = [data writeToFile:plistPath atomically:YES];
    if(result){
        NSLog(@"write success");
    }else{
        NSLog(@"write failed");
    }
}

-(void)setTestKey:(NSString *)val{
    [self setValue:val forKey:KEY_TEST_VALUE];
}

-(NSString*)testKey{
    return [self valueForKey:KEY_TEST_VALUE withDefault:@"default value"];
}

-(void)setIsRegistered:(BOOL)val{
    [self setValue:[NSNumber numberWithBool:val] forKey:KEY_IS_REGISTERED];
}

-(BOOL)isRegistered{
    NSNumber* value = [self valueForKey:KEY_IS_REGISTERED withDefault:[NSNumber numberWithBool:NO]];
    return [value boolValue];
}

-(void)setLocationUpdate:(BOOL)val{
    [self setValue:[NSNumber numberWithBool:val] forKey:KEY_LOCATION_UPDATE];
}

-(BOOL)locationUpdate{
    NSNumber* value = [self valueForKey:KEY_LOCATION_UPDATE withDefault:[NSNumber numberWithBool:YES]];
    return [value boolValue];
}

-(void)setLocationUpdateInterval:(int)val{
    [self setValue:[NSNumber numberWithInt:val] forKey:KEY_LOCATION_UPDATE_INTERVAL];
}

-(int)locationUpdateInterval{
    NSNumber* value = [self valueForKey:KEY_LOCATION_UPDATE_INTERVAL withDefault:[NSNumber numberWithInt:10]];
    return [value intValue];
}

-(void)setDeviceToken:(NSString *)val{
    [self setValue:val forKey:KEY_DEVICE_TOKEN];
}

-(NSString*)deviceToken{
    NSString* val = [self valueForKey:KEY_DEVICE_TOKEN withDefault:@""];
    return val;
}


@end
