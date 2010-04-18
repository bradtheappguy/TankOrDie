//
//  devcampipadAppDelegate.m
//  devcampipad
//
//  Created by Brad Smith on 4/16/10.
//  Copyright Clixtr 2010. All rights reserved.
//

#import "devcampipadAppDelegate.h"
#import <GameKit/GameKit.h>
#import "PlayerView.h"
#import "Bullet.h"
#import "SlaveBoard.h"

@implementation devcampipadAppDelegate

@synthesize window, serverPeerID;
@synthesize client;
@synthesize service;
@synthesize bullets;
@synthesize lastTicked;

- (void)dealloc {
	[bullets release];
	[connectedPeers release];
    [window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	loadingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading0.png"]];
	loadingView.animationDuration = 1;
	[loadingView setAnimationImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"loading1.png"], 
																		[UIImage imageNamed:@"loading2.png"],
									 [UIImage imageNamed:@"loading3.png"],
									 [UIImage imageNamed:@"loading4.png"],
									 [UIImage imageNamed:@"loading5.png"],
									 [UIImage imageNamed:@"loading6.png"],
									 [UIImage imageNamed:@"loading7.png"],
									 [UIImage imageNamed:@"loading8.png"],
									 [UIImage imageNamed:@"loading9.png"],
									 [UIImage imageNamed:@"loading10.png"],
									 [UIImage imageNamed:@"loading11.png"],
									 [UIImage imageNamed:@"loading12.png"],
									 [UIImage imageNamed:@"loading13.png"],
									 [UIImage imageNamed:@"loading14.png"],
									 [UIImage imageNamed:@"loading15.png"],
									 [UIImage imageNamed:@"loading16.png"],
									 [UIImage imageNamed:@"loading17.png"],
									                               nil]];
	[loadingView startAnimating];
	
	[window addSubview:loadingView];
	loadingView.center = window.center;
		
	
	[NSTimer scheduledTimerWithTimeInterval:FRAMERATE target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
	stopButton.hidden = YES;
	
	[self setBullets:[NSMutableArray arrayWithCapacity:100]];
	
	connectedBoards = [[NSMutableDictionary alloc] init];
	connectedPeers = [[NSMutableDictionary alloc] init];
	
	peerCountLabel.text = @"0";
	
	[self setLastTicked:[NSDate date]];
	
	//clientModeSessionHandler = [[ClientModeSessionHandler alloc] init];
	
	//Adversie as a server
	
    [window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	if (service) {
		[service disconnectFromAllPeers];
		service.available = NO;
		[service setDataReceiveHandler: nil withContext: nil];
		service.delegate = nil;
		[service release];
	} else if (client) {
		[client disconnectFromAllPeers];
		client.available = NO;
		[client setDataReceiveHandler: nil withContext: nil];
		client.delegate = nil;
		[client release];
	}
}

-(void) timerFired {
	NSTimeInterval dt = [[NSDate date] timeIntervalSinceDate:lastTicked];
	
	for(NSString *aKey in connectedPeers) {
		[[connectedPeers valueForKey:aKey] update:dt];
	}
	
	for (int i = 0; i < [bullets count]; i++) {
		Bullet *bullet = [bullets objectAtIndex:i];
		[bullet update:dt];
		
		for(NSString *aKey in connectedPeers) {
			PlayerView *player = [connectedPeers valueForKey:aKey];
			if (player.takingDamage || bullet.exploding) {
			} else {
				if (![[bullet player] isEqual:player]) {
					BOOL collided = CGRectContainsPoint([player frame], [bullet center]);
					if (collided) {
						[bullet explode];
						[player takeDamage];
						[service sendData:[@"playerDidTakeDamage" dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:[player peerID]] withDataMode:GKSendDataUnreliable error:nil];
					}
				}
			}
		}
	}
	[self setLastTicked:[NSDate date]];
}

/* Notifies delegate that a connection type was chosen by the user.
 */
- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type{

}

/* Notifies delegate that the connection type is requesting a GKSession object.
 
 You should return a valid GKSession object for use by the picker. If this method is not implemented or returns 'nil', a default GKSession is created on the delegate's behalf.
 */
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
	if (actingAsServer) {
		return nil;
	}
	// we're a client to another ipad server
	GKSession *theNewClient = [[[GKSession alloc] initWithSessionID:@"wangchung" displayName:nil sessionMode:GKSessionModePeer] autorelease];
	[theNewClient setDelegate:self];
	[theNewClient setDataReceiveHandler:self withContext:nil];
	return theNewClient;
}

/* Notifies delegate that the peer was connected to a GKSession.
 */
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
	if (actingAsServer) {
		return;
	}
	[peerPicker dismiss];
}


