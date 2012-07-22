//
//  AppDelegate.h
//  devcampiphone
//
//  Created by Brad Smith on 4/16/10.
//  Copyright Clixtr 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@class StartTankViewController;
@class ControlsViewController;
@class TankPickerController;
@class ConnectingScreenViewController;
@class GameOverViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, GKPeerPickerControllerDelegate, GKSessionDelegate> {
    IBOutlet UIWindow *window;
	GKPeerPickerController *peerPicker;
	GKSession *connection;
	IBOutlet UIButton *searchButton;
	IBOutlet UIButton *fireButton;
	
	NSString *serverPeerID;
	
	NSString *playerName;
	
	IBOutlet UISlider *leftSlider;
	IBOutlet UISlider *rightSlider;
	
	float leftSliderLastValue;
	float rightSliderLastValue;
    
	StartTankViewController *startTankViewController;
	ControlsViewController *controlsViewController;
	TankPickerController *tankPickerController; 
	ConnectingScreenViewController *connectingViewController;
	GameOverViewController *gameOverViewController;
	
	int tank_id;
}

-(IBAction)didClickSearchNetwork:(id)sender;
-(IBAction)didClickFire:(id)server;
-(void)hideStartTank;
-(void)hideTankPicker;
-(void) sendLocalMessageToServer:(NSString *)message;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) GKPeerPickerController *peerPicker;
@property (nonatomic, retain) GKSession *connection;
@property (nonatomic, retain) NSString *serverPeerID;
@property (readwrite) int tank_id;
@property (nonatomic, retain) NSString *playerName;

@end

