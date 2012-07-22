//
//  StartTankViewController.m
//  devcampipad
//
//  Created by Bess Ho on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StartTankViewController.h"

@interface StartTankViewController ()

@end

@implementation StartTankViewController

@synthesize newgameButton, joinButton, infoButton;

- (IBAction) newgameButton:(id)sender
{
    
}

- (IBAction) joinButton: (id) sender
{
    [self.view removeFromSuperview]; 
}

- (void)InfoViewControllerDidFinish:(InfoViewController *)controller {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)infoButton:(id)sender
{
	InfoViewController *controller = [[InfoViewController alloc] initWithNibName:@"InfoViewController" bundle:nil];
	controller.delegate = self;
	controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:controller animated:YES];
	[controller release];   
}

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
