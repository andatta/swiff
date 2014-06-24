//
//  SWNetworkCommunicator.m
//  Swiff
//
//  Created by Anutosh Datta on 15/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWNetworkCommunicator.h"

@implementation SWNetworkCommunicator
-(id)init{
    self = [super init];
    if(self){
        [self loadendpoints];
    }
    return self;
}

-(void)loadendpoints{
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    //initialize settings items
    NSString *propertiesPath;
    propertiesPath = [[NSBundle mainBundle] pathForResource:@"endpointProperties" ofType:@"plist"];
    NSData *propertiesXML = [[NSFileManager defaultManager] contentsAtPath:propertiesPath];
    self.endpointProperties = (NSDictionary *)[NSPropertyListSerialization
                                propertyListFromData:propertiesXML
                                mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                format:&format
                                errorDescription:&errorDesc];
}

-(NSString*)getUrl:(NSString*)endPoint{
    NSString* url = [NSString stringWithFormat:@"%@%@", [self.endpointProperties valueForKey:@"rootUrl"], endPoint];
    return url;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"response received");
    self.response = response;
    self.responseData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"request failed with error :%@", error.description);
    [self.delegate requestFailedWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [self.delegate requestComletedWithData:self.responseData];
}

-(BOOL)registerCustomer:(SWCustomer *)customer{
    SWNetwork* network = [[SWNetwork alloc]init];
    NSString* url = [self getUrl:[self.endpointProperties valueForKey:@"register_customer"]];
    NSMutableString* urlString = [[NSMutableString alloc]initWithString:url];
    [urlString appendString:@"?customerId="];
    [urlString appendString:customer.customerId];
    NSLog(@"request url: %@", urlString);
    [network initiateRequestWithUrl:[NSURL URLWithString:urlString] andContentType:@"application/json"];
    NSString* requestBody = nil;
    [JsonSerializer objectToJson:customer String:&requestBody];
    NSHTTPURLResponse* response = nil;
    NSData* data = [network postWithBody:requestBody returningResponse:&response];
    NSLog(@"response data: %@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    if([response statusCode] != 200 && [response statusCode] != 201){
        return NO;
    }
    return YES;
}

-(BOOL)registerForPush:(NSString *)customerId withToken:(NSString *)deviceToken{
    SWNetwork* network = [[SWNetwork alloc]init];
    NSString* url = [self getUrl:[self.endpointProperties valueForKey:@"register_push"]];
    NSMutableString* urlString = [[NSMutableString alloc]initWithString:url];
    [urlString appendString:@"?customerId="];
    [urlString appendString:customerId];
    NSLog(@"request url: %@", urlString);
    [network initiateRequestWithUrl:[NSURL URLWithString:urlString] andContentType:@"application/json"];
    NSString* requestBody;
    NSLog(@"device token: %@", deviceToken);
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:deviceToken, @"push_id", nil];
    NSError* error = nil;
    if([NSJSONSerialization isValidJSONObject:data]){
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
        requestBody = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSLog(@"request body: %@", requestBody);
    NSHTTPURLResponse* response = nil;
    NSData* responseData = [network postWithBody:requestBody returningResponse:&response];
    NSLog(@"response data: %@", [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]);
    if([response statusCode] != 200 && [response statusCode] != 201){
        return NO;
    }
    return YES;
}

-(void)updateLocation:(SWCustomerLocation *)location{
    SWNetwork* network = [[SWNetwork alloc]init];
    NSString* url = [self getUrl:[self.endpointProperties valueForKey:@"update_location"]];
    NSMutableString* urlString = [[NSMutableString alloc]initWithString:url];
    [urlString appendString:@"?customerId="];
    [urlString appendString:location.device_id];
    NSLog(@"request url: %@", urlString);
    [network initiateRequestWithUrl:[NSURL URLWithString:urlString] andContentType:@"application/json"];
    NSString* requestBody = nil;
    [JsonSerializer objectToJson:location String:&requestBody];
    [network asyncPostWithBody:requestBody delegate:self];

}

-(BOOL)saveMercahntOutlet:(SWMerchantOutlet *)outlet{
    SWNetwork* network = [[SWNetwork alloc]init];
    NSString* url = [self getUrl:[self.endpointProperties valueForKey:@"save_merchant_outlet"]];
    NSMutableString* urlString = [[NSMutableString alloc]initWithString:url];
    NSLog(@"request url: %@", urlString);
    [network initiateRequestWithUrl:[NSURL URLWithString:urlString] andContentType:@"application/json"];
    NSString* requestBody = nil;
    [JsonSerializer objectToJson:outlet String:&requestBody];
    NSHTTPURLResponse* response = nil;
    NSData* data = [network postWithBody:requestBody returningResponse:&response];
    NSLog(@"response data: %@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    if([response statusCode] != 200 && [response statusCode] != 201){
        return NO;
    }
    return YES;
}
@end
