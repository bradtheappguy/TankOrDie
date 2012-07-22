//
//  GameServer.h
//  devcampipad
//
//  Created by Brad Smith on 7/21/12.
//  Copyright (c) 2012 Focal Labs. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "Sound.h"
#import "TDiPadControllerView.h"
#import "LocalTankViewController.h"

@class Player;
@class Bullet;
@class TouchController;
@class TDiPadMenuViewController;

@interface GameServer : NSObject <UIApplicationDelegate, GKSessionDelegate> {
	IBOutlet UILabel *peerCountLabel;
	IBOutlet UILabel *boardCountLabel;
	IBOutlet UIButton *newButton;
	IBOutlet UIButton *stopButton;
	
	UIImageView *defaultView;
	UIImageView *loadingView;
	NSString *serverPeerID;
	GKPeerPickerController *peerPicker;
	NSMutableArray *connectedPeers;
	UIWindow *window;
	
	GKSession *service;
	GKSession *client;
	
	NSMutableArray *bullets;
	NSDate *lastTicked;
	BOOL actingAsServer;
	
	Sound *soundPlayer;
	TouchController *touchController;
	TDiPadMenuViewController *menuViewContoller;
	
	TDiPadControllerView *leftControllerViewController;
	TDiPadControllerView *rightControllerViewController;
	
	BOOL gamePaused;
	
	LocalTankViewController *localPlayer1ControlsViewController;
	LocalTankViewController *localPlayer2ControlsViewController;
	
}


-(IBAction)joinButtonPressed:(id)sender;
-(void)requestConnectingClientIdentity:(NSString *)thePeerId;
-(void)confirmiPad:(NSString *)peerId;
-(void)spawnPortal:(NSString *)args;
-(void)updateLabels;
-(void)confirmiPhone:(NSString *)peerID withTankID:(NSString *)tankID;
-(void)spawnPlayer:(NSString *)args;
-(void)sendID:(NSString *)serverPeerID;
-(void)player:(Player *)player didFireBullet:(NSString *)bulletType;
-(void) removeLoadingView;
-(void)setLocalControlsHidden:(BOOL)a animated:(BOOL)b;
-(void)screenDidConnect:(NSNotification *)notification;
+ (id)sharedInstance;

@property (atomic, retain) NSMutableArray *connectedPeers;

@property (nonatomic, retain) NSString *serverPeerID;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) GKSession *service;
@property (nonatomic, retain) GKSession *client;

@property (nonatomic, retain) NSMutableArray *bullets;
@property (nonatomic, retain) NSDate *lastTicked;

@property (nonatomic, retain) Sound *soundPlayer;
@property (nonatomic, retain) TouchController *touchController;
@property (readwrite) BOOL gamePaused;
@property (readwrite) BOOL actingAsServer;
@end
