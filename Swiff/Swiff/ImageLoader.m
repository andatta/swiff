//
//  ImageLoader.m
//  Swiff
//
//  Created by Anutosh Datta on 13/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "ImageLoader.h"

@implementation ImageLoader

static ImageLoader* instance = nil;

+(id)instance{
    if(instance == nil){
        instance = [[ImageLoader alloc]init];
    }
    return instance;
}

-(id)init{
    self = [super init];
    if(self){
        [self loadendpoints];
        self.listeners = [[NSMutableArray alloc]init];
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

-(NSString*)getUrl:(NSString*)path{
    NSString* url = [NSString stringWithFormat:@"%@media/%@", [self.endpointProperties valueForKey:@"rootUrl"], path];
    NSLog(@"image url:%@", url);
    return url;
}

-(UIImage*)getImageForPath:(NSString *)path{
    UIImage* cacheImage;
    if([self.cache valueForKey:path] != nil){
        cacheImage = [self.cache valueForKey:path];
        return cacheImage;
    }
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString* imagePath = [rootPath stringByAppendingPathComponent:[self getFileName:path]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
       NSData *imageData = [[NSFileManager defaultManager] contentsAtPath:imagePath];
        UIImage* image = [UIImage imageWithData:imageData];
        [self.cache setObject:image forKey:path];
        cacheImage = image;
        return cacheImage;
    }
    [self scheduleImageDownload:path];
    return cacheImage;
}

-(void)scheduleImageDownload:(NSString*)path{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSURL *imageURL = [NSURL URLWithString:[self getUrl:path]];
                       __block NSData *imageData;
                       dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                                     ^{
                                         imageData = [NSData dataWithContentsOfURL:imageURL];
                                         UIImage* image = [UIImage imageWithData:imageData];
                                         [self.cache removeObjectForKey:path];
                                         [self.cache setObject:image forKey:path];
                                         [self writeImage:imageData ForPath:path];
                                         dispatch_sync(dispatch_get_main_queue(), ^{
                                             //notify listeners
                                             for (id<ImageLoaderListener>listener in self.listeners) {
                                                 [listener imageDownloaded:image];
                                             }
                                         });
                                     });
                   });
}

-(void)writeImage:(NSData*)imageData ForPath:(NSString*)path{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString* imagePath = [rootPath stringByAppendingPathComponent:[self getFileName:path]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        [[NSFileManager defaultManager]removeItemAtPath:imagePath error:NULL];
    }
    [imageData writeToFile:imagePath atomically:YES];
}

-(NSString*)getFileName:(NSString*)path{
    NSArray* filePathParts = [path componentsSeparatedByString:@"/"];
    if(filePathParts.count > 1){
        return filePathParts[1];
    }
    return nil;
}

-(void)addListener:(id<ImageLoaderListener>)listener{
    [self.listeners addObject:listener];
    NSLog(@"no of listeners: %d", [self.listeners count]);
}

-(BOOL)removeListener:(id<ImageLoaderListener>)listener{
    for (id object in self.listeners) {
        if([object isEqual:listener]){
            [self.listeners removeObject:listener];
            return YES;
        }
    }
    return NO;
}

@end