/* Notifies delegate that the user cancelled the picker.
 */
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker{
}

- (void)session:(GKSession *)_session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
	if (actingAsServer) {
		[_session acceptConnectionFromPeer:peerID error:nil];	
	}
}


- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
	switch (state) {
		case GKPeerStateAvailable:
			break;
		case GKPeerStateUnavailable:
			break;
		case GKPeerStateConnected: {
			if (actingAsServer) {
				[self requestConnectingClientIdentity:peerID];
			} else {
				lastBoard = [[SlaveBoard alloc] initWithPeerId:peerID];
				[connectedBoards setObject:lastBoard forKey:peerID];
			}
			break;
		}
	}
	

	
	/*
	if (actingAsServer) {
		switch (state) {
			case GKPeerStateAvailable:
				break;
			case GKPeerStateUnavailable:
				break;
			case GKPeerStateConnected: {
				//TODO 'send data to peer (old test button')
				[self requestConnectingClientIdentity];
				break;
			}
			case GKPeerStateDisconnected:
				[[connectedPeers objectForKey:peerID] removeFromSuperview];
				[connectedPeers removeObjectForKey:peerID];
				[connectedBoards removeObjectForKey:peerID];
				[self updateLabels];
				
				break;
			case GKPeerStateConnecting:
				break;
			default:
				break;
		}
		return;
	}

	 */
}

- (void) updateLabels {
	peerCountLabel.text = [NSString stringWithFormat:@"%i",connectedPeers.count];
	boardCountLabel.text = [NSString stringWithFormat:@"%i",connectedBoards.count];
}


-(void)forwardToPeer:(NSString *)peerId theCommand:(NSString *)command withArgument:(NSString *)argument onBoard:(NSString *)board {
	NSError *error;	
	NSData *forwarded_message = [[NSString stringWithFormat:@"forward|%@|%@|%@", peerId, command, argument] dataUsingEncoding:NSUTF8StringEncoding];
	if (![service sendData:forwarded_message toPeers:[NSArray arrayWithObject:board] withDataMode:GKSendDataUnreliable error:&error]) {
		NSLog(@"ERROR: %@",error);
	}
}


