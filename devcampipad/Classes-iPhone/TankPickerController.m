//
//  TankPickerController.m
//  devcampiphone
//
//  Created by joshm on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#define ALERT() UIAlertView *a=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Alert" delegate:nil cancelButtonTitle:@"K" otherButtonTitles:nil]; [a show]; [a release];

#define kPlayerNAmeUSerDefault @"PLAYER_NAME_USER_DEFAULT"

#import "TDiPadMenuViewController.h"
#import "TankPickerController.h"
#import "AppDelegate.h"
#import "../UIImage-Categories/UIImage+Resize.h"

@implementation TankPickerController

@synthesize delegate;
@synthesize addProfileButton;

- (IBAction) chooseTank1 {
	[self connect:1];
}

- (IBAction) chooseTank2 {
	[self connect:2];	
}

- (IBAction) chooseTank3 {
	[self connect:3];
}

- (IBAction) chooseTank4 {
	[self connect:4];
}

- (IBAction) changeOrSaveButtonPressed:(id) sender {
	[nameTextField resignFirstResponder];
}
- (IBAction) connectButtonPressed:(id) sender {
	ALERT();
}
- (IBAction) infoButtonPressed:(id) sender {
	ALERT();
}
- (IBAction) helpButtonPressed:(id) sender {
	ALERT();
}


- (void) connect:(int)tankID
{
	if (delegate) {
      //This is called if I am running as a server
		[delegate tankPickerController:self didFinishPickingTankID:tankID withPlayerName:nameTextField.text];
	}
	else {
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];	
		appDelegate.tank_id = tankID;
		[appDelegate didClickSearchNetwork:nil]; 
		[appDelegate hideTankPicker]; 
	}
}

- (void)didReceiveMemoryWarning {
#pragma warning TODO	
// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

-(void) viewDidLoad {
	tank1Button.enabled = NO;	
	tank2Button.enabled = NO;	
	tank3Button.enabled = NO;	
	tank4Button.enabled = NO;	
	connectButton.enabled = NO;
	nameTextField.text  = [[NSUserDefaults standardUserDefaults] objectForKey:kPlayerNAmeUSerDefault];
}

- (void)viewDidUnload {
#pragma warning TODO	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
	tank1Button.enabled = YES;	
	tank2Button.enabled = YES;	
	tank3Button.enabled = YES;	
	tank4Button.enabled = YES;
	
	if (!delegate) {
		AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];	
		[[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:kPlayerNAmeUSerDefault];
		[appDelegate setPlayerName:textField.text];
	}
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self changeOrSaveButtonPressed:nil];
	return YES;
}

- (IBAction) addProfileButton:(id) sender
{
    @try
    {
        // Make happy face camera thing go now:
        UIImagePickerController *faceGrabber = [[[UIImagePickerController alloc] init] autorelease];
        // Future revisions might let people choose from the camera roll... but not today:
        faceGrabber.sourceType = UIImagePickerControllerSourceTypeCamera;
        faceGrabber.delegate = self;
        faceGrabber.allowsEditing = YES;
        // FIXME: DOES NOT verify device actually has a front camera:
        faceGrabber.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        // Absolutely, positively, only supports portrait mode, even though controls rotate
        // to landscape once displayed:
        [self presentModalViewController:faceGrabber animated:YES];
    }
    @catch (NSException *exception)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Camera Please!" message:@"No photo-maker on this device, sorry!" delegate:self cancelButtonTitle:@"Fantastic!" otherButtonTitles:nil];
        NSLog(@"%@", [[exception name] stringByAppendingString:[exception reason]]);
        [alert show];
        [alert release];
    } 
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // [[addProfileButton imageView] setContentMode:UIViewContentModeCenter];
    [addProfileButton setImage:[[info objectForKey:(UIImagePickerControllerEditedImage)] resizedImage:CGSizeMake(100,100) interpolationQuality:kCGInterpolationHigh] forState:(UIControlStateNormal)];
    [picker dismissModalViewControllerAnimated:(YES)];
    if (self.interfaceOrientation != UIInterfaceOrientationPortrait) {
        [[UIDevice currentDevice] performSelector:NSSelectorFromString(@"setOrientation:") withObject:(id)UIInterfaceOrientationLandscapeRight];
    }
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:(YES)];
    if (self.interfaceOrientation != UIInterfaceOrientationPortrait) {
        [[UIDevice currentDevice] performSelector:NSSelectorFromString(@"setOrientation:") withObject:(id)UIInterfaceOrientationLandscapeRight];
    }
}

@end
