    //
//  TDiPadMenuViewController.m
//  devcampipad
//
//  Created by Brad Smith on 5/13/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import "devcampipadAppDelegate.h"
#import "TDiPadMenuViewController.h"
#import "TankPickerController.h"
#import "Player.h"
#import "GameServer.h"

@implementation TDiPadMenuViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	localPlayerNameLabel1.text = @"";
	localPlayerNameLabel2.text = @"";
	wirelessPlayerNameLabel1.text = @"";
	wirelessPlayerNameLabel2.text = @"";
	wirelessPlayerNameLabel3.text = @"";
	wirelessPlayerNameLabel4.text = @"";
  [super viewDidLoad];
	playButton.alpha = 0;
	helpButton.alpha = 0;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidJoin:) name:@"PLAYER_JOINED" object:nil];
  [self updateConnectionScreenUI];
}




- (void) setButtonsVisible:(BOOL)visible animated:(BOOL)animated {
	[self.view class];
  if (animated) {
		[UIView beginAnimations:@"" context:nil];
		[UIView setAnimationDuration:.33];
	}
	if (visible) {
		playButton.alpha = 1;
		helpButton.alpha = 1;
	}
	else {
		playButton.alpha = 0;
		helpButton.alpha = 0;
	}
	if (animated) {
		[UIView commitAnimations];
	}
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return NO; //return interfaceOrientation==UIInterfaceOrientationLandscapeRight?YES:NO;
}


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

#pragma mark Button Handling Methods
-(IBAction) helpButtonPressed:(id)sender {
	
}

-(IBAction) playButtonPressed:(id)sender {
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConnectionScreenUI) name:@"PLAYER_JOINED" object:nil];																				 
	connectionView.alpha = 1;
}

-(IBAction) startButtonPressed:(id)sender {
	[self.view removeFromSuperview];
	//[self updateConnectionScreenUI];
	id appDel = [[UIApplication sharedApplication] delegate];
	[appDel setLocalControlsHidden:NO animated:YES];
	[appDel setGamePaused: NO];
}

-(IBAction) addLocalPlayButtonPressed:(UIButton *)button {
	if ((button != addLocalPlayerOneButton) && (button != addLocalPlayerTwoButton)){
		NSLog(@"Whoops: Unexpected Sender");
		return;
	}
	button.hidden = YES;
	
		
	if (button == addLocalPlayerOneButton) {
		tankSelectionPlayerOneViewController = [[TankPickerController alloc] initWithNibName:@"TankPickerController" bundle:nil];
		tankSelectionPlayerOneViewController.contentSizeForViewInPopover = CGSizeMake(480, 320);
		tankSelectionPlayerOneViewController.delegate = self;
		
		addPlayerOnePopoverController = [[UIPopoverController alloc] initWithContentViewController:tankSelectionPlayerOneViewController];
		addPlayerOnePopoverController.delegate = self;
		[addPlayerOnePopoverController presentPopoverFromRect:[self.view convertRect:button.bounds fromView:button] 
										   inView:self.view 
						 permittedArrowDirections:UIPopoverArrowDirectionAny 
										 animated:YES];
		
	}
	else if (button == addLocalPlayerTwoButton) {
		tankSelectionPlayerTwoViewController = [[TankPickerController alloc] initWithNibName:@"TankPickerController" bundle:nil];
		tankSelectionPlayerTwoViewController.contentSizeForViewInPopover = CGSizeMake(480, 320);
		tankSelectionPlayerTwoViewController.delegate = self;
		
		addPlayerTwoPopoverController = [[UIPopoverController alloc] initWithContentViewController:tankSelectionPlayerTwoViewController];
		addPlayerTwoPopoverController.delegate = self;
		[addPlayerTwoPopoverController presentPopoverFromRect:[self.view convertRect:button.bounds fromView:button] 
										   inView:self.view 
						 permittedArrowDirections:UIPopoverArrowDirectionAny 
										 animated:YES];
		
	}
	
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	if (popoverController == addPlayerOnePopoverController) {
		addLocalPlayerOneButton.hidden = NO;
	}
	if (popoverController == addPlayerTwoPopoverController) {
		addLocalPlayerTwoButton.hidden = NO;
	}
}



-(void) updateConnectionScreenUI {
  NSArray *array = [[GameServer sharedInstance] connectedPeers];
  
  wirelessPlayerNameLabel1.text = @"Waiting...";
  wirelessPlayerNameLabel2.text = @"Waiting...";
  wirelessPlayerNameLabel3.text = @"Waiting...";
  wirelessPlayerNameLabel4.text = @"Waiting...";
  wirelessStatusLight1.image = [UIImage imageNamed:@"newgame_light_idle.png"];
  wirelessStatusLight2.image = [UIImage imageNamed:@"newgame_light_idle.png"];
  wirelessStatusLight3.image = [UIImage imageNamed:@"newgame_light_idle.png"];
  wirelessStatusLight4.image = [UIImage imageNamed:@"newgame_light_idle.png"];
  wirelessConnectedTankView1.image = [UIImage imageNamed:@"tank_dark.png"];
  wirelessConnectedTankView2.image = [UIImage imageNamed:@"tank_dark.png"];
  wirelessConnectedTankView3.image = [UIImage imageNamed:@"tank_dark.png"];
  wirelessConnectedTankView4.image = [UIImage imageNamed:@"tank_dark.png"];
  
  if (array.count > 0) {
    Player *one = [array objectAtIndex:0];
    wirelessPlayerNameLabel1.text = one.playerName;
    wirelessConnectedTankView1.image = one.image;
    wirelessStatusLight1.image = [UIImage imageNamed:@"newgame_light_connect.png"];
    
  }
  if (array.count > 1) {
    Player *two = [array objectAtIndex:1];
    wirelessPlayerNameLabel2.text = two.playerName;
    wirelessConnectedTankView2.image = two.image;
    wirelessStatusLight2.image = [UIImage imageNamed:@"newgame_light_connect.png"];
    
  }
  if (array.count > 2) {
    Player *three = [array objectAtIndex:2];
    wirelessPlayerNameLabel3.text = three.playerName;
    wirelessConnectedTankView3.image = three.image;
    wirelessStatusLight3.image = [UIImage imageNamed:@"newgame_light_connect.png"];
  }
  
  if (array.count > 3) {
    Player *four = [array objectAtIndex:3];
    wirelessPlayerNameLabel4.text = four.playerName;
    wirelessConnectedTankView4.image = four.image;
    wirelessStatusLight4.image = [UIImage imageNamed:@"newgame_light_connect.png"];
    
  }
}	


-(void)playerDidJoin:(id)sender {
  [self updateConnectionScreenUI];
}

@end
