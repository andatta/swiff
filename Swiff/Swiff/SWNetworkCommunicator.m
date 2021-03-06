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
    self.response = (NSHTTPURLResponse*)response;
    self.responseData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"request failed with error :%@", error.description);
    [self.delegate requestFailedWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"received data: %@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"finished loading");
    if([self.response statusCode] != 200 && [self.response statusCode] != 201){
        NSLog(@"request failed");
        NSError* error = [[NSError alloc]init];
        [self.delegate requestFailedWithError:error];
    }else{
        NSLog(@"request completed");
        [self.delegate requestComletedWithData:self.responseData];
    }
}

-(void)registerCustomer:(SWCustomer *)customer completionHandler:(void (^)(NSData *, NSError *))handler{
    SWNetwork* network = [[SWNetwork alloc]init];
    NSString* url = [self getUrl:[self.endpointProperties valueForKey:@"register_customer"]];
    NSMutableString* urlString = [[NSMutableString alloc]initWithString:url];
    [urlString appendString:@"?customerId="];
    [urlString appendString:customer.customerId];
    NSLog(@"request url: %@", urlString);
    [network initiateRequestWithUrl:[NSURL URLWithString:urlString] andContentType:@"application/json"];
    NSString* requestBody = nil;
    [JsonSerializer objectToJson:customer String:&requestBody];
    [network post:requestBody WithHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        handler(data, error);
    }];
}

-(void)registerForPush:(NSString *)customerId withToken:(NSString *)deviceToken completionHandler:(void (^)(NSData *, NSError *))handler{
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
    [network post:requestBody WithHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        handler(data, error);
    }];
}

-(void)updateLocation:(SWCustomerLocation *)location completionHandler:(void (^)(NSData *, NSError *))handler{
    SWNetwork* network = [[SWNetwork alloc]init];
    NSString* url = [self getUrl:[self.endpointProperties valueForKey:@"update_location"]];
    NSMutableString* urlString = [[NSMutableString alloc]initWithString:url];
    [urlString appendString:@"?customerId="];
    [urlString appendString:location.device_id];
    NSLog(@"request url: %@", urlString);
    [network initiateRequestWithUrl:[NSURL URLWithString:urlString] andContentType:@"application/json"];
    NSString* requestBody = nil;
    [JsonSerializer objectToJson:location String:&requestBody];
    [network post:requestBody WithHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        handler(data, error);
    }];

}

-(void)saveMercahntOutlet:(SWMerchantOutlet *)outlet completionHandler:(void (^)(NSData *, NSError *))handler{
    SWNetwork* network = [[SWNetwork alloc]init];
    NSString* url = [self getUrl:[self.endpointProperties valueForKey:@"save_merchant_outlet"]];
    NSMutableString* urlString = [[NSMutableString alloc]initWithString:url];
    NSLog(@"request url: %@", urlString);
    [network initiateRequestWithUrl:[NSURL URLWithString:urlString] andContentType:@"application/json"];
    NSString* requestBody = nil;
    [JsonSerializer objectToJson:outlet String:&requestBody];
    [network post:requestBody WithHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        handler(data, error);
    }];
}

-(void)uploadProfileImage:(UIImage *)image customerId:(NSString *)customerId completionHandler:(void (^)(NSData *, NSError *))handler{
    SWNetwork* network = [[SWNetwork alloc]init];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString* contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    NSString* url = [self getUrl:[self.endpointProperties valueForKey:@"upload_profile_image"]];
    NSMutableString* urlString = [[NSMutableString alloc]initWithString:url];
    [urlString appendString:@"?customerId="];
    [urlString appendString:customerId];
    NSLog(@"request url: %@", urlString);
    [network initiateRequestWithUrl:[NSURL URLWithString:urlString] andContentType:contentType];
    NSData* imageData = UIImagePNGRepresentation(image);
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profileImage\"; filename=\"%@\"\r\n", [NSString stringWithFormat:@"%@.png", customerId]]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [network multipartdata:body WithHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        handler(data, error);
    }];
}

-(void)syncFriends:(NSString *)customerId forContacts:(NSArray *)phoneNumbers completionHandler:(void (^)(NSData *, NSError *))handler{
    SWNetwork* network = [[SWNetwork alloc]init];
    NSString* url = [self getUrl:[self.endpointProperties valueForKey:@"sync_friends"]];
    NSMutableString* urlString = [[NSMutableString alloc]initWithString:url];
    [urlString appendString:@"?customerId="];
    [urlString appendString:customerId];
    NSLog(@"request url: %@", urlString);
    [network initiateRequestWithUrl:[NSURL URLWithString:urlString] andContentType:@"application/json"];
    //NSArray* msisdns = [[NSArray alloc]init];
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumbers, @"msisdns", nil];
    NSString* requestBody = nil;
    NSError* error = nil;
    if([NSJSONSerialization isValidJSONObject:data]){
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
        requestBody = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSLog(@"request body: %@", requestBody);
    [network post:requestBody WithHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        handler(data, error);
    }];
}

-(void)getUserCheckIns:(NSString *)customerId completionHandler:(void (^)(NSData *, NSError *))handler{
    SWNetwork* network = [[SWNetwork alloc]init];
    NSString* url = [self getUrl:[self.endpointProperties valueForKey:@"get_user_check_in"]];
    NSMutableString* urlString = [[NSMutableString alloc]initWithString:url];
    [urlString appendString:@"?customerId="];
    [urlString appendString:customerId];
    NSLog(@"request url: %@", urlString);
    [network initiateRequestWithUrl:[NSURL URLWithString:urlString] andContentType:@"application/json"];
    //[network asyncgetWithDelegate:self];
    [network getWithHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        handler(data, error);
    }];
}

-(void)getUserReviews:(NSString *)customerId completionHandler:(void (^)(NSData *, NSError *))handler{
    SWNetwork* network = [[SWNetwork alloc]init];
    NSString* url = [self getUrl:[self.endpointProperties valueForKey:@"get_user_review"]];
    NSMutableString* urlString = [[NSMutableString alloc]initWithString:url];
    [urlString appendString:@"?customerId="];
    [urlString appendString:customerId];
    NSLog(@"request url: %@", urlString);
    [network initiateRequestWithUrl:[NSURL URLWithString:urlString] andContentType:@"application/json"];
    [network getWithHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        handler(data, error);
    }];
}
@end
