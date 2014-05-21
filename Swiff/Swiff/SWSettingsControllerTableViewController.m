//
//  SWSettingsControllerTableViewController.m
//  Swiff
//
//  Created by Anutosh Datta on 21/05/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWSettingsControllerTableViewController.h"

@interface SWSettingsControllerTableViewController ()

@end

@implementation SWSettingsControllerTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self initializeSettingsData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initializeSettingsData{
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    //initialize settings items
    NSString *settingsPath;
    settingsPath = [[NSBundle mainBundle] pathForResource:@"UserSettings" ofType:@"plist"];
    NSData *settingsXML = [[NSFileManager defaultManager] contentsAtPath:settingsPath];
    self.settings = (NSArray *)[NSPropertyListSerialization
                                            propertyListFromData:settingsXML
                                            mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                            format:&format
                                            errorDescription:&errorDesc];
    
    //initialize settings categories
    NSString* settingsCategoriesPath = [[NSBundle mainBundle] pathForResource:@"SettingsCategory" ofType:@"plist"];
    NSData *settingsCategoriesXML = [[NSFileManager defaultManager] contentsAtPath:settingsCategoriesPath];
    self.settingsCategories = (NSArray *)[NSPropertyListSerialization
                                propertyListFromData:settingsCategoriesXML
                                mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                format:&format
                                errorDescription:&errorDesc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"no of sections %i", (int)self.settingsCategories.count);
    return self.settingsCategories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount = 0;
    NSString* sectionName = self.settingsCategories[section];
    for(NSDictionary* dict in self.settings){
        if([dict valueForKey:@"category"] == sectionName){
            rowCount++;
        }
    }
    NSLog(@"no of rows %i", rowCount);
    return rowCount;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
