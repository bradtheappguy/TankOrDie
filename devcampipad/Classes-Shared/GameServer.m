//
//  GameServer.m
//  devcampipad
//
//  Created by Brad Smith on 7/21/12.
//  Copyright (c) 2012 Focal Labs. All rights reserved.
//

#import "GameServer.h"
#import <GameKit/GameKit.h>
#import "TouchController.h"
#import "Player.h"
#import "Bullet.h"
#import "TDiPadMenuViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation GameServer

@synthesize window, serverPeerID;
@synthesize client;
@synthesize service;
@synthesize bullets;
@synthesize lastTicked;
@synthesize soundPlayer;
@synthesize touchController;
@synthesize connectedPeers;
@synthesize gamePaused;

+ (id)sharedInstance
{
  static dispatch_once_t once;
  static id sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}



-(void) startServer {
	
	gamePaused = YES;
	soundPlayer = [[Sound alloc] init];
	[UIApplication sharedApplication].idleTimerDisabled = YES;
  
	[NSTimer scheduledTimerWithTimeInterval:FRAMERATE target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
	stopButton.hidden = YES;
	
	[self setBullets:[NSMutableArray arrayWithCapacity:100]];
	
    //connectedBoards = [[NSMutableDictionary alloc] init];
	self.connectedPeers = [[NSMutableArray alloc] init];
	
	peerCountLabel.text = @"0";
	
	
	service = [[GKSession alloc] initWithSessionID:@"wangchung" displayName:nil sessionMode:GKSessionModeServer];
	service.delegate = self;
	service.available = YES; 
	[service setDataReceiveHandler:self withContext:nil];
	newButton.hidden = YES;
	stopButton.hidden = NO;
	
	[self setLastTicked:[NSDate date]];
	
  NSLog(@"Server Starting...");
  
  [NSTimer scheduledTimerWithTimeInterval:FRAMERATE target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
	
}



-(void) stopServer {
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
    //if (gamePaused) {
		//return;
    //}
	
	BOOL hasPlayersConnected = NO;
	
	Bullet *bullet;
	Player *player;
	
	NSTimeInterval dt = [[NSDate date] timeIntervalSinceDate:lastTicked];
	
	for(player in self.connectedPeers) {
		if ([[player peerID] isEqualToString:@"dbgPlayer"]) {
			[self player:player didFireBullet:@"1"];
		} else {
			[touchController setLastTouchedPoint:[player center]];
		}
		
		hasPlayersConnected = YES;
		[player update:dt pointOfInterest:[touchController lastTouchedPoint]];
	}
	
	for (int i = 0; i < [bullets count]; i++) {
		bullet = [bullets objectAtIndex:i];
		[bullet update:dt + (FRAMERATE * 4)];
		for(player in self.connectedPeers) {
			if (player.takingDamage || bullet.exploding) {
			} else {
				if (![[bullet player] isEqual:player]) {
					BOOL collided = CGRectContainsPoint([player frame], [bullet center]);
					if (collided) {
						[bullet explode];
						if ([player takeDamage]) {
							[soundPlayer playHitSound];
							[service sendData:[@"playerDidTakeDamage" dataUsingEncoding:NSUTF8StringEncoding] toPeers:[NSArray arrayWithObject:[player peerID]] withDataMode:GKSendDataUnreliable error:nil];
						}
					}
				}
			}
		}	
	}
	
	for (int i = 0; i < [bullets count]; i++) {
		bullet = [bullets objectAtIndex:i];
		if ([bullet isHidden]) {
			[bullet removeFromSuperview];
			[bullets removeObjectAtIndex:i];
		}
	}
	
	if (hasPlayersConnected) {
		[self removeLoadingView];
		[window addSubview:leftControllerViewController.view];
		[soundPlayer playSoundtrack];
	}
	
	[self setLastTicked:[NSDate date]];
}


- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
	[session acceptConnectionFromPeer:peerID error:nil];	
}


- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
	switch (state) {
		case GKPeerStateAvailable: {
			break;
		}
		case GKPeerStateUnavailable: {
			break;
		}
    case GKPeerStateConnecting: {
      NSLog(@"Connecting...");
      break;
    }
		case GKPeerStateConnected: {
			[self requestConnectingClientIdentity:peerID];
			break;
		}
		case GKPeerStateDisconnected: {
        //TODO: foo
			break;
		}
	}
}


- (void) updateLabels {
	peerCountLabel.text = [NSString stringWithFormat:@"%i",connectedPeers.count];
}


