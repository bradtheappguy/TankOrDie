//
//  GameHostViewControllerViewController.m
//  devcampipad
//
//  Created by Brad Smith on 7/21/12.
//  Copyright (c) 2012 Focal Labs. All rights reserved.
//

#import "GameHostViewControllerViewController.h"

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
