//
//  Sound.m
//  devcampiphone
//
//  Created by joshm on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Sound.h"


@implementation Sound

- (void) playTrackSound
{
	
	if(!tracksound){
		NSString *soundFile = @"track";
		tracksound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:soundFile ofType:@"caf"]] error:NULL]; 
		tracksound.delegate = self;
		[tracksound setNumberOfLoops:-1]; 
	}
	[tracksound play]; 
	 
}

- (void) stopTrackSound
{
	
	if(!tracksound){
		NSString *soundFile = @"track";
		tracksound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:soundFile ofType:@"caf"]] error:NULL]; 
		tracksound.delegate = self;
		[tracksound setNumberOfLoops:-1]; 
	}
	[tracksound stop]; 	
	 
}

- (void) playFireSound
{

	
	 if(!firesound){
		NSString *soundFile = @"fire";
		firesound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:soundFile ofType:@"caf"]] error:NULL]; 
		firesound.delegate = self;
		[firesound setNumberOfLoops:0]; 
		canFire = true; 
	}
	
	if(canFire){
		canFire = false; 
		
		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setCanFire) userInfo:nil repeats:NO];

		if(firesound.playing)
			[firesound setCurrentTime:0.0];
		else
			[firesound play];
	}	
	 
}

- (void) setCanFire
{
	canFire = true; 
}

- (void) playHitSound
{
	
	if(!hitsound){
		NSString *soundFile = @"hit";
		hitsound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:soundFile ofType:@"caf"]] error:NULL]; 
		hitsound.delegate = self;
		[hitsound setNumberOfLoops:0]; 
	}
	if(hitsound.playing)
		[hitsound setCurrentTime:0.0];
	else
		[hitsound play];
	 
}

- (void) playSoundtrack
{
	
	if(!soundtrack){
		NSString *soundFile = @"soundtrack";
		soundtrack = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:soundFile ofType:@"mp3"]] error:NULL]; 
		soundtrack.delegate = self;
		[soundtrack setNumberOfLoops:-1]; 
	}
	[soundtrack play];
	 
	
}

- (void) stopSoundtrack
{
	
	if(!soundtrack){
		NSString *soundFile = @"soundtrack";
		soundtrack = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:soundFile ofType:@"mp3"]] error:NULL]; 
		soundtrack.delegate = self;
		[soundtrack setNumberOfLoops:-1]; 
	}
	[soundtrack stop]; 	
	 
}

@end
