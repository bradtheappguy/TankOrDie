//
//  PlayerWonViewController.m
//  devcampipad
//
//  Created by Brad Smith on 7/22/12.
//  Copyright (c) 2012 Focal Labs. All rights reserved.
//

#import "PlayerWonViewController.h"

@interface PlayerWonViewController ()

@end

@implementation PlayerWonViewController
@synthesize winnerimageView;
@synthesize loser1ImageView;
@synthesize loser2ImageView;
@synthesize loser3ImageView;
@synthesize winnerLabel;

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
   [[NSNotificationCenter defaultCenter] addObserver:self.view selector:@selector(removeFromSuperview) name:@"GAME_RESET" object:nil];
}

- (void)viewDidUnload
{
  [self setWinnerimageView:nil];
  [self setLoser1ImageView:nil];
  [self setLoser2ImageView:nil];
  [self setLoser3ImageView:nil];
  [self setWinnerLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
  [winnerimageView release];
  [loser1ImageView release];
  [loser2ImageView release];
  [loser3ImageView release];
  [winnerLabel release];
  [super dealloc];
}
@end
