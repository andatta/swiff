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
#import "SWCustomerLocation.h"
#import "SWMerchantOutlet.h"

@interface SWNetworkCommunicator : NSObject<NSURLConnectionDelegate>
@property NSDictionary* endpointProperties;
@property NSMutableData* responseData;
@property NSHTTPURLResponse* response;
@property id<SWNetworkDelegate>delegate;
-(void)registerCustomer:(SWCustomer*)customer;
-(void)registerForPush:(NSString*)customerId withToken:(NSString*)deviceToken;
-(void)updateLocation:(SWCustomerLocation*)location;
-(void)saveMercahntOutlet:(SWMerchantOutlet*)outlet;
-(void)uploadProfileImage:(UIImage*)image customerId:(NSString*)customerId;
-(void)syncFriends:(NSString*)customerId;
@end
