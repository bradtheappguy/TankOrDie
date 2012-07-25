//
//  TDiPadMenuViewController.h
//  devcampipad
//
//  Created by Brad Smith on 5/13/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TDiPadMenuViewController : UIViewController {
	IBOutlet UIButton *playButton;
	IBOutlet UIButton *helpButton;
	IBOutlet UIView *startButton;	
	
	IBOutlet UIView *connectionView;	
	
	IBOutlet UIImageView *localConnectedTankView1;
	IBOutlet UIImageView *localConnectedTankView2;
	
	IBOutlet UIImageView *wirelessConnectedTankView1;
	IBOutlet UIImageView *wirelessConnectedTankView2;
	IBOutlet UIImageView *wirelessConnectedTankView3;
	IBOutlet UIImageView *wirelessConnectedTankView4;
	
	IBOutlet UIImageView *localStatusLight1;
	IBOutlet UIImageView *localStatusLight2;
	IBOutlet UIImageView *wirelessStatusLight1;
	IBOutlet UIImageView *wirelessStatusLight2;
	IBOutlet UIImageView *wirelessStatusLight3;
	IBOutlet UIImageView *wirelessStatusLight4;
	
	IBOutlet UILabel *localPlayerNameLabel1;
	IBOutlet UILabel *localPlayerNameLabel2;
	IBOutlet UILabel *wirelessPlayerNameLabel1;
	IBOutlet UILabel *wirelessPlayerNameLabel2;
	IBOutlet UILabel *wirelessPlayerNameLabel3;
	IBOutlet UILabel *wirelessPlayerNameLabel4;
	
	
	
}

-(IBAction) helpButtonPressed:(id)sender;
-(IBAction) startButtonPressed:(id)sender;
-(IBAction) playButtonPressed:(id)sender;

- (void) setButtonsVisible:(BOOL)visible animated:(BOOL)animated;

-(void) updateConnectionScreenUI;
@end
