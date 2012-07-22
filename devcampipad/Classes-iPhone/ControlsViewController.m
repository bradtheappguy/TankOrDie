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

@synthesize leftSlider, rightSlider, soundplayer, tapRecognizer; 

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
    
    UIGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self.view addGestureRecognizer:tgr];
    
}

-(void) connectionEstablished {
	[soundplayer playTrackSound];
}

-(void) stopSound {
  [soundplayer stopTrackSound];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // Disallow recognition of tap gestures in the segmented control.
    if (((touch.view == self.leftSlider) || (touch.view == self.rightSlider)) && (gestureRecognizer == self.tapRecognizer)) {
        return NO;
    }
    return YES;
}

/*
 In response to a tap gesture, show the image view appropriately then make it fade out in place.
 */
- (IBAction)handleTapFrom:(UITapGestureRecognizer *)recognizer {
	NSLog(@"TAPPED");
//	[soundplayer playFireSound]; 
	AppDelegate *appDelegate;
	appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];	
	[appDelegate didClickFire:nil]; 
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
	self.tapRecognizer = nil;
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
	//UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Oh Nos!" message:@"Lou Lost" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"I Suck"];
	//[a show];
	//[a release];
}

@end
