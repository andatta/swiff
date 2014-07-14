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
        return [[ImageLoader alloc]init];
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
    NSString* imageKey = [self getImageKey:path];
    UIImage* cacheImage;
    if([self.cache valueForKey:imageKey] != nil){
        cacheImage = [self.cache valueForKey:imageKey];
        return cacheImage;
    }
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString* imagePath = [rootPath stringByAppendingPathComponent:[self getFileName:imageKey]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
       NSData *imageData = [[NSFileManager defaultManager] contentsAtPath:imagePath];
        UIImage* image = [UIImage imageWithData:imageData];
        [self.cache setObject:image forKey:imageKey];
        [self.fileNameCache removeObjectForKey:[self getFileNameKey:path]];
        [self.fileNameCache setObject:[self getFileName:imageKey] forKey:[self getFileNameKey:path]];
        cacheImage = image;
        return cacheImage;
    }
    [self scheduleImageDownload:path];
    return cacheImage;
}

-(void)scheduleImageDownload:(NSString*)path{
    NSString* imageKey = [self getImageKey:path];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSURL *imageURL = [NSURL URLWithString:[self getUrl:imageKey]];
                       __block NSData *imageData;
                       dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                                     ^{
                                         imageData = [NSData dataWithContentsOfURL:imageURL];
                                         UIImage* image = [UIImage imageWithData:imageData];
                                         [self.cache removeObjectForKey:imageKey];
                                         [self.cache setObject:image forKey:imageKey];
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
    NSString* imageKey = [self getImageKey:path];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString* imagePath = [rootPath stringByAppendingPathComponent:[self getFileName:imageKey]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        [[NSFileManager defaultManager]removeItemAtPath:imagePath error:NULL];
    }
    //remove old image
    NSString* oldFileName = [self.fileNameCache objectForKey:[self getFileNameKey:path]];
    NSString* oldimagePath = [rootPath stringByAppendingPathComponent:oldFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:oldimagePath]) {
        //[[NSFileManager defaultManager]removeItemAtPath:oldimagePath error:NULL];
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
}

-(NSString*)getFileNameKey:(NSString*)path{
    NSArray* pathParts = [path componentsSeparatedByString:@"||"];
    if(pathParts.count > 1){
        return pathParts[1];
    }
    return nil;
}

-(NSString*)getImageKey:(NSString*)path{
    NSArray* pathParts = [path componentsSeparatedByString:@"||"];
    if(pathParts.count > 1){
        return pathParts[0];
    }
    return nil;
}
@end
