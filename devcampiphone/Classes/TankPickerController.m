//
//  TankPickerController.m
//  devcampiphone
//
//  Created by joshm on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TankPickerController.h"
#import "devcampiphoneAppDelegate.h"

@implementation TankPickerController

- (IBAction) chooseTank1
{
	[self connect:1];
}

- (IBAction) chooseTank2
{
	[self connect:2];	
}

- (IBAction) chooseTank3
{
	[self connect:3];
}

- (IBAction) chooseTank4
{
	[self connect:4];
}

- (IBAction) chooseTank5
{
	[self connect:5];
}

- (IBAction) chooseTank6
{
	[self connect:6];
}

- (IBAction) chooseTank7
{
	[self connect:7];
}

- (IBAction) chooseTank8
{
	[self connect:8];
}

- (void) connect:(int)tankID
{
	devcampiphoneAppDelegate *appDelegate = (devcampiphoneAppDelegate *)[[UIApplication sharedApplication] delegate];	
	appDelegate.tank_id = tankID;
	[appDelegate didClickSearchNetwork:nil]; 
	[appDelegate hideTankPicker]; 
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}



@end
