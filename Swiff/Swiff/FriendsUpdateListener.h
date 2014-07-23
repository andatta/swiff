//
//  FriendsUpdateListener.h
//  Swiff
//
//  Created by Anutosh Datta on 19/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FriendsUpdateListener <NSObject>
@required
-(void)friendsSynced;
@end