-(void) receiveData:(NSData *)data fromPeer:(NSString *)peerId inSession:(GKSession *)_session context:(id)context {
	PlayerView *player = [connectedPeers objectForKey:peerId];
	
	NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"message: %@", message);
	
	NSMutableArray *argv = [NSMutableArray arrayWithArray:[message componentsSeparatedByString:@"|"]];
	NSString *command = [argv objectAtIndex:0];
	[argv removeObjectAtIndex:0];
	
	if ([command isEqualToString:@"confirmiPad"]) {
		[self confirmiPad:peerId];
	} else if ([command isEqualToString:@"confirmiPhone"]) {
		[self confirmiPhone:peerId withTankID:[argv objectAtIndex:0]];
	} else if ([command isEqualToString:@"spawnPortal"]) {
		NSLog(@"spawn portal ... arg count = %d", [argv count]);
		[self spawnPortal:[argv objectAtIndex:0]];
	} else if ([command isEqualToString:@"spawnPlayer"]) {
		[self spawnPlayer:[argv objectAtIndex:0]];
	} else if ([command isEqualToString:@"didClickFire"]) {
		if (!player.inLocalBoard) {
			[self forwardToPeer:peerId theCommand:command withArgument:[argv objectAtIndex:0] onBoard:player.board.peerID];
		} else {
			[player didClickFire:[argv objectAtIndex:0]];
		}
	} else if ([command isEqualToString:@"sliderDidChange"]) {
		if (!player.inLocalBoard) {
			[self forwardToPeer:peerId theCommand:command withArgument:[argv objectAtIndex:0] onBoard:player.board.peerID];
		} else {
			[player sliderDidChange:[argv objectAtIndex:0]];
		}
	} else if ([command isEqualToString:@"sendID"]) {
		//[clientModeSessionHandler sendID:[argv objectAtIndex:0]];
		[self sendID:[argv objectAtIndex:0]];
	} else if ([command isEqualToString:@"forward"]) {
		NSString *forwardPeer = [argv objectAtIndex:0];
		[argv removeObjectAtIndex:0];
		NSData *forwardData = [[argv componentsJoinedByString:@"|"] dataUsingEncoding:NSUTF8StringEncoding];
		[self receiveData:forwardData fromPeer:forwardPeer inSession:_session context:nil];
	}
	
	
	
	//NSLog(@"receiveData (player = %@ for pid = %@) ... '%@': '%@'", player == nil ? @"NULL" : player.peerID, peerId, [argv objectAtIndex:0], [argv objectAtIndex:1]);

	//NSLog(@"argv0: %@",[argv objectAtIndex:0]);
	//NSLog(@"command: %@",command);
	//NSLog(@"args", argv);
	
	
	//if ([command isEqualToString:@"confirmiPad"]) {
	//	[self confirmiPad:peerId];
	//	return;
	//}
	
	//if ([[argv objectAtIndex:0] isEqualToString:@"confirmiPhone"]) {
	//	[self confirmiPhone:peerId withTankID:[argv objectAtIndex:1]];
	//	return;
	//}
	

	//if ([[argv objectAtIndex:0] isEqualToString:@"spawnPortal"]) {
	//	NSLog(@"spawn portal ... arg count = %d", [argv count]);
	//	[self spawnPortal:[argv objectAtIndex:1]];
	//	return;
	//}
	
	//if ([[argv objectAtIndex:0] isEqualToString:@"spawnPlayer"]) {
	//	[self spawnPlayer:[argv objectAtIndex:1]];
	//	return;
	//}
	
	//if ([[argv objectAtIndex:0] isEqualToString:@"forward"]) {
	//	[self forward:[argv objectAtIndex:1]];
	//	return;
	//}
	
	//SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:",[argv objectAtIndex:0]]);
	
	//if ([player respondsToSelector:selector]) {
	//	if (!player.inLocalBoard) {
	//		NSError *error;
	//		NSLog(@"forward: %@ %@ %@", peerId, [argv objectAtIndex:0], [argv objectAtIndex:1]);
	//		NSData *forward = [[NSString stringWithFormat:@"forward: %@ %@ %@", peerId, [argv objectAtIndex:0], [argv objectAtIndex:1]] dataUsingEncoding:NSUTF8StringEncoding];
	//		if (![session sendData:forward toPeers:[NSArray arrayWithObject:player.board.peerID] withDataMode:GKSendDataUnreliable error:&error]) {
	//			NSLog(@"ERROR: %@",error);
	//		}
	//	} else {
	//		if (argv.count == 1)
	//			[player performSelector:selector];
	//		if (argv.count == 2)
	//			[player performSelector:selector withObject:[argv objectAtIndex:1]];
	//	}
	//}
	//else if ([self respondsToSelector:selector]) {
	//	[self performSelector:selector withObject:peerId];
	//}
	//else if ([clientModeSessionHandler respondsToSelector:selector]) {
	//	if (argv.count == 1)
	//		[clientModeSessionHandler performSelector:selector];
	//	if (argv.count == 2)
	//		[clientModeSessionHandler performSelector:selector withObject:[argv objectAtIndex:1]];
	//}	
	//else {
	//	NSLog(@"PROTOCAL ERROR command = (%@)",command);
	//}
}

