//
//  SWFriendsListController.m
//  Swiff
//
//  Created by Anutosh Datta on 06/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWFriendsListController.h"
#import "SWRevealViewController.h"
#import "QRGenerator.h"

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
    self.friendService.delegate = self;
    [self.friendService syncFriends];
    
    //register for image load updates
    [[ImageLoader instance]removeListener:self];
    [[ImageLoader instance]addListener:self];
    
    self.title = NSLocalizedString(@"friends_tab", nil);
    
    UIBarButtonItem* sideBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    sideBarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = sideBarButton;
    
    self.addfriendBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add_friend.png"] style:UIBarButtonItemStylePlain target:self action:@selector(inviteFriend)];
    self.addfriendBarButton.tintColor = [UIColor whiteColor];
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.friends = [self.friendService getFriends];
    if(self.friends.count > 0){
        [self addFriendsTableView];
        self.navigationItem.rightBarButtonItem = self.addfriendBarButton;
    }else{
        [self addImageButton];
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}

-(void)addFriendsTableView{
    if(self.friendsList == nil){
        self.friendsList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 600) style:UITableViewStylePlain];
        self.friendsList.dataSource = self;
        self.friendsList.delegate = self;
        self.friendsList.separatorColor = [UIColor whiteColor];
        [self addHeader];
        [self addFooter];
    }
    self.friendsList.hidden = NO;
    [self.friendsList reloadData];
    [self.view addSubview:self.friendsList];
    
}

-(void)removeFriendsTableView{
    self.friendsList.hidden = YES;
    [self.friendsList removeFromSuperview];
}

-(void)addImageButton{
    if(self.addFriendImageButton == nil){
        UIImage *buttonImage = [UIImage imageNamed:@"addafriendlogo.png"];
        
        self.addFriendImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addFriendImageButton.frame = CGRectMake(70, 50, 200, 200);
        [self.addFriendImageButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [self.addFriendImageButton addTarget:self action:@selector(inviteFriend) forControlEvents:UIControlEventTouchUpInside];
    }
    if(self.noFriendLabel == nil){
        self.noFriendLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, 320, 200)];
        self.noFriendLabel.numberOfLines = 0;
        self.noFriendLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.noFriendLabel.font = [UIFont systemFontOfSize:13.0f];
        self.noFriendLabel.textColor = [UIColor grayColor];
        self.noFriendLabel.text = NSLocalizedString(@"no_friend_text", nil);
    }
    self.addFriendImageButton.hidden = NO;
    [self.view addSubview:self.addFriendImageButton];
    
    self.noFriendLabel.hidden = NO;
    [self.view addSubview:self.noFriendLabel];
}

-(void)removeFriendImageButton{
    self.addFriendImageButton.hidden = YES;
    [self.addFriendImageButton removeFromSuperview];
    
    self.noFriendLabel.hidden = YES;
    [self.noFriendLabel removeFromSuperview];
}


-(void)addHeader{
    CGRect titleRect = CGRectMake(60, 60, 300, 20);
    UILabel *tableTitle = [[UILabel alloc] initWithFrame:titleRect];
    tableTitle.textColor = [UIColor blueColor];
    tableTitle.backgroundColor = [UIColor clearColor];
    tableTitle.opaque = YES;
    tableTitle.font = [UIFont boldSystemFontOfSize:18];
    self.friendsList.tableHeaderView = tableTitle;
}

-(void)addFooter{
    CGRect footer = CGRectMake(0, 0, self.view.frame.size.width, 1);
    UIView* footerView = [[UIView alloc]initWithFrame:footer];
    self.friendsList.tableFooterView = footerView;
}

-(void)inviteFriend{
    self.inviteController = [self.storyboard instantiateViewControllerWithIdentifier:@"inviteFriendController"];
    [self.navigationController pushViewController:self.inviteController animated:YES];
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
    SWFriend* friend = (SWFriend*)[self.friends objectAtIndex:indexPath.row];
    NSString* fullName = [NSString stringWithFormat:@"%@ %@", friend.first_name, friend.last_name];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableCell"];
    }
    UIImageView* profileImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 60, 60)];
    UIImage* _profileImage;
    _profileImage = [[ImageLoader instance]getImageForPath: friend.profileImage completionHandler:^(UIImage * image) {
        profileImage.image = image;
    }];
    if(_profileImage == nil){
        _profileImage = [QRGenerator generateQRCodeForString:friend.customerId];
    }
    profileImage.image = _profileImage;
    profileImage.transform = CGAffineTransformMakeRotation(M_PI/2);
    [cell.contentView addSubview:profileImage];
    
    UILabel* friendNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 200, 50)];
    friendNameLabel.numberOfLines = 0;
    friendNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    friendNameLabel.font = [UIFont systemFontOfSize:14.0f];
    friendNameLabel.text = fullName;
    [cell.contentView addSubview:friendNameLabel];
    
    UILabel* statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, 200, 50)];
    //statusLabel.numberOfLines = 0;
    //statusLabel.lineBreakMode = NSLineBreakByWordWrapping;
    statusLabel.font = [UIFont systemFontOfSize:12.0f];
    statusLabel.textColor = [UIColor darkGrayColor];
    statusLabel.text = ([friend.status isEqualToString:@""]) ? @"Joined Cawver" : friend.status;
    [cell.contentView addSubview:statusLabel];
    
    UIView* separatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 78, self.view.frame.size.width, 0.5)];
    separatorView.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:separatorView];
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.userDetailController = [self.storyboard instantiateViewControllerWithIdentifier:@"userDetailController"];
    self.userDetailController.friendObject = (SWFriend*)[self.friends objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:self.userDetailController animated:YES];
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

-(void)imageDownloaded:(UIImage*)image{
    [self.friendsList reloadData];
}

-(void)friendsSynced{
    self.friends = [self.friendService getFriends];
    [self removeFriendsTableView];
    [self removeFriendImageButton];
    self.navigationItem.rightBarButtonItem = nil;
    if(self.friends.count > 0){
        [self addFriendsTableView];
        self.navigationItem.rightBarButtonItem = self.addfriendBarButton;
    }else{
        [self addImageButton];
        self.navigationItem.rightBarButtonItem = nil;
    }
}

@end
