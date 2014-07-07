//
//  SWFriendsListController.m
//  Swiff
//
//  Created by Anutosh Datta on 06/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWFriendsListController.h"
#import "SWRevealViewController.h"

@interface SWFriendsListController ()

@end

@implementation SWFriendsListController

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
    self.friendService = [[AddFriendsService alloc]init];
    [self.friendService syncFriends];
    
    self.title = NSLocalizedString(@"settings_tab", nil);
    // Change button color
    //_sideBarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.friendsList = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 600) style:UITableViewStylePlain];
    self.friendsList.dataSource = self;
    self.friendsList.delegate = self;
    [self addHeader];
    
    self.friends = [self.friendService getFriends];
    [self.friendsList reloadData];
    [self.view addSubview:self.friendsList];
}

-(void)addHeader{
    CGRect titleRect = CGRectMake(60, 60, 300, 40);
    UILabel *tableTitle = [[UILabel alloc] initWithFrame:titleRect];
    tableTitle.textColor = [UIColor blueColor];
    tableTitle.backgroundColor = [UIColor clearColor];
    tableTitle.opaque = YES;
    tableTitle.font = [UIFont boldSystemFontOfSize:18];
    self.friendsList.tableHeaderView = tableTitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friends.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* reuseIdentifier = @"friendCell";
    UITableViewCell *cell = [self.friendsList dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    SWFriend* friend = (SWFriend*)[self.friends objectAtIndex:indexPath.row];
    NSString* fullName = [NSString stringWithFormat:@"%@ %@", friend.first_name, friend.last_name];
    NSString* imageUrl = [NSString stringWithFormat:@"http://10.0.0.16:8000/media/%@", friend.profileImage];
    cell.textLabel.text = fullName;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:13.f];
    NSData* imagedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    cell.imageView.image = [UIImage imageWithData:imagedata];
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
