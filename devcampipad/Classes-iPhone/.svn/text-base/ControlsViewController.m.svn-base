//
//  ControlsViewController.m
//  devcampiphone
//
//  Created by joshm on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ControlsViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

#define DAMAGE_FACTOR 30

@implementation ControlsViewController

@synthesize leftSlider, rightSlider, soundplayer; 

- (IBAction) fireButtonHit : (id) sender
{
	[soundplayer playFireSound]; 
	AppDelegate *appDelegate;
	appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];	
	[appDelegate didClickFire:sender]; 
}

- (IBAction) leftSliderValueChanged : (id) sender
{
	AppDelegate *appDelegate;
	appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];	
	
}

- (IBAction) rightSliderValueChanged : (id) sender
{
	AppDelegate *appDelegate;
	appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];		
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	soundplayer = [[Sound alloc] init];
	
	//TXSlider *s2 = [TXSlider
	rightSlider.userInteractionEnabled = YES;
	rightSlider.multipleTouchEnabled = YES;
	self.view.userInteractionEnabled = YES;
	[rightSlider superview].userInteractionEnabled = YES;
	
	leftSlider.userInteractionEnabled = YES;
	leftSlider.multipleTouchEnabled = YES;
	self.view.userInteractionEnabled = YES;
	[leftSlider superview].userInteractionEnabled = YES;
}

-(void) connectionEstablished {
	[soundplayer playTrackSound];
}

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

-(void) playerDidTakeDamage {
	AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
	[soundplayer playHitSound]; 
	float newWidth = healthBar.frame.size.width - DAMAGE_FACTOR;
	
	healthBar.frame = CGRectMake(healthBar.frame.origin.x, healthBar.frame.origin.y, newWidth, healthBar.frame.size.height);
	
	if (healthBar.frame.size.width < 5) {
		[self didLose];
	}
	
	
}

-(void) didLose {
	UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Oh Nos!" message:@"Lou Lost" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"I Suck"];
	[a show];
	[a release];
}


@end
