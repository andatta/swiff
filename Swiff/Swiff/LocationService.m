//
//  LocationService.m
//  Swiff
//
//  Created by Lion User on 03/05/2014.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "LocationService.h"
#import "SettingsManager.h"
#import "SWCustomerLocation.h"
@implementation LocationService

static LocationService* _instance = nil;

CLLocationManager* locationManager;
NSString* currentLatitide;
NSString* currentLongitude;

float latitudeInFloat;
float longitudeInFloat;

+(id)instance{
    if(_instance == nil){
        _instance = [[LocationService alloc]init];
    }
    return _instance;
}

-(id)init{
    self = [super init];
    if(self){
        locationManager = [[CLLocationManager alloc]init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 200;
        locationManager.pausesLocationUpdatesAutomatically = YES;
        locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        NSLog(@"start updating locations");
        [locationManager startUpdatingLocation];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
didUpdateLocations:(NSArray *)locations{
    
    CLLocation* location = [locations lastObject];
    NSLog(@"latitude %+.6f, longitude %+.6f\n", location.coordinate.latitude, location.coordinate.longitude);
    latitudeInFloat = location.coordinate.latitude;
    longitudeInFloat = location.coordinate.longitude;
    currentLatitide = [[NSNumber numberWithFloat:location.coordinate.latitude]stringValue];
    currentLongitude = [[NSNumber numberWithFloat:location.coordinate.longitude]stringValue];
}

-(void)getCurrentLatitude:(NSString *__autoreleasing *)latitude andLongitude:(NSString *__autoreleasing *)longitude{
    if(currentLatitide == nil){
        *latitude = @"";
    }else{
        *latitude = currentLatitide;
    }
    
    if(currentLongitude == nil){
        *longitude = @"";
    }else{
        *longitude = currentLongitude;
    }
}

-(void)stopLocationService{
    [locationManager stopUpdatingLocation];
}

-(void)startUpdatingLocation{
    [self updateLocation];
    int duration = [[SettingsManager instance]locationUpdateInterval]*60;
    self.locationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];
}

-(void)updateLocation{
    SWCustomerLocation* location = [[SWCustomerLocation alloc]init];
    location.latitude = latitudeInFloat;
    location.longitude = longitudeInFloat;
    location.device_id = [[[UIDevice currentDevice]identifierForVendor]UUIDString];
    SWNetworkCommunicator* comm = [[SWNetworkCommunicator alloc]init];
    [comm updateLocation:location completionHandler:^(NSData *data, NSError *error) {
        if (error == NULL) {
            NSLog(@"location updated: %@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        } else {
            NSLog(@"location update falied with error: %@", error.description);
        }
    }];
}

-(void)locationUpdateIntervalChanged{
    if(self.locationUpdateTimer != nil){
        [self.locationUpdateTimer invalidate];
    }
    [self startUpdatingLocation];
}

-(void)requestComletedWithData:(NSData*)data{
    NSLog(@"location updated: %@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
}
-(void)requestFailedWithError:(NSError*)error{
    NSLog(@"location update falied with error: %@", error.description);
}

-(float)latitude{
    return latitudeInFloat;
}

-(float)longitude{
    return longitudeInFloat;
}

-(void)stopUpdatingLocation{
    [self.locationUpdateTimer invalidate];
}

@end
