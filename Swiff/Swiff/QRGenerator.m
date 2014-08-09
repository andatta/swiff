//
//  QRGenerator.m
//  Swiff
//
//  Created by Anutosh Datta on 09/08/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "QRGenerator.h"

@implementation QRGenerator

+ (UIImage *)generateQRCodeForString:(NSString *)string{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:stringData forKey:@"inputMessage"];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    return [UIImage imageWithCIImage:filter.outputImage];
}

@end