-(void)sendID:(NSString *)serverPeerID {
	NSData *data = [@"confirmiPad" dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error;
	//GKSession *session = [(devcampipadAppDelegate *)[[UIApplication sharedApplication] delegate] session];
	[(devcampipadAppDelegate *)[[UIApplication sharedApplication] delegate] setServerPeerID:serverPeerID];
	if (![client sendData:data toPeers:[NSArray arrayWithObject:serverPeerID] withDataMode:GKSendDataUnreliable error:&error]) {
		NSLog(@"ERROR: %@",error);
	}
}

-(void) confirmiPad:(NSString *) peerId {
	if (!peerId) {
		NSLog(@"in confirmiPad I have no peerID argument!!!");
		return; 
	}
	
	SlaveBoard *newSlave = [[SlaveBoard alloc] initWithPeerId:peerId];
	[lastBoard attachBoard:newSlave inDirection:arc4random()%4];
	lastBoard = newSlave;
	[connectedBoards setObject:newSlave forKey:peerId];
	[newSlave release];
	[self updateLabels];
}


-(void) removeLoadingView {
	if (loadingView) {
		[UIView beginAnimations:@"" context:nil];
		[UIView setAnimationDuration:.66];
		loadingView.alpha = 0;
		[UIView commitAnimations];
		[loadingView removeFromSuperview];
		loadingView = nil;
	}
}

-(void) confirmiPhone:(NSString *)peerID withTankID:(NSString *)tankID {
	[self removeLoadingView];
		
	NSLog(@"confirm: %@", peerID);
	if (!peerID) {
		NSLog(@"no peerId");
		return; 
	}
	
	if ([connectedPeers objectForKey:peerID]) {
		NSLog(@"peer is connected: %@", peerID);
		return;
	}
	
	NSLog(@"making peer: %@", peerID);


	PlayerView *p = [[PlayerView alloc] initWithBoard:lastBoard ID:peerID];
	[p setTank:tankID];
	[connectedPeers setObject:p forKey:peerID];
	[window addSubview:p];
	[p release];
	[self updateLabels];
}

#pragma mark Buttons
-(IBAction) joinButtonPressed:(id)sender {
	[self removeLoadingView];
	NSLog(@"join pressed");
	actingAsServer = NO;
	//first thing they need to do is find other players
	peerPicker = [[GKPeerPickerController alloc] init];
	[peerPicker setDelegate:self];
	[peerPicker setConnectionTypesMask:GKPeerPickerConnectionTypeNearby /*|GKPeerPickerConnectionTypeOnline*/];
	[peerPicker show];
}

-(void)initGameServer {
	actingAsServer = YES;
	service = [[GKSession alloc] initWithSessionID:@"wangchung" displayName:nil sessionMode:GKSessionModeServer];
	service.delegate = self;
	service.available = YES; 
	[service setDataReceiveHandler:self withContext:nil];
	newButton.hidden = YES;
	stopButton.hidden = NO;
	SlaveBoard *mainBoard = [[SlaveBoard alloc] initWithPeerId:nil];
	[mainBoard setXOffset:0 YOffset:0];
	lastBoard = mainBoard;
	[connectedBoards setObject:mainBoard forKey:service.peerID];
	[mainBoard release];
}

-(IBAction) newButtonPressed:(id)sender {
	NSLog(@"new pressed");
	[self initGameServer];
}

-(IBAction) stopButtonPressed:(id)sender {
	service.available = NO; 
	service.delegate = nil;
	[service setDataReceiveHandler:nil withContext:nil];
	service = nil;
	newButton.hidden = NO;
	stopButton.hidden = YES;
	for (NSString *pid in connectedPeers) {
		[[connectedPeers objectForKey:pid] removeFromSuperview];
	}
	[connectedPeers removeAllObjects];
	[connectedBoards removeAllObjects];
}

#pragma mark Multipad code


- (void) spawnPortal:(NSString *)args {
	int dir = [args intValue];
	NSLog(@"Spawn portal in dir %@ => %d", args, dir);
	UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake((float)GET_PORTAL_POS_X(dir), (float)GET_PORTAL_POS_Y(dir),
														   150.f, 50.f)];
	[p setText:@"here be dragons"];
	[window addSubview:p];
	[p release];
}

- (void) spawnPlayer:(NSString *)args {
	NSLog(@"Spawning a player! args = %@", args);
	args = [args stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSArray *argv = [args componentsSeparatedByString:@" "];
	if ([argv count] != 2) {
		NSLog(@"*** ERROR (ARG = %@) IN SPAWN PLAYER -- ARGV COUNT IS NOT 2 ***", args);
		//return;
	}
	
	if (actingAsServer) {
		PlayerView *p = [connectedPeers objectForKey:[argv objectAtIndex:0]];
		NSLog(@"Re-enabling player on server board.");
		[p setHidden:NO];
		p.inLocalBoard = YES;
	} else {
		PlayerView *p = [[PlayerView alloc] initWithBoard:lastBoard ID:[argv objectAtIndex:0]];
		NSLog(@"Spawned player with peer ID %@", [argv objectAtIndex:0]);
		[connectedPeers setObject:p forKey:[argv objectAtIndex:0]];
		[window addSubview:p];
		[p release];
	}
	[self updateLabels];
}

-(void) relocatePlayer:(PlayerView *)ply inDir:(int)dir {
	NSLog(@"Relocating player %@ towards %d", ply.peerID, dir);
	NSData *data = [[NSString stringWithFormat:@"spawnPlayer|%@|%d", ply.peerID, dir] dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error;
	SlaveBoard *toBoard = [[ply board] connectionAt:dir];
	if (![service sendData:data toPeers:[NSArray arrayWithObject:toBoard.peerID] withDataMode:GKSendDataUnreliable error:&error]) {
		NSLog(@"ERROR: %@",error);
	}
	if (actingAsServer) {
		ply.board = toBoard;
	} else {
		[connectedPeers removeObjectForKey:ply.peerID];
	}
}

#pragma mark -


-(void) requestConnectingClientIdentity:(NSString *)thePeerId {
	NSString *string = [NSString stringWithFormat:@"sendID|%@", service.peerID];
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error;
	if (![service sendData:data toPeers:[NSArray arrayWithObject:thePeerId] withDataMode:GKSendDataUnreliable error:&error]) {
		NSLog(@"ERROR: %@",error);
	}	
}

-(void)player:(PlayerView *)thePlayer didFire:(Bullet *)theBullet {
	[bullets addObject:theBullet];
	[window addSubview:theBullet];
	[theBullet release];

}

@end