-(void) receiveData:(NSData *)data fromPeer:(NSString *)peerId inSession:(GKSession *)_session context:(id)context {
	Player *player;
	for (player in self.connectedPeers) {
		if ([[player peerID] isEqualToString:peerId]) {
			break;
		}
	}
	
	NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"message: %@", message);
	
	NSMutableArray *argv = [NSMutableArray arrayWithArray:[message componentsSeparatedByString:@"|"]];
	NSString *command = [argv objectAtIndex:0];
	[argv removeObjectAtIndex:0];
	NSLog(@"command: |%@|",command);
	
	if ([command isEqualToString:@"confirmiPad"]) {
		[self confirmiPad:peerId];    
	} else if ([command isEqualToString:@"confirmiPhone"]) {
		if ([argv count] == 1) {
			[self confirmiPhone:peerId withTankID:[argv objectAtIndex:0]];
		}
		if ([argv count] == 2) {
			[self confirmiPhone:peerId withTankID:[argv objectAtIndex:0] withPlayerName:[argv objectAtIndex:1]];
		}
		
	} else if ([command isEqualToString:@"spawnPortal"]) {
		[self spawnPortal:[argv componentsJoinedByString:@"|"]];
	} else if ([command isEqualToString:@"spawnPlayer"]) {
		[self spawnPlayer:[argv componentsJoinedByString:@"|"]];
	} else if ([command isEqualToString:@"didClickFire"]) {
		[self player:player didFireBullet:[argv objectAtIndex:0]];
	} else if ([command isEqualToString:@"sliderDidChange"]) {
		[player sliderDidChange:[argv objectAtIndex:0]];
	} else if ([command isEqualToString:@"sendID"]) {
		[self sendID:[argv objectAtIndex:0]];
	} else if ([command isEqualToString:@"forward"]) {
		NSString *forwardPeer = [argv objectAtIndex:0];
		[argv removeObjectAtIndex:0];
		NSData *forwardData = [[argv componentsJoinedByString:@"|"] dataUsingEncoding:NSUTF8StringEncoding];
		[self receiveData:forwardData fromPeer:forwardPeer inSession:_session context:nil];
	} else {
		NSLog(@"Warning: could not dispatch message");
	}
  
}

-(void)player:(Player *)player didFireBullet:(NSString *)bulletType {
	BulletEmitPattern emitter = [player fireBullet];
	Bullet *bullet;
	
	if (emitter == kNone) {
      //
	} else {
		if (emitter == kSingle) {
			bullet = [[Bullet alloc] initWithImage:[UIImage imageNamed:@"tank_bullet.png"] AndPlayer:player];
			[bullets addObject:bullet];
			[window addSubview:bullet];
			[bullet release];	
		} else if (emitter == kTriple) {
			for (int i = -1; i<2; i++) {
				bullet = [[Bullet alloc] initWithImage:[UIImage imageNamed:@"tank_bullet.png"] AndPlayer:player];
				[bullet setRot:[player rot] + (i * 0.5)];
				[bullets addObject:bullet];
				[window addSubview:bullet];
				[bullet release];				
			}
		}
	}
}


-(void)sendID:(NSString *)backToServerPeer {
	NSData *data = [@"confirmiPad" dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error;
	if (![client sendData:data toPeers:[NSArray arrayWithObject:backToServerPeer] withDataMode:GKSendDataUnreliable error:&error]) {
		NSLog(@"ERROR: %@", [error userInfo]);
	}
}


-(void) confirmiPad:(NSString *) peerId {
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
	[self spawnPlayer:[NSString stringWithFormat:@"%@|%@", peerID, tankID]];
}


-(IBAction) joinButtonPressed:(id)sender {
	[self spawnPlayer:[NSString stringWithFormat:@"dbgPlayer|1"]];
}


- (void) spawnPortal:(NSString *)args {
}


- (void) spawnPlayer:(NSString *)args {
	gamePaused = NO;
  
  args = [args stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSArray *argv = [args componentsSeparatedByString:@"|"];
	Player *p = [[Player alloc] initWithID:[argv objectAtIndex:0]];
	[p setTank:[argv objectAtIndex:1]];
	[self.connectedPeers addObject:p];
	[window addSubview:p];
	[p release];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYER_JOINED"  object:nil];
}

-(void) confirmiPhone:(NSString *)peerID withTankID:(NSString *)tankID withPlayerName:(NSString *)name {
	NSString *legacy = [NSString stringWithFormat:@"%@|%@", peerID, tankID];
	NSString *args = [legacy stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSArray *argv = [args componentsSeparatedByString:@"|"];
	Player *p = [[Player alloc] initWithID:[argv objectAtIndex:0]];
	[p setTank:[argv objectAtIndex:1]];
	[p setPlayerName:name];
	[self.connectedPeers addObject:p];
	[window addSubview:p];
	[p release];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYER_JOINED"  object:nil];
}



-(void) requestConnectingClientIdentity:(NSString *)thePeerId {
	NSString *string = [NSString stringWithFormat:@"sendID|%@", service.peerID];
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error;
	if (![service sendData:data toPeers:[NSArray arrayWithObject:thePeerId] withDataMode:GKSendDataUnreliable error:&error]) {
		NSLog(@"ERROR: %@",error);
	}	
}


@end
