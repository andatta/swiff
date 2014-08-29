//
//  SWUserDetailController.m
//  Swiff
//
//  Created by Anutosh Datta on 09/08/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWUserDetailController.h"

#import "ImageLoader.h"
#import "QRGenerator.h"
#import "ImageLoader.h"
#import "SWReviewDetailController.h"

@interface SWUserDetailController ()

@end

@implementation SWUserDetailController

int REQUEST_SYNC_CHECKIN = 1;
int REQUEST_SYNC_REVIEW = 2;

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 20.0f

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
    if(self.friendObject != nil){
        self.title = [NSString stringWithFormat:@"%@ %@", self.friendObject.first_name, self.friendObject.last_name];
        self.userProfileImage.image = [self getProfileImage];
        self.userProfileImage.transform = CGAffineTransformMakeRotation(M_PI/2);
        self.userStatus.text = [self.friendObject.status isEqualToString:@""] ? @"Joined Cawver" : self.friendObject.status;
        UITapGestureRecognizer* zoomInTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomInOutUserPhoto)];
        zoomInTap.numberOfTapsRequired = 1;
        [self.userProfileImage setUserInteractionEnabled:YES];
        [self.userProfileImage addGestureRecognizer:zoomInTap];
        self.zoomedIn = NO;
    }
    [self.activityIndicator startAnimating];
    self.checkIns = [[NSMutableArray alloc]init];
    self.reviews = [[NSMutableArray alloc]init];
    [self.segments addTarget:self action:@selector(changeTabs) forControlEvents:UIControlEventValueChanged];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(syncUserCheckInsAndReviews) userInfo:nil repeats:NO];
    [self createCheckInTable];
    [self createReviewTable];
    self.noRecordsLabel.numberOfLines = 0;
    self.noRecordsLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)zoomInOutUserPhoto{
    if(!self.zoomedIn){
        self.view.backgroundColor = [UIColor blackColor];
        self.segments.hidden = YES;
        self.userStatus.hidden = YES;
        [self.checkInView setFrame:CGRectZero];
        [self.reviewTableView setFrame:CGRectZero];
        self.noRecordsLabel.hidden = YES;
        [UIView animateWithDuration:1.0 animations:^(void){
            [self.userProfileImage setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 80)];
        }];
        self.zoomedIn = YES;
    }else{
        [UIView animateWithDuration:1.0 animations:^(void){
            [self.userProfileImage setFrame:CGRectMake(11, 11, 100, 100)];
        }completion:^(BOOL finished) {
            self.segments.hidden = NO;
            self.userStatus.hidden = NO;
            self.view.backgroundColor = [UIColor whiteColor];
            [self.checkInView setFrame:CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height)];
            [self.reviewTableView setFrame:CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height)];
            if(!self.checkInSyncInProgress && self.checkIns.count == 0){
                self.noRecordsLabel.hidden = NO;
            }
            if(!self.reviewSyncInProgress && self.reviews.count == 0){
                self.noRecordsLabel.hidden = NO;
            }
        }];
        self.zoomedIn = NO;
    }
}

-(UIImage*)getProfileImage{
    UIImage* _profileImage;
    _profileImage = [[ImageLoader instance]getImageForPath:self.friendObject.profileImage completionHandler:^(UIImage * image) {
        
    }];
    if(_profileImage == nil){
        _profileImage = [QRGenerator generateQRCodeForString:self.friendObject.customerId];
    }
    return _profileImage;
}

