//
//  SWUserReview.m
//  Swiff
//
//  Created by Anutosh Datta on 09/08/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWUserReview.h"

@implementation SWUserReview
//Serializable methods
-(NSDictionary*)toDictionary{
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:self.review, @"review", self.outletName, @"outletName", self.reviewDate, @"reviewDate", self.outletLogo, @"outletLogo",nil];
    return data;
}

-(id<Serializable>)toObjectFromDictionary:(NSDictionary*)dictionary{
    SWUserReview* userReview = [[SWUserReview alloc]init];
    userReview.outletName = [dictionary valueForKey:@"outletName"];
    userReview.review = [dictionary valueForKey:@"review"];
    userReview.reviewDate = [dictionary valueForKey:@"reviewDate"];
    userReview.outletLogo = [dictionary valueForKey:@"outletLogo"];
    return userReview;
}

//Serializable factory methods
-(id<Serializable>)createObject{
    return [[SWUserReview alloc]init];
}
@end
