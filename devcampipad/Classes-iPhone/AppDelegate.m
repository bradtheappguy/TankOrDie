//
//  AppDelegate.m
//  devcampiphone
//
//  Created by Brad Smith on 4/16/10.
//  Copyright Clixtr 2010. All rights reserved.
//


#define kAccelerometerFrequency        10 //Hz
#define kFilteringFactor 0.1

#import "AppDelegate.h"
#import "ControlsViewController.h"
#import "GameOverViewController.h"
#import "TDiPadMenuViewController.h"
#import "TankPickerController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import "GameServer.h"
#import "GameHostViewControllerViewController.h"

@implementation AppDelegate

@synthesize window;
@synthesize peerPicker;
@synthesize connection;
@synthesize serverPeerID;
@synthesize tank_id;
@synthesize playerName;


-(void)screenDidConnect:(UIScreen *)screen {
  NSArray *availableModes = [screen availableModes];
  __block UIScreenMode *highestWidthMode = NULL;
  
  [screen.availableModes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    UIScreenMode *currentModeInLoop = obj;
    if (!highestWidthMode || currentModeInLoop.size.width > highestWidthMode.size.width)
      highestWidthMode = currentModeInLoop;
  }];
  
    // setting to the highest resolution available
  screen.currentMode = highestWidthMode;
  
  UIWindow *extWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, highestWidthMode.size.width, highestWidthMode.size.height)];
  extWindow.backgroundColor = [UIColor redColor];


  
  extWindow.screen = screen; 
  extWindow.hidden = NO;
  
    TDiPadMenuViewController *menuViewContoller = [[TDiPadMenuViewController alloc] initWithNibName:@"TDiPadMenuViewController" bundle:nil];
    //UIViewController *menuViewContoller = [[UIViewController alloc] init];
  [menuViewContoller setButtonsVisible:YES animated:YES];
	menuViewContoller.view.backgroundColor = [UIColor purpleColor];
  menuViewContoller.view.frame = CGRectMake(0, 0, extWindow.bounds.size.width, extWindow.bounds.size.height);
  
  [extWindow addSubview:menuViewContoller.view];
  
  [[GameServer sharedInstance] setWindow:extWindow];
  [[GameServer sharedInstance] startServer];
  
    //The delegate is only set when we are running server
  tankPickerController.delegate = self;
  
  NSLog(@"%@",availableModes);
}



  //This is called for the person acting as server only
- (void)tankPickerController:(TankPickerController *)controller didFinishPickingTankID:(int)tankID withPlayerName:(NSString *)name {
	[self sendLocalMessageToServer:@"confirmiPhone|1|testname"];
  [tankPickerController.view removeFromSuperview];
  GameHostViewControllerViewController *hostViewControleer = [[GameHostViewControllerViewController alloc] initWithNibName:nil bundle:nil];
  hostViewControleer.view.transform =CGAffineTransformMakeRotation( .5 * M_PI );
  hostViewControleer.view.center = CGPointMake(160, 240);
  [self.window addSubview:hostViewControleer.view];
}


-(void)screenDidConnectNotification:(NSNotification *)notification {
  [self screenDidConnect:[notification object]];
}