-(void)syncUserCheckInsAndReviews{
    self.checkInSyncInProgress = YES;
    self.reviewSyncInProgress = YES;
    
    SWNetworkCommunicator* comm = [[SWNetworkCommunicator alloc]init];
    comm.delegate = self;
    [comm getUserCheckIns:self.friendObject.customerId completionHandler:^(NSData *data, NSError *error) {
        if(error == NULL){
            NSLog(@"sync completed: %@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            SWUserCheckIn* userCheckIn = [[SWUserCheckIn alloc]init];
            NSArray* objectArray = [JsonSerializer jsonarrayToObjects:data oobjectFatcory:userCheckIn];
            for (id object in objectArray) {
                SWUserCheckIn* retreivedCheckIn = (SWUserCheckIn*)object;
                [self.checkIns addObject:retreivedCheckIn];
            }
            self.checkInSyncInProgress = NO;
            [self changeTabs];
        }else {
            NSLog(@"sync checkin falied with error: %@", error.description);
            self.checkInSyncInProgress = NO;
        }
    }];
    [self syncReviews];
}

-(void)requestComletedWithData:(NSData*)data{
    NSLog(@"sync completed: %@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    if(self.currentRequest == REQUEST_SYNC_CHECKIN){
        SWUserCheckIn* userCheckIn = [[SWUserCheckIn alloc]init];
        NSArray* objectArray = [JsonSerializer jsonarrayToObjects:data oobjectFatcory:userCheckIn];
        for (id object in objectArray) {
            SWUserCheckIn* retreivedCheckIn = (SWUserCheckIn*)object;
            [self.checkIns addObject:retreivedCheckIn];
        }
        self.checkInSyncInProgress = NO;
        [self syncReviews];
        
    }else if (self.currentRequest == REQUEST_SYNC_REVIEW){
        SWUserReview* userReview = [[SWUserReview alloc]init];
        NSArray* objectArray = [JsonSerializer jsonarrayToObjects:data oobjectFatcory:userReview];
        for (id object in objectArray) {
            SWUserReview* retreivedReview = (SWUserReview*)object;
            [self.reviews addObject:retreivedReview];
        }
        self.reviewSyncInProgress = NO;
    }
    [self changeTabs];
}
-(void)requestFailedWithError:(NSError*)error{
    NSLog(@"sync friend falied with error: %@", error.description);
    if(self.currentRequest == REQUEST_SYNC_CHECKIN){
        self.checkInSyncInProgress = NO;
        [self syncReviews];
        
    }else if (self.currentRequest == REQUEST_SYNC_REVIEW){
        self.reviewSyncInProgress = NO;
    }
    [self changeTabs];

}

-(void)syncReviews{
    SWNetworkCommunicator* comm = [[SWNetworkCommunicator alloc]init];
    comm.delegate = self;
    [comm getUserReviews:self.friendObject.customerId completionHandler:^(NSData * data, NSError * error) {
        if (error == NULL) {
            NSLog(@"sync completed: %@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            SWUserReview* userReview = [[SWUserReview alloc]init];
            NSArray* objectArray = [JsonSerializer jsonarrayToObjects:data oobjectFatcory:userReview];
            for (id object in objectArray) {
                SWUserReview* retreivedReview = (SWUserReview*)object;
                [self.reviews addObject:retreivedReview];
            }
            self.reviewSyncInProgress = NO;
            [self changeTabs];
        } else {
            NSLog(@"sync reviews falied with error: %@", error.description);
            self.reviewSyncInProgress = NO;
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.checkInView){
        return self.checkIns.count;
    }else if(tableView == self.reviewTableView){
        return self.reviews.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.checkInView){
        SWUserCheckIn* userCheckIn = (SWUserCheckIn*)[self.checkIns objectAtIndex:indexPath.row];
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"checkInCell"];
        UILabel* titleLabel = nil;
        UIImageView* outletLogoImage = nil;
        UILabel* dateLabel = nil;
        if(cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"checkInCell"];
            outletLogoImage = [[UIImageView alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN, 5, 50, 50)];
            [outletLogoImage setTag:3];
            [cell.contentView addSubview:outletLogoImage];
            
            titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN + 60, 5, CELL_CONTENT_WIDTH - 100, 50)];
            [titleLabel setTag:2];
            [cell.contentView addSubview:titleLabel];
            
            dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN + 60, 20, CELL_CONTENT_WIDTH - 100, 50)];
            [dateLabel setTag:4];
            dateLabel.textColor = [UIColor lightGrayColor];
            dateLabel.font = [UIFont systemFontOfSize:14.0f];
            [cell.contentView addSubview:dateLabel];
        }
        if(!outletLogoImage){
            outletLogoImage = (UIImageView*)[cell viewWithTag:3];
        }
        outletLogoImage.image = [[ImageLoader instance]getImageForPath:userCheckIn.outletLogo completionHandler:^(UIImage * image) {
            outletLogoImage.image = image;
        }];
        if(!titleLabel){
            titleLabel = (UILabel*)[cell viewWithTag:2];
        }
        titleLabel.text = userCheckIn.outletName;
        if(!dateLabel){
            dateLabel = (UILabel*)[cell viewWithTag:4];
        }
        dateLabel.text = [self formatDate:userCheckIn.checkInDate];
        return cell;
    }else if(tableView == self.reviewTableView){
        SWUserReview* userReview = (SWUserReview*)[self.reviews objectAtIndex:indexPath.row];
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"reviewCell"];
        UILabel *label = nil;
        UILabel* titleLabel = nil;
        UIImageView* outletLogoImage = nil;
        UILabel* dateLabel = nil;
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Cell"];
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label = [[UILabel alloc] initWithFrame:CGRectZero];
            //[label setMinimumFontSize:FONT_SIZE];
            [label setNumberOfLines:0];
            [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            [label setTag:1];
            label.textColor = [UIColor grayColor];
            [[cell contentView] addSubview:label];
            
            outletLogoImage = [[UIImageView alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN, 5, 50, 50)];
            [outletLogoImage setTag:3];
            [cell.contentView addSubview:outletLogoImage];
            
            titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN + 60, 5, CELL_CONTENT_WIDTH - 100, 50)];
            [titleLabel setTag:2];
            [cell.contentView addSubview:titleLabel];
            
            dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN + 60, 20, CELL_CONTENT_WIDTH - 100, 50)];
            [dateLabel setTag:4];
            dateLabel.textColor = [UIColor lightGrayColor];
            dateLabel.font = [UIFont systemFontOfSize:14.0f];
            [cell.contentView addSubview:dateLabel];
            
        }
        
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        NSString* review = [self getReviewToDisplay:userReview.review];
        CGSize size = [review sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        if(!outletLogoImage){
            outletLogoImage = (UIImageView*)[cell viewWithTag:3];
        }
        outletLogoImage.image = [[ImageLoader instance]getImageForPath:userReview.outletLogo completionHandler:^(UIImage * image) {
            outletLogoImage.image = image;
        }];
        if(!titleLabel){
            titleLabel = (UILabel*)[cell viewWithTag:2];
        }
        titleLabel.text = userReview.outletName;
        if(!dateLabel){
            dateLabel = (UILabel*)[cell viewWithTag:4];
        }
        dateLabel.text = [self formatDate:userReview.reviewDate];
        if (!label)
            label = (UILabel*)[cell viewWithTag:1];
        
        [label setText:review];
        [label setFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN + 45, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.height + 25, 44.0f))];
        if(userReview.review.length > 200){
            //need to add more button
            UIButton* moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
            moreButton.frame = CGRectMake(120, size.height + 90, 40, 20);
            [moreButton setTitle:@"More" forState:UIControlStateNormal];
            moreButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
            [moreButton addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
            [moreButton setTag:indexPath.row];
            [cell.contentView addSubview:moreButton];
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.reviewTableView){
        SWUserReview* userReview = (SWUserReview*)[self.reviews objectAtIndex:indexPath.row];
        NSString* review = [self getReviewToDisplay:userReview.review];
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        
        CGSize size = [review sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat height;
        if(userReview.review.length > 200){
           height = MAX(size.height + 55, 44.0f);
        }else{
            height = MAX(size.height + 25, 44.0f);
        }
        
        return height + (CELL_CONTENT_MARGIN * 2) + 40;
    }else{
        return 80;
    }
}

-(void)showCheckInTable{
    if(self.checkInView != nil){
        self.checkInView.hidden = NO;
        [self.view addSubview:self.checkInView];
        [self. checkInView reloadData];
        self.activityIndicator.hidden = YES;
    }
    
}

-(void)hideCheckInTable{
    if(!self.checkInView.hidden){
        self.checkInView.hidden = YES;
        [self.checkInView removeFromSuperview];
    }
}

-(void)showReviewTable{
    if(self.reviewTableView != nil){
        self.reviewTableView.hidden = NO;
        [self.view addSubview:self.reviewTableView];
        [self. reviewTableView reloadData];
        self.activityIndicator.hidden = YES;
    }
    
}

-(void)hideReviewTable{
    if(!self.reviewTableView.hidden){
        self.reviewTableView.hidden = YES;
        [self.reviewTableView removeFromSuperview];
    }
}

-(void)changeTabs{
    NSLog(@"change tabs");
    if(self.segments.selectedSegmentIndex == 0){
        [self hideReviewTable];
        if(!self.checkInSyncInProgress && self.checkIns.count > 0){
            self.activityIndicator.hidden = YES;
            [self.noRecordsLabel setHidden:YES];
            [self.segments setTitle:[NSString stringWithFormat:@"%d Check-Ins", self.checkIns.count] forSegmentAtIndex:0];
            [self showCheckInTable];
        }
        if(!self.checkInSyncInProgress && self.checkIns.count == 0){
            self.activityIndicator.hidden = YES;
            [self.noRecordsLabel setHidden:NO];
            [self.segments setTitle:[NSString stringWithFormat:@"No Check-Ins"] forSegmentAtIndex:0];
            self.noRecordsLabel.text = @"There are no check-ins by this user";
            [self.noRecordsLabel sizeToFit];
        }
    }else if(self.segments.selectedSegmentIndex == 1){
        [self hideCheckInTable];
        if(!self.reviewSyncInProgress && self.reviews.count > 0){
            self.activityIndicator.hidden = YES;
            [self.noRecordsLabel setHidden:YES];
            [self.segments setTitle:[NSString stringWithFormat:@"%d Reviews", self.reviews.count] forSegmentAtIndex:1];
            [self showReviewTable];
        }
        if(!self.reviewSyncInProgress && self.reviews.count == 0){
            self.activityIndicator.hidden = YES;
            [self.noRecordsLabel setHidden:NO];
            [self.segments setTitle:[NSString stringWithFormat:@"No Reviews"] forSegmentAtIndex:1];
            self.noRecordsLabel.text = @"There are no reviews by this user";
            [self.noRecordsLabel sizeToFit];
        }
    }
}

-(void)createCheckInTable{
    self.checkInView = [[UITableView alloc]initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height)];
    self.checkInView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.checkInView.dataSource = self;
    self.checkInView.delegate = self;
    CGRect footer = CGRectMake(0, 0, self.view.frame.size.width, 300);
    UIView* footerView = [[UIView alloc]initWithFrame:footer];
    self.checkInView.tableFooterView = footerView;
}

