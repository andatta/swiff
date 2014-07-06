//
//  SqliteStorableFactory.h
//  Swiff
//
//  Created by Anutosh Datta on 05/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SqliteStorableFactory <NSObject>
@required
-(id<SqliteStorable>)getObject;
@end