-(void) setupExternalWindow {
  NSArray *screens = [UIScreen screens];
  if (screens.count > 1) {
    UIScreen *screen = [screens lastObject];
    [self screenDidConnect:screen];
  } else {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(screenDidConnectNotification:)
     name:UIScreenDidConnectNotification
     object:nil];
  }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

	//Turn this off 
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	[UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight;
	CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation( .5 * M_PI );
	
	controlsViewController = [[ControlsViewController alloc] initWithNibName:@"ControlsViewController" bundle:nil];
	tankPickerController = [[TankPickerController alloc] initWithNibName:@"TankPickerController" bundle:nil]; 
  gameOverViewController = [[GameOverViewController alloc] initWithNibName:@"GameOverViewController" bundle:nil];
	
	
	[NSTimer scheduledTimerWithTimeInterval:1/10 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
	[[controlsViewController view] setTransform:landscapeTransform];
	[[tankPickerController view] setTransform:landscapeTransform]; 
	[[connectingViewController view] setTransform:landscapeTransform]; 
	[[gameOverViewController view] setTransform:landscapeTransform]; 
	
	[[tankPickerController view] setCenter:CGPointMake(160, 240)]; 
	[[controlsViewController view] setCenter:CGPointMake(160, 240)]; 
	[[connectingViewController view] setCenter:CGPointMake(160, 240)]; 
	[[gameOverViewController view] setCenter:CGPointMake(160, 240)]; 
	
	[[controlsViewController view] setBounds:CGRectMake(0,0, 480, 320)];
	[[tankPickerController view] setBounds:CGRectMake(0,0, 480, 320)];
	[[connectingViewController view] setBounds:CGRectMake(0,0, 480, 320)];
	[[gameOverViewController view] setBounds:CGRectMake(0,0, 480, 320)];
	

	[window addSubview:[controlsViewController view]]; 
	[window addSubview:[tankPickerController view]]; 
	
  MPVolumeView *volumeView = [ [MPVolumeView alloc] init] ;
  [volumeView setShowsVolumeSlider:NO];
  [volumeView sizeToFit];
  [window addSubview:volumeView];
  
	//  NOTE:: To test out the connecting view contrleer and game over view controller for now.  Simplay uncomment these lines:	
	//	[window addSubview:[connectingViewController view]];
	//  [window addSubview:[gameOverViewController view]];

  
	[window makeKeyAndVisible];
	
  [self setupExternalWindow];
	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
  [[GameServer sharedInstance] stopServer];
  if (connection) {
		[connection disconnectFromAllPeers];
		connection.available = NO;
		[connection setDataReceiveHandler: nil withContext: nil];
		connection.delegate = nil;
		[connection release];
	}
}

- (void) hideTankPicker
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[[tankPickerController view] removeFromSuperview]; 
	[UIView commitAnimations]; 
}

-(void) timerFired {
	//TODO
	float newLeftSliderValue = [controlsViewController leftSlider].value;
	float newRightSliderValue = [controlsViewController rightSlider].value;
	
	if ((leftSliderLastValue != newLeftSliderValue) || (rightSliderLastValue != newRightSliderValue)) {
		
		leftSliderLastValue = newLeftSliderValue;
		rightSliderLastValue = newRightSliderValue;
		
		//NSLog(@"%f  %f",leftSliderLastValue, rightSliderLastValue);
		
		if (true) {
			NSString *command = [NSString stringWithFormat:@"sliderDidChange|%f %f", leftSliderLastValue, rightSliderLastValue];
			NSData *data = [command dataUsingEncoding:NSUTF8StringEncoding];
			NSError *error;
			
      if ([[GameServer sharedInstance] actingAsServer]) {
        [self sendLocalMessageToServer:command];
      }
      else {
        if (serverPeerID) {
          if (![connection sendData:data toPeers:[NSArray arrayWithObject:serverPeerID] withDataMode:GKSendDataUnreliable error:&error]) {
            NSLog(@"ERROR: %@",error);
          }
        }
      }
				
			
		}
	}
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


-(IBAction)didClickSearchNetwork:(id)sender {
	//first thing they need to do is find other players
	if (peerPicker) {
		peerPicker.delegate = nil;
		[peerPicker release];
		peerPicker = nil;
	}
	
	
	peerPicker = [[GKPeerPickerController alloc] init];
	[peerPicker setDelegate:self];
	[peerPicker setConnectionTypesMask:GKPeerPickerConnectionTypeNearby /*|GKPeerPickerConnectionTypeOnline*/];
	[peerPicker show];
}



-(IBAction)didClickFire:(id)sender {
	if (!serverPeerID && ([[GameServer sharedInstance] actingAsServer] == NO)) {
		[self didClickSearchNetwork:nil];
		return;
	}
		
	NSError *error;
  NSString *command = [NSString stringWithFormat:@"didClickFire|%f", 1];
	NSData *data = [command dataUsingEncoding:NSUTF8StringEncoding];

		
  
  if ([[GameServer sharedInstance] actingAsServer]) {
    [self sendLocalMessageToServer:command];
  }
  else {
    if (![connection sendData:data toPeers:[NSArray arrayWithObject:serverPeerID] withDataMode:GKSendDataUnreliable error:&error]) {
      NSLog(@"ERROR: %@",error);
    }
  }
  

  
  
}

/* Notifies delegate that a connection type was chosen by the user.
 */
//- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type;

/* Notifies delegate that the connection type is requesting a GKSession object.
 
 You should return a valid GKSession object for use by the picker. If this method is not implemented or returns 'nil', a default GKSession is created on the delegate's behalf.
 */
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
	GKSession *session = [[[GKSession alloc] initWithSessionID:@"wangchung" displayName:nil sessionMode:GKSessionModePeer] autorelease];
	[session setDelegate:self];
	[session setDataReceiveHandler:self withContext:nil];
	return session;
}

