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
#import "SWNetworkDelegate.h"

@interface SWNetworkCommunicator : NSObject<NSURLConnectionDelegate>
@property NSDictionary* endpointProperties;
@property NSMutableData* responseData;
@property NSURLResponse* response;
@property id<SWNetworkDelegate>delegate;
-(BOOL)registerCustomer:(SWCustomer*)customer;
-(BOOL)registerForPush:(NSString*)customerId withToken:(NSString*)deviceToken;
@end
