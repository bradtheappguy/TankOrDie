//
//  GameOverViewController.h
//  devcampipad
//
//  Created by Brad Smith on 5/10/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GameOverViewController : UIViewController {
	IBOutlet UIImageView *player1ImageView;
	IBOutlet UIImageView *player2ImageView;
	IBOutlet UIImageView *player3ImageView;
	IBOutlet UIImageView *player4ImageView;
	
	IBOutlet UILabel *player1NameLabel;
	IBOutlet UILabel *player2NameLabel;
	IBOutlet UILabel *player3NameLabel;
	IBOutlet UILabel *player4NameLabel;
	
	IBOutlet UILabel *player1KillsCount;
	IBOutlet UILabel *player2KillsCount;
	IBOutlet UILabel *player3KillsCount;
	IBOutlet UILabel *player4KillsCount;
}


-(IBAction) quitButtonPressed:(id) sender;
-(IBAction) playAgainButtonPressed:(id) sender;

@end
