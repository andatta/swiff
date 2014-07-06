//
//  SqliteStorage.m
//  Swiff
//
//  Created by Anutosh Datta on 05/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SqliteStorage.h"


@implementation SqliteStorage
static SqliteStorage* instance = nil;

+(id)instance{
    if(instance == nil){
        instance = [[SqliteStorage alloc]init];
    }
    return instance;
}

-(id)init{
    self = [super init];
    if(self){
        [self createDatabase];
    }
    return self;
}

-(void)createDatabase{
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
   self.databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"swiff.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [self.databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_swiffDB) == SQLITE_OK)
        {
            NSLog(@"database created");
            sqlite3_close(_swiffDB);
        } else {
            NSLog(@"Failed to open/create database");
        }
    }
}

-(BOOL)createTable:(NSString*)tableName{
    NSString* statement = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (UID TEXT, JSON TEXT)", tableName];
    const char* dbPath = [self.databasePath UTF8String];
    char* errMsg;
    const char* sql_stmt = [statement UTF8String];
    if(sqlite3_open(dbPath, &_swiffDB) == SQLITE_OK){
        if(sqlite3_exec(_swiffDB, sql_stmt, NULL, NULL, &errMsg) == SQLITE_OK){
            NSLog(@"table created");
            sqlite3_close(_swiffDB);
            return YES;
        }else{
            NSLog(@"Failed to create table");
        }
        sqlite3_close(_swiffDB);
    }else{
        NSLog(@"Failed to open/create database");
    }
    return NO;
}

-(BOOL)Add:(id<SqliteStorable>)object{
    NSString* tableName = [object className];
    if(![self createTable:tableName]){
        return NO;
    }
    NSString* uid = [object createUID];
    NSString* json = [object objectToJson];
    
    NSString* insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (UID, JSON) VALUES ('%@', '%@')", tableName, uid, json];
    const char* dbPath = [self.databasePath UTF8String];
    const char* insert_stmt = [insertSql UTF8String];
    sqlite3_stmt* statement;
    if(sqlite3_open(dbPath, &_swiffDB) == SQLITE_OK){
        sqlite3_prepare_v2(_swiffDB, insert_stmt, -1, &statement, NULL);
        if(sqlite3_step(statement) == SQLITE_DONE){
            sqlite3_finalize(statement);
            sqlite3_close(_swiffDB);
            return YES;
        }
        NSLog(@"error message: %s", sqlite3_errmsg(_swiffDB));
        sqlite3_finalize(statement);
        sqlite3_close(_swiffDB);
        return NO;
    }
    return NO;
}

-(BOOL)Update:(id<SqliteStorable>)object withUID:(NSString *)uid{
    NSString* tableName = [object className];
    if(![self createTable:tableName]){
        return NO;
    }
    NSString* json = [object objectToJson];
    NSString* updateSql = [NSString stringWithFormat:@"UPDATE %@ SET JSON = '%@' WHERE UID = '%@'", tableName, json, uid];
    const char* dbPath = [self.databasePath UTF8String];
    const char* update_stmt = [updateSql UTF8String];
    sqlite3_stmt* statement;
    if(sqlite3_open(dbPath, &_swiffDB) == SQLITE_OK){
        sqlite3_prepare_v2(_swiffDB, update_stmt, -1, &statement, NULL);
        if(sqlite3_step(statement) == SQLITE_DONE){
            sqlite3_finalize(statement);
            sqlite3_close(_swiffDB);
            return YES;
        }
        sqlite3_finalize(statement);
        sqlite3_close(_swiffDB);
        return NO;
    }
    return NO;
}

-(BOOL)Delete:(id<SqliteStorable>)object withUID:(NSString *)uid{
    NSString* tableName = [object className];
    if(![self createTable:tableName]){
        return NO;
    }
    NSString* deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE UID = '%@'", tableName, uid];
    const char* dbPath = [self.databasePath UTF8String];
    const char* delete_stmt = [deleteSql UTF8String];
    sqlite3_stmt* statement;
    if(sqlite3_open(dbPath, &_swiffDB) == SQLITE_OK){
        sqlite3_prepare_v2(_swiffDB, delete_stmt, -1, &statement, NULL);
        if(sqlite3_step(statement) == SQLITE_DONE){
            sqlite3_finalize(statement);
            sqlite3_close(_swiffDB);
            return YES;
        }
        sqlite3_finalize(statement);
        sqlite3_close(_swiffDB);
        return NO;
    }
    return NO;
}

-(BOOL)DeleteAll:(id<SqliteStorable>)object{
    NSString* tableName = [object className];
    if(![self createTable:tableName]){
        return NO;
    }
    NSString* deleteSql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    const char* dbPath = [self.databasePath UTF8String];
    const char* delete_stmt = [deleteSql UTF8String];
    sqlite3_stmt* statement;
    if(sqlite3_open(dbPath, &_swiffDB) == SQLITE_OK){
        sqlite3_prepare_v2(_swiffDB, delete_stmt, -1, &statement, NULL);
        if(sqlite3_step(statement) == SQLITE_DONE){
            sqlite3_finalize(statement);
            sqlite3_close(_swiffDB);
            return YES;
        }
        sqlite3_finalize(statement);
        sqlite3_close(_swiffDB);
        return NO;
    }
    return NO;

}

-(NSDictionary*)Select:(id<SqliteStorableFactory>)factory{
    NSMutableDictionary* result = [[NSMutableDictionary alloc]init];
    id<SqliteStorable>object = [factory getObject];
    NSString* tableName = [object className];
    if(![self createTable:tableName]){
        return result;
    }
    NSString* selectSql = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
    const char* dbPath = [self.databasePath UTF8String];
    const char* select_stmt = [selectSql UTF8String];
    sqlite3_stmt* statement;
    if(sqlite3_open(dbPath, &_swiffDB) == SQLITE_OK){
        sqlite3_prepare_v2(_swiffDB, select_stmt, -1, &statement, NULL);
        while(sqlite3_step(statement) == SQLITE_ROW){
            NSString* uid = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
            NSString* json = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement, 1)];
            id<SqliteStorable>returnedObject = [object jsonToObject:json];
            [result setValue:returnedObject forKey:uid];
        }
        sqlite3_finalize(statement);
        sqlite3_close(_swiffDB);
    }
    return result;
}
@end
