//
//  SqliteStorage.h
//  Swiff
//
//  Created by Anutosh Datta on 05/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "SqliteStorable.h"
#import "SqliteStorableFactory.h"
@interface SqliteStorage : NSObject
+(id)instance;

-(BOOL)Add:(id<SqliteStorable>)object;
-(BOOL)Update:(id<SqliteStorable>)object withUID:(NSString*)uid;
-(BOOL)Delete:(id<SqliteStorable>)object withUID:(NSString*)uid;
-(BOOL)DeleteAll:(id<SqliteStorable>)object;
-(NSDictionary*)Select:(id<SqliteStorableFactory>)factory;

@property sqlite3* swiffDB;
@property NSString* databasePath;
@end
