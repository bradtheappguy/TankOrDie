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
#import "PlayerWonViewController.h"
@implementation TDiPadMenuViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    scoreBoard.hidden = YES;
	wirelessPlayerNameLabel1.text = @"";
	wirelessPlayerNameLabel2.text = @"";
	wirelessPlayerNameLabel3.text = @"";
	wirelessPlayerNameLabel4.text = @"";
  [super viewDidLoad];
	playButton.alpha = 0;
	helpButton.alpha = 0;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidJoin:) name:@"PLAYER_JOINED" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameDidStart:) name:@"GAME_DID_START" object:nil];
  [self updateConnectionScreenUI];
  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerScored:) name:@"PLAYER_SCORED" object:nil];

  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerWon:) name:@"PLAYER_WON" object:nil];
}


-(void) playerWon:(NSNotification *)n {

  
  Player *winner = n.object;
    PlayerWonViewController *wonViewController = [[PlayerWonViewController alloc] init];
    [self.view addSubview:wonViewController.view];
    //wonViewController.winnerimageView.backgroundColor = [UIColor redColor];
    wonViewController.winnerimageView.image = winner.image;
    wonViewController.winnerLabel = [NSString stringWithFormat:@"Player %@ Wins!",winner.playerName];
    wonViewController.view.frame = self.view.frame;
  
  wonViewController.loser1ImageView.image = nil;
  wonViewController.loser2ImageView.image = nil;
  wonViewController.loser3ImageView.image = nil;
  
  
  NSArray *allPlayers = [[GameServer sharedInstance] connectedPeers];
  for (Player *player in allPlayers) {
    if (player == winner) {
      break;
    }
    if (wonViewController.loser1ImageView.image = nil) {
      wonViewController.loser1ImageView.image = player.image;
      break;
    }
    if (wonViewController.loser2ImageView.image = nil) {
      wonViewController.loser2ImageView.image = player.image;
      break;
    }
    if (wonViewController.loser3ImageView.image = nil) {
      wonViewController.loser3ImageView.image = player.image;
      break;
    }
  }
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
  [backgroundImageView release];
  backgroundImageView = nil;
  [scoreBoard release];
  scoreBoard = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
  [backgroundImageView release];
  [scoreBoard release];
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

-(void) gameDidStart:(id)sender {
    scoreBoard.hidden = NO;
  connectionView.alpha = 0;
  backgroundImageView.image = [UIImage imageNamed:@"tanktank_bg-1.png"];
}


-(void) playerScored:(NSNotification *)n {
  Player *player = [n object];
  if (player.score > 10) {
    
  }
}
@end
