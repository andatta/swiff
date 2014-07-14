//
//  ImageLoaderListener.h
//  Swiff
//
//  Created by Anutosh Datta on 13/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageLoaderListener <NSObject>
@required
-(void)imageDownloaded:(UIImage*)image;
@end
