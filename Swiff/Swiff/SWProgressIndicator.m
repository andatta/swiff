//
//  SWProgressIndicator.m
//  Swiff
//
//  Created by Anutosh Datta on 22/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWProgressIndicator.h"

@implementation SWProgressIndicator

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
    self.backgroundColor = [UIColor lightGrayColor];
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(1, 1, 278, 78)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    self.indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(5, 10, 50, 50)];
    self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.indicator startAnimating];
    [self.contentView addSubview:self.indicator];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 200, 50)];
    //self.label.text = @"Please wait while you are being registered";
    self.label.font = [UIFont systemFontOfSize:13.0f];
    self.label.numberOfLines =0;
    self.label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.label];
}

@end
