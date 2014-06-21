//
//  SettingsManager.h
//  Swiff
//
//  Created by Lion User on 03/05/2014.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject

@property NSMutableDictionary* settings;

+(id)instance;
-(void)saveData;

-(void)setTestKey:(NSString*)val;
-(NSString*)testKey;
-(void)setIsRegistered:(BOOL)val;
-(BOOL)isRegistered;
-(void)setLocationUpdate:(BOOL)val;
-(BOOL)locationUpdate;
-(void)setLocationUpdateInterval:(int)val;
-(int)locationUpdateInterval;
-(NSString*)deviceToken;
-(void)setDeviceToken:(NSString*)val;
@end