-(void)createReviewTable{
    self.reviewTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height)];
    self.reviewTableView.dataSource = self;
    self.reviewTableView.delegate = self;
    CGRect footer = CGRectMake(0, 0, self.view.frame.size.width, 300);
    UIView* footerView = [[UIView alloc]initWithFrame:footer];
    self.reviewTableView.tableFooterView = footerView;
}

-(NSString*)getReviewToDisplay:(NSString*)inString{
    if(inString.length > 200){
       return [NSString stringWithFormat:@"%@...", [inString substringToIndex:200]];
    }
    return inString;
}

-(NSString*)formatDate:(NSString*)indateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:indateString];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    return [dateFormatter stringFromDate:date];
}

-(void)showMore:(id)sender{
    UIButton* button = (UIButton*)sender;
    int tag = [button tag];
    NSLog(@"show more for row: %d", tag);
    SWReviewDetailController* reviewDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"reviewDetailController"];
    SWUserReview* userReview = (SWUserReview*)[self.reviews objectAtIndex:tag];
    reviewDetail.userReview = userReview;
    [self.navigationController pushViewController:reviewDetail animated:YES];
}

//image loader listener
-(void)imageDownloaded:(UIImage*)image{
    if(!self.checkInView.hidden){
        [self.checkInView reloadData];
    }else if(!self.reviewTableView.hidden){
        [self.reviewTableView reloadData];
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