/* Notifies delegate that the peer was connected to a GKSession.
 */
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
	NSLog(@"session wtf: %@", session);
	[peerPicker dismiss];
	[fireButton setHidden:NO];
	[searchButton setHidden:NO];
}

/* Notifies delegate that the user cancelled the picker.
 */
//- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker;


/* Indicates a state change for the given peer.
 */
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
	if (state == GKPeerStateAvailable) {
		NSLog(@"GKPeerStateAvailable wtf: %@", session);
	}
	if (state == GKPeerStateUnavailable) {
		NSLog(@"GKPeerStateUnavailable wtf: %@", session);
	}
	if (state == GKPeerStateConnected) {
		NSLog(@"GKPeerStateConnected wtf: %@", session);
		connection = session;
		[controlsViewController connectionEstablished];
	} 
	if (state == GKPeerStateDisconnected) {
		NSLog(@"GKPeerStateDisconnected wtf: %@", session);
		connection = nil;
		peerPicker = nil;
	}
	if (state == GKPeerStateConnecting) {
		NSLog(@"GKPeerStateConnecting wtf: %@", session);
	}
}

/* Indicates a connection request was received from another peer. 
 
 Accept by calling -acceptConnectionFromPeer:
 Deny by calling -denyConnectionFromPeer:
 */
- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
}

/* Indicates a connection error occurred with a peer, which includes connection request failures, or disconnects due to timeouts.
 */
- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
	UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"session connectionWithPeerFailed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[a show];
	[a release];
}

/* Indicates an error occurred with the session such as failing to make available.
 */
- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
	UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"session connectionWithPeerFailed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[a show];
	[a release];
}




-(void) sendID:(NSString *)_serverPeerID {
	self.serverPeerID = _serverPeerID;
	NSString *string = [NSString stringWithFormat:@"confirmiPhone|%i|%@",tank_id,playerName];
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error;
	
	
  if ([[GameServer sharedInstance] actingAsServer]) {
    [self sendLocalMessageToServer:string];
  }
  else {
    if (![connection sendData:data toPeers:[NSArray arrayWithObject:serverPeerID] withDataMode:GKSendDataUnreliable error:&error]) {
      NSLog(@"ERROR: %@",error);
    }
  }
  
  

	
	//UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"" message:@"TElling serve I am iphone" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
	//[a show];
	//[a release];
	//TODO
}

-(void) receiveData:(NSData *)data fromPeer:(NSString *)peerId inSession:(GKSession *)session context:(id)context {
	 
   NSString *command = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSArray *argv = [command componentsSeparatedByString:@"|"];
	
	if ([command isEqualToString:@"playerDidTakeDamage"]) {
		[controlsViewController playerDidTakeDamage];
	}
	
	NSLog(@"command: %@",[argv objectAtIndex:0]);
	
	SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:",[argv objectAtIndex:0]]);
	if ([self respondsToSelector:selector]) {
		if (argv.count == 1) {
			[self performSelector:selector];
		}
		if (argv.count == 2) {
			NSLog(@"args: %@",[argv objectAtIndex:1]);
			[self performSelector:selector withObject:[argv objectAtIndex:1]];
		}
		
	}
	else {
		NSLog(@"PROTOCAL ERROR");
	}
	NSLog(@"%@",command);
}


-(void) sendLocalMessageToServer:(NSString *)message {
  [[GameServer sharedInstance] receiveData:[message dataUsingEncoding:NSUTF8StringEncoding] fromPeer:@"LOCAL_DEVICE" inSession:nil context:nil];
}

@end
