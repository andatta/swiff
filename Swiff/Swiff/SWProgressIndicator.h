//
//  SWProgressIndicator.h
//  Swiff
//
//  Created by Anutosh Datta on 22/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWProgressIndicator : UIView
@property NSString* message;
@property UIView* contentView;
@property UIActivityIndicatorView* indicator;
@property UILabel* label;
@end
