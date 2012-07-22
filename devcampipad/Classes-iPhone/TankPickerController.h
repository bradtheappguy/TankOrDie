//
//  TankPickerController.h
//  devcampiphone
//
//  Created by joshm on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TankPickerController : UIViewController {
	IBOutlet UIButton *tank1Button;
	IBOutlet UIButton *tank2Button;
	IBOutlet UIButton *tank3Button;
	IBOutlet UIButton *tank4Button;
	IBOutlet UIButton *changeOrSaveButton;
	IBOutlet UIButton *connectButton;
	IBOutlet UIButton *infoButton;
	IBOutlet UIButton *helpButton;
	IBOutlet UITextField *nameTextField;
	IBOutlet UILabel *helloLabel;
    IBOutlet UIButton *addProfileButton; // Add profile image from using camera
	
	id delegate;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) UIButton *addProfileButton;

- (IBAction) chooseTank1;
- (IBAction) chooseTank2;
- (IBAction) chooseTank3;
- (IBAction) chooseTank4;

- (IBAction) changeOrSaveButtonPressed:(id) sender;
- (IBAction) connectButtonPressed:(id) sender;
- (IBAction) infoButtonPressed:(id) sender;
- (IBAction) helpButtonPressed:(id) sender;
- (IBAction) addProfileButton:(id) sender;

- (void) connect:(int)tankID;


@end
