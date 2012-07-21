//
//  ControlsViewController.h
//  devcampiphone
//
//  Created by joshm on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TKThumbSlider.h"
#import "TXSlider.h"	
#import "Sound.h"

@interface ControlsViewController : UIViewController {
	IBOutlet UIButton* fireButton;
	IBOutlet TXSlider* leftSlider;
	IBOutlet TXSlider* rightSlider;
	Sound* soundplayer; 
	IBOutlet UIImageView *healthBar;
}

@property (nonatomic, retain) Sound* soundplayer; 
@property (nonatomic, retain) IBOutlet TXSlider* leftSlider;
@property (nonatomic, retain) IBOutlet TXSlider* rightSlider;

- (IBAction) fireButtonHit : (id) sender;
- (IBAction) leftSliderValueChanged : (id) sender;
- (IBAction) rightSliderValueChanged : (id) sender; 
-(void) didLose;
-(void) playerDidTakeDamage;
-(void) connectionEstablished;


@end