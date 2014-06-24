//
//  LocationService.h
//  Swiff
//
//  Created by Lion User on 03/05/2014.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "SWNetworkCommunicator.h"

@interface LocationService : NSObject<CLLocationManagerDelegate, SWNetworkDelegate>
+(id)instance;
-(void)getCurrentLatitude:(NSString**)latitude andLongitude:(NSString**)longitude;
-(void)stopLocationService;

-(void)startUpdatingLocation;
-(void)locationUpdateIntervalChanged;

@property NSTimer* locationUpdateTimer;
@end
