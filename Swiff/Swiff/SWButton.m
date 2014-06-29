//
//  SWButton.m
//  Swiff
//
//  Created by Anutosh Datta on 28/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWButton.h"

@implementation SWButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor* color = [UIColor colorWithRed:160/255.f green:230/255.f blue:222/255.f alpha:1];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, self.bounds);
    self.layer.cornerRadius = 10.0f;
    //self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
}


@end
