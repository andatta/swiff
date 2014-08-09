//
//  QRGenerator.h
//  Swiff
//
//  Created by Anutosh Datta on 09/08/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRGenerator : NSObject
+(UIImage*)generateQRCodeForString:(NSString*)string;
@end
