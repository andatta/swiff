//
//  SWSettingsControllerTableViewController.h
//  Swiff
//
//  Created by Anutosh Datta on 21/05/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWSettingsControllerTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
@property NSArray* settings;
@property NSArray* settingsCategories;
@end
