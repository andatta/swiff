//
//  SWInviteFriendController.m
//  Swiff
//
//  Created by Anutosh Datta on 19/07/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWInviteFriendController.h"

@interface SWInviteFriendController ()

@end

@implementation SWInviteFriendController

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
    
    self.title = NSLocalizedString(@"invite_friend_title", nil);
    
    self.options = [NSArray arrayWithObjects:@"SMS", @"Email", nil];
    
    self.optionsList = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 600) style:UITableViewStylePlain];
    self.optionsList.dataSource = self;
    self.optionsList.delegate = self;
    self.optionsList.separatorColor = [UIColor whiteColor];
    [self addHeader];
    [self addFooter];
    [self.view addSubview:self.optionsList];
}

-(void)addHeader{
    CGRect titleRect = CGRectMake(60, 60, 300, 0);
    UILabel *tableTitle = [[UILabel alloc] initWithFrame:titleRect];
    tableTitle.textColor = [UIColor blueColor];
    tableTitle.backgroundColor = [UIColor clearColor];
    tableTitle.opaque = YES;
    tableTitle.font = [UIFont boldSystemFontOfSize:18];
    self.optionsList.tableHeaderView = tableTitle;
}

-(void)addFooter{
    CGRect footer = CGRectMake(0, 0, self.view.frame.size.width, 1);
    UIView* footerView = [[UIView alloc]initWithFrame:footer];
    self.optionsList.tableFooterView = footerView;
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
    return self.options.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableCell"];
    }
    cell.textLabel.text = [self.options objectAtIndex:indexPath.row];
    UIView* separatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 0.5)];
    separatorView.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:separatorView];
    UILabel* accessoryLabel;
    if(indexPath.row == 0){
        accessoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 0, 200, 60)];
        accessoryLabel.text = @"Invite friends via sms";
        cell.imageView.image = [UIImage imageNamed:@"sms.png"];
    }else if (indexPath.row == 1){
        accessoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 0, 200, 60)];
        accessoryLabel.text = @"Invite via email";
        cell.imageView.image = [UIImage imageNamed:@"email.png"];
    }
    accessoryLabel.font = [UIFont systemFontOfSize:13.0f];
    accessoryLabel.textColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:accessoryLabel];
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
