//
//  StartTankViewController.h
//  devcampipad
//
//  Created by Bess Ho on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoViewController.h"
#import "TankPickerController.h"

@interface StartTankViewController : UIViewController <InfoViewControllerDelegate> {
    IBOutlet UIButton *newgameButton;
    IBOutlet UIButton *joinButton;
    IBOutlet UIButton *infoButton;
    
    TankPickerController *tankPickerController; 
}

@property (nonatomic, retain) IBOutlet UIButton *newgameButton;
@property (nonatomic, retain) IBOutlet UIButton *joinButton;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;

- (IBAction) newgameButton:(id) sender;
- (IBAction) joinButton:(id) sender;
- (IBAction) infoButton:(id) sender;

@end
