//
//  SWNetworkCommunicator.h
//  Swiff
//
//  Created by Anutosh Datta on 15/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SWCustomer.h"
#import "JsonSerializer.h"
#import "SWNetworkException.h"
#import "SWNetwork.h"
@interface SWNetworkCommunicator : NSObject
@property NSDictionary* endpointProperties;

-(BOOL)registerCustomer:(SWCustomer*)customer;
-(void)registerForPush:(NSString*)customerId withToken:(NSString*)deviceToken;
@end
