//
//  SWNetwork.m
//  Swiff
//
//  Created by Anutosh Datta on 15/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWNetwork.h"

@implementation SWNetwork
-(void)initiateRequestWithUrl:(NSURL *)url andContentType:(NSString *)contentType{
    if(self.mRequest == nil){
        self.mRequest = [[NSMutableURLRequest alloc]initWithURL:url];
        [self.mRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    }
}

-(NSData*)getReturningResponse:(NSHTTPURLResponse **)response{
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:self.mRequest returningResponse:response error:&error];
    if(error != nil){
        NSLog(@"error is: %@", [error description]);
        NSLog(@"response status code: %d", (int)[*response statusCode]);
    }else{
        NSLog(@"No error with status : %d", (int)[*response statusCode]);
    }
    return data;
}

-(NSData*)postWithBody:(NSString *)body returningResponse:(NSHTTPURLResponse **)response{
   NSError* error = nil;
    self.mRequest.HTTPMethod = @"POST";
    self.mRequest.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSData* data = [NSURLConnection sendSynchronousRequest:self.mRequest returningResponse:response error:&error];
    if(error != nil){
        NSLog(@"error is: %@", [error description]);
        NSLog(@"response status code: %d", (int)[*response statusCode]);
    }else{
        NSLog(@"No error with status : %d", (int)[*response statusCode]);
    }
    return data;
}

-(NSData*)putWithBody:(NSString *)body returningResponse:(NSHTTPURLResponse **)response{
    NSError* error = nil;
    self.mRequest.HTTPMethod = @"PUT";
    self.mRequest.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSData* data = [NSURLConnection sendSynchronousRequest:self.mRequest returningResponse:response error:&error];
    if(error != nil){
        NSLog(@"error is: %@", [error description]);
        NSLog(@"response status code: %d", (int)[*response statusCode]);
    }else{
        NSLog(@"No error with status : %d", (int)[*response statusCode]);
    }
    return data;
}

-(void)asyncgetWithDelegate:(id)delegate{
    NSURLConnection* conn = [[NSURLConnection alloc]initWithRequest:self.mRequest delegate:delegate];
}

-(void)asyncPostWithBody:(NSString *)body delegate:(id)delegate{
    self.mRequest.HTTPMethod = @"POST";
    self.mRequest.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSURLConnection* conn = [[NSURLConnection alloc]initWithRequest:self.mRequest delegate:delegate];
}

-(void)asyncPutWithBody:(NSString *)body delegate:(id)delegate{
    self.mRequest.HTTPMethod = @"PUT";
    self.mRequest.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSURLConnection* conn = [[NSURLConnection alloc]initWithRequest:self.mRequest delegate:delegate];
}
@end
