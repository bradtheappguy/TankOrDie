//
//  Sound.h
//  devcampiphone
//
//  Created by joshm on 4/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>

@interface Sound : NSObject <AVAudioPlayerDelegate> {
	AVAudioPlayer *soundtrack;
	AVAudioPlayer *tracksound;
	AVAudioPlayer *firesound;
	AVAudioPlayer *hitsound; 
	bool canFire; 
}

- (void) setCanFire; 
- (void) playTrackSound;
- (void) stopTrackSound; 
- (void) playFireSound;
- (void) playHitSound;
- (void) playSoundtrack;
- (void) stopSoundtrack;

@end
