//
//  ConnectingScreenViewController.m
//  devcampipad
//
//  Created by Brad Smith on 5/10/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import "ConnectingScreenViewController.h"


@implementation ConnectingScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void) setNumberOfPlayers:(NSUInteger) numberOfPlayers {
	connectedPlayersCountLabel.text = [NSString stringWithFormat:@"%d",numberOfPlayers];
}


@end
