//
//  devcampiphoneAppDelegate.h
//  devcampiphone
//
//  Created by Brad Smith on 4/16/10.
//  Copyright Clixtr 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
@class ControlsViewController;
@class TankPickerController;

@interface devcampiphoneAppDelegate : NSObject <UIApplicationDelegate, GKPeerPickerControllerDelegate, GKSessionDelegate> {
    UIWindow *window;
	GKPeerPickerController *peerPicker;
	GKSession *connection;
	IBOutlet UIButton *searchButton;
	IBOutlet UIButton *fireButton;

	NSString *serverPeerID;
	
	IBOutlet UISlider *leftSlider;
	IBOutlet UISlider *rightSlider;
	
	float leftSliderLastValue;
	float rightSliderLastValue;
	
	ControlsViewController *controlsViewController;
	TankPickerController *tankPickerController; 
	
	int tank_id;
}


-(IBAction)didClickSearchNetwork:(id)sender;
-(IBAction)didClickFire:(id)server;
-(void)hideTankPicker;


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) GKPeerPickerController *peerPicker;
@property (nonatomic, retain) GKSession *connection;
@property (nonatomic, retain) NSString *serverPeerID;
@property (readwrite) int tank_id;

@end

