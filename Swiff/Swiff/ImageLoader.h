//
//  ImageLoader.h
//  Swiff
//
//  Created by Anutosh Datta on 13/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageLoaderListener.h"
@interface ImageLoader : NSObject

+(id)instance;
-(UIImage*)getImageForPath:(NSString*)path completionHandler:(void (^)(UIImage*))handler;
-(void)addListener:(id<ImageLoaderListener>)listener;
-(BOOL)removeListener:(id<ImageLoaderListener>)listener;

@property NSMutableDictionary* cache;
@property NSMutableDictionary* fileNameCache;
@property NSDictionary* endpointProperties;
@property NSMutableArray* listeners;
@end
