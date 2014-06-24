//
//  SWNetworkDelegate.h
//  Swiff
//
//  Created by Anutosh Datta on 22/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SWNetworkDelegate <NSObject>
@required
-(void)requestComletedWithData:(NSData*)data;
-(void)requestFailedWithError:(NSError*)error;
@end
