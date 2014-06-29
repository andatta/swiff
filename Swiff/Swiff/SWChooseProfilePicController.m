//
//  SWChooseProfilePicController.m
//  Swiff
//
//  Created by Anutosh Datta on 28/06/14.
//  Copyright (c) 2014 TechHouse. All rights reserved.
//

#import "SWChooseProfilePicController.h"

@interface SWChooseProfilePicController ()

@end

@implementation SWChooseProfilePicController

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)uploadExisting:(id)sender {
    UIImagePickerController* mediaUI = [[UIImagePickerController alloc]init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:nil];
}

- (IBAction)takeNewPhoto:(id)sender {
    UIImagePickerController* cameraUI = [[UIImagePickerController alloc]init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
    [self presentViewController:cameraUI animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
   
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage* image = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    SWNetworkCommunicator* comm = [[SWNetworkCommunicator alloc]init];
    self.uploadPicController = [self.storyboard instantiateViewControllerWithIdentifier:@"uploadPicController"];
    self.uploadPicController.image = image;
    [self.navigationController pushViewController:self.uploadPicController animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
   [self dismissViewControllerAnimated:YES completion:nil];
}
@end
