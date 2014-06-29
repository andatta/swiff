//
//  SWNetwork.h
//  Swiff
//
//  Created by Anutosh Datta on 15/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWNetwork : NSObject
@property NSMutableURLRequest* mRequest;

-(void)initiateRequestWithUrl:(NSURL*)url andContentType:(NSString*)contentType;
-(NSData*)getReturningResponse:(NSHTTPURLResponse**)response;
-(NSData*)postWithBody:(NSString*)body returningResponse:(NSHTTPURLResponse**)response;
-(NSData*)putWithBody:(NSString*)body returningResponse:(NSHTTPURLResponse**)response;

-(void)asyncgetWithDelegate:(id)delegate;
-(void)asyncPostWithBody:(NSString*)body delegate:(id)delegate;
-(void)asyncPutWithBody:(NSString*)body delegate:(id)delegate;

-(void)uploadMultiPartData:(NSData*)multipartdata delegate:(id)delegate;
@end
