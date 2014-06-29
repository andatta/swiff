//
//  SWSettingsController.m
//  Swiff
//
//  Created by Anutosh Datta on 24/05/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWSettingsController.h"
#import "LocationService.h"
@interface SWSettingsController ()

@end

@implementation SWSettingsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //init table view
    self.title = @"SETTINGS";
    self.settingsView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 600) style:UITableViewStyleGrouped];
    self.settingsView.dataSource = self;
    self.settingsView.delegate = self;
    
    self.locationIntervalsView = [[UITableView alloc]initWithFrame:CGRectMake(30, 150, 250, 220) style:UITableViewStylePlain];
    self.locationIntervalsView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.locationIntervalsView.layer.cornerRadius = 10.0f;
    self.locationIntervalsView.backgroundColor = [UIColor colorWithRed:141/255.f green:158/255.f blue:178/255.f alpha:1.0];
    self.locationIntervalsView.dataSource = self;
    self.locationIntervalsView.delegate = self;
    
    [self initializeSettingsData];
    [self addSettingsHeader];
    [self.settingsView reloadData];
    [self.view addSubview:self.settingsView];
    
    self.locationUpdateIntervals = [[NSArray alloc]initWithObjects:@"10", @"30", @"45", @"60", nil];
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
    settingsPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    NSData *settingsXML = [[NSFileManager defaultManager] contentsAtPath:settingsPath];
    self.settings = (NSArray *)[NSPropertyListSerialization
                                propertyListFromData:settingsXML
                                mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                format:&format
                                errorDescription:&errorDesc];
}

-(void)addSettingsHeader{
    CGRect titleRect = CGRectMake(60, 60, 300, 40);
    UILabel *tableTitle = [[UILabel alloc] initWithFrame:titleRect];
    tableTitle.textColor = [UIColor blueColor];
    tableTitle.backgroundColor = [UIColor clearColor];
    tableTitle.opaque = YES;
    tableTitle.font = [UIFont boldSystemFontOfSize:18];
    //tableTitle.text = @"   SETTINGS";
    self.settingsView.tableHeaderView = tableTitle;
}

-(void)locationUpdateChanged:(id)sender{
    [[SettingsManager instance]setLocationUpdate:((UISwitch*)sender).isOn];
    if(![[SettingsManager instance] locationUpdate]){
        [[LocationService instance]stopUpdatingLocation];
    }else{
        [[LocationService instance]startUpdatingLocation];
    }
    [self.settingsView reloadData];
}

-(void)intervalSelected:(id)sender{
    NSInteger indexPathRow = ((UIButton*)sender).tag;
    int locationInterval = (int)[[self.locationUpdateIntervals objectAtIndex:indexPathRow]integerValue];
    [[SettingsManager instance]setLocationUpdateInterval:locationInterval];
    self.locationIntervalsView.hidden = YES;
    [self.locationIntervalsView removeFromSuperview];
    [self.settingsView reloadData];
    [[LocationService instance]locationUpdateIntervalChanged];
}

-(void)presentMerchantForm{
    self.merchantController = [self.storyboard instantiateViewControllerWithIdentifier:@"enterMerchant"];
    self.merchantController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:self.merchantController animated:YES completion:nil];
}

-(void)dismissMerchantForm{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.settingsView){
        return self.settings.count;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.settingsView){
        NSDictionary* category = [self.settings objectAtIndex:section];
        NSArray* options = [category valueForKey:@"options"];
        return options.count;
    }else{
        return self.locationUpdateIntervals.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.settingsView){
        NSDictionary* category = [self.settings objectAtIndex:indexPath.section];
        NSArray* options = [category valueForKey:@"options"];
        NSDictionary* option = [options objectAtIndex:indexPath.row];
    
        NSString* reuseIdentifier = @"settingsCell";
        UITableViewCell *cell = [self.settingsView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.text = [option valueForKey:@"title"];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13.f];
    
        cell.detailTextLabel.text = [option valueForKey:@"subtitle"];
        cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.detailTextLabel.numberOfLines = 0;
    
        NSString* item = @"access_location";
        NSString* locationIntervalitem = @"location_update_interval";
        if([item isEqual:[option valueForKey:@"item"]]){
            UISwitch* locationSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(1.0, 1.0, 20.0, 20.0)];
            locationSwitch.on = [[SettingsManager instance]locationUpdate];
            if(!locationSwitch.isOn){
                cell.detailTextLabel.text = [option valueForKey:@"subtitle_off"];
            }
            [locationSwitch addTarget:self action:@selector(locationUpdateChanged:) forControlEvents:(UIControlEventValueChanged | UIControlEventTouchDragInside)];
            cell.accessoryView = locationSwitch;
        }else if([locationIntervalitem isEqual:[option valueForKey:@"item"]]){
            NSString* subtitleText = [option valueForKey:@"subtitle"];
            int locationInterval = [[SettingsManager instance]locationUpdateInterval];
            NSString* locationIntervalStr = [NSString stringWithFormat:@"%i", locationInterval];
            cell.detailTextLabel.text = [subtitleText stringByReplacingOccurrencesOfString:@"X" withString:locationIntervalStr];
        }
        return cell;
    }else{
        NSString* reuseIdentifier = @"cell";
        UITableViewCell *cell = [self.locationIntervalsView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        //cell.selectionStyle = UItableviewsele
        NSMutableString* interval = (NSMutableString*)[self.locationUpdateIntervals objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", interval, @"minutes"];
        cell.backgroundColor = [UIColor clearColor];
        
        int locationUpdateInterval = [[SettingsManager instance]locationUpdateInterval];
        UIImage *image;
        if([[NSString stringWithFormat:@"%i", locationUpdateInterval] isEqualToString:interval]){
           image = [UIImage imageNamed:@"radio-button-on-icon.png"];
        }else{
            image = [UIImage imageNamed:@"radio-button-off-icon.png"];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
        button.frame = frame;   // match the button's size with the image size
        button.tag = indexPath.row;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(intervalSelected:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = button;
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView == self.settingsView){
        NSDictionary* category = [self.settings objectAtIndex:section];
        NSString* title = [category valueForKey:@"title"];
        return title;
    }else{
        return nil;
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.settingsView){
        return 80;
    }else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView == self.settingsView){
        return 20;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"switch clicked");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.settingsView){
        NSDictionary* category = [self.settings objectAtIndex:indexPath.section];
        NSArray* options = [category valueForKey:@"options"];
        NSDictionary* option = [options objectAtIndex:indexPath.row];
    
        if([@"location_update_interval" isEqual:[option valueForKey:@"item"]]){
            self.locationIntervalsView.hidden = NO;
            [self.view addSubview:self.locationIntervalsView];
            [self.locationIntervalsView reloadData];
        }else if([@"update_merchant" isEqual:[option valueForKey:@"item"]]){
            [self presentMerchantForm];
        }else if([@"profile_image" isEqual:[option valueForKey:@"item"]]){
            self.profilePicController = [self.storyboard instantiateViewControllerWithIdentifier:@"profilePicController"];
            [self.navigationController pushViewController:self.profilePicController animated:YES];
        }
    }else{
        self.locationIntervalsView.hidden = YES;
        [self.locationIntervalsView removeFromSuperview];
    }
}


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
