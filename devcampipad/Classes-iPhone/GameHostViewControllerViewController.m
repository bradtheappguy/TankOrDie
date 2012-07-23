//
//  GameHostViewControllerViewController.m
//  devcampipad
//
//  Created by Brad Smith on 7/21/12.
//  Copyright (c) 2012 Focal Labs. All rights reserved.
//

#import "GameHostViewControllerViewController.h"
#import "GameServer.h"
#import "Player.h"

@interface GameHostViewControllerViewController ()

@end

@implementation GameHostViewControllerViewController

@synthesize player1ImageView;
@synthesize player2ImageView;
@synthesize player3ImageView;
@synthesize player4ImageView;

@synthesize player1NameLabel;
@synthesize player2NameLabel;
@synthesize player3NameLabel;
@synthesize player4NameLabel;

@synthesize player1Activity;
@synthesize player2Activity;
@synthesize player3Activity;
@synthesize player4Activity;

@synthesize spinner;
@synthesize statusLabel;

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
    
    player1NameLabel.text = @"Waiting...";
    player2NameLabel.text = @"Waiting...";
    player3NameLabel.text = @"Waiting...";
    player4NameLabel.text = @"Waiting...";
    
    NSArray *array = [[GameServer sharedInstance] connectedPeers];
    
    if (array.count > 0) {
        Player *one = [array objectAtIndex:0];
        player1NameLabel.text = one.playerName;
        player1ImageView.image = one.image;
        player1Activity.image = [UIImage imageNamed:@"newgame_light_connect.png"];
        
    }
    
  [self updateConnectionScreenUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConnectionScreenUI) name:@"PLAYER_JOINED" object:nil];	
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateConnectionScreenUI) name:@"GAME_RESET" object:nil];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) updateConnectionScreenUI {
    
    NSLog(@"UPDATE");
    NSArray *array = [[GameServer sharedInstance] connectedPeers];
    
    if (array.count > 0) {
        Player *one = [array objectAtIndex:0];
        player1NameLabel.text = one.playerName;
        player1ImageView.image = one.image;
        player1Activity.image = [UIImage imageNamed:@"newgame_light_connect.png"];
        
    }
    if (array.count > 1) {
        Player *two = [array objectAtIndex:1];
        player2NameLabel.text = two.playerName;
        player2ImageView.image = two.image;
        player2Activity.image = [UIImage imageNamed:@"newgame_light_connect.png"];
        
    }
    if (array.count > 2) {
        Player *three = [array objectAtIndex:2];
        player3NameLabel.text = three.playerName;
        player3ImageView.image = three.image;
        player3Activity.image = [UIImage imageNamed:@"newgame_light_connect.png"];
    }
    
    if (array.count > 3) {
        Player *four = [array objectAtIndex:3];
        player4NameLabel.text = four.playerName;
        player4ImageView.image = four.image;
        player4Activity.image = [UIImage imageNamed:@"newgame_light_connect.png"];
        
    }
}	



- (void)viewDidUnload
{
    [self setPlayer2ImageView:nil];
    [self setPlayer3ImageView:nil];
    [self setPlayer4ImageView:nil];
    [self setPlayer1NameLabel:nil];
    [self setPlayer2NameLabel:nil];
    [self setPlayer3NameLabel:nil];
    [self setPlayer4NameLabel:nil];
    [self setSpinner:nil];
    [self setStatusLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [player2ImageView release];
    [player3ImageView release];
    [player4ImageView release];
    [player1NameLabel release];
    [player2NameLabel release];
    [player3NameLabel release];
    [player4NameLabel release];
    [spinner release];
    [statusLabel release];
    [super dealloc];
}
- (IBAction)startGameButtonPressed:(id)sender {
  [self.view removeFromSuperview];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"GAME_DID_START" object:nil];
}
@end
