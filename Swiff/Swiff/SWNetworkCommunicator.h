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
-(void)registerCustomer:(SWCustomer*)customer completionHandler:(void (^)(NSData*, NSError*))handler;
-(void)registerForPush:(NSString*)customerId withToken:(NSString*)deviceToken completionHandler:(void (^)(NSData*, NSError*))handler;
-(void)updateLocation:(SWCustomerLocation*)location completionHandler:(void (^)(NSData*, NSError*))handler;
-(void)saveMercahntOutlet:(SWMerchantOutlet*)outlet completionHandler:(void (^)(NSData*, NSError*))handler;
-(void)uploadProfileImage:(UIImage*)image customerId:(NSString*)customerId completionHandler:(void (^)(NSData*, NSError*))handler;
-(void)syncFriends:(NSString*)customerId forContacts:(NSArray*)phoneNumbers completionHandler:(void (^)(NSData*, NSError*))handler;
-(void)getUserCheckIns:(NSString*)customerId completionHandler:(void (^)(NSData*, NSError*))handler;
-(void)getUserReviews:(NSString*)customerId completionHandler:(void (^)(NSData*, NSError*))handler;
@end
