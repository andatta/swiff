//
//  SWGeneralStateDialog.m
//  Swiff
//
//  Created by Anutosh Datta on 22/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWGeneralStateDialog.h"

@implementation SWGeneralStateDialog

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setUp{
    self.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.9];
    self.opaque = NO;
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 280, 50)];
    //self.label.text = @"Please wait while you are being registered";
    self.label.font = [UIFont systemFontOfSize:15.0f ];
    self.label.textColor = [UIColor whiteColor];
    self.label.numberOfLines =0;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:self.label];
}

@end
