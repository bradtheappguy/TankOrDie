//
//  SlaveBoard.m
//  devcampipad
//
//  Created by Brad Smith on 4/17/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import "SlaveBoard.h"
#import "devcampipadAppDelegate.h"

@implementation SlaveBoard

@synthesize peerID, neighbors;

-(void)dealloc {
	[neighbors release];
	[super dealloc];
}

// we have 'self' as default object for all directions just to keep the array filled up
// here we return nil for self, since that means 'noone'.
-(SlaveBoard *)connectionAt:(int)dir {
	if ([neighbors objectAtIndex:dir] == self) {
		return nil; 
	}
	return [neighbors objectAtIndex:dir];
}

-(id) initWithPeerId:(NSString *)peer {
	if (self = [super init]) {
		peerID = peer;
		neighbors = [NSMutableArray arrayWithObjects:
					 self,self,self,self,nil];
		[neighbors retain];
	}
	return self;
}

-(void) setXOffset: (int)_xoffs YOffset:(int)_yoffs {
	NSLog(@"offset for some board set to %d,%d", _xoffs, _yoffs);
	xoffs = _xoffs;
	yoffs = _yoffs;
}

-(void) attachBoard: (SlaveBoard *)other inDirection: (int)dir {
	[neighbors replaceObjectAtIndex:dir withObject:other];
	[other.neighbors replaceObjectAtIndex:OPP(dir) withObject:self];
	NSLog(@"Attached a board; my neigbors are:");
	for (SlaveBoard *b in neighbors) {
		NSLog(@"- %@ (%@)", [b peerID], b == self ? @"self" : @"foreign");
	}
	[other setXOffset:xoffs + GET_OFFSET_CHANGE(BOARD_SIZE_X,dir,BOARD_EAST,BOARD_WEST) 
			  YOffset:yoffs + GET_OFFSET_CHANGE(BOARD_SIZE_Y,dir,BOARD_SOUTH,BOARD_NORTH)];
	GKSession *session = [(devcampipadAppDelegate *)[[UIApplication sharedApplication] delegate] service];
	if (peerID != nil) {
		NSLog(@"Spawning portal in dir %d", dir);
		NSData *data = [[NSString stringWithFormat: @"spawnPortal|%d",dir] dataUsingEncoding:NSUTF8StringEncoding];
		NSError *error;
		//if (![session sendDataToAllPeers:data withDataMode:GKSendDataUnreliable error:&error]) {
		if (![session sendData:data toPeers:[NSArray arrayWithObject:peerID] withDataMode:GKSendDataUnreliable error:&error]) {
			NSLog(@"ERROR: %@",error);
		}
	} else {
		[(devcampipadAppDelegate *)[[UIApplication sharedApplication] delegate] spawnPortal:[NSString stringWithFormat:@"%d", dir]];
	}
	{
		int oppdir = OPP(dir);
		NSLog(@"Spawning other portal in dir %d", oppdir);
		NSData *data = [[NSString stringWithFormat: @"spawnPortal|%d",oppdir] dataUsingEncoding:NSUTF8StringEncoding];
		NSError *error;
		//if (![session sendDataToAllPeers:data withDataMode:GKSendDataUnreliable error:&error]) {
		if (![session sendData:data toPeers:[NSArray arrayWithObject:[other peerID]] withDataMode:GKSendDataUnreliable error:&error]) {
			NSLog(@"ERROR: %@",error);
		}
	}
}


@end
