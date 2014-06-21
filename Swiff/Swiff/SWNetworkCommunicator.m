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

-(void)registerForPush:(NSString *)customerId withToken:(NSString *)deviceToken{
    SWNetwork* network = [[SWNetwork alloc]init];
    NSString* url = [self getUrl:[self.endpointProperties valueForKey:@"register_push"]];
    NSMutableString* urlString = [[NSMutableString alloc]initWithString:url];
    [urlString appendString:@"?customerId="];
    [urlString appendString:customerId];
    NSLog(@"request url: %@", urlString);
    [network initiateRequestWithUrl:[NSURL URLWithString:urlString] andContentType:@"application/json"];
    NSMutableString* requestBody = [[NSMutableString alloc]init];
    NSLog(@"device token: %@", deviceToken);
    [requestBody appendString:@"{\"push_id\":"];
    [requestBody appendString:deviceToken];
    [requestBody appendString:@"}"];
    NSLog(@"request body: %@", requestBody);
    NSHTTPURLResponse* response = nil;
    NSData* data = [network postWithBody:requestBody returningResponse:&response];
    NSLog(@"response data: %@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
}
@end
