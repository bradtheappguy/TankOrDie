//
//  Bullet.m
//  devcampipad
//
//  Created by Jon Bardin on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Bullet.h"


#define kFlyingTime 2.0
#define kExplodingTime 0.9
#define kBulletSpeed 150.0


@implementation Bullet


@synthesize player;
@synthesize direction;
@synthesize rot;
@synthesize origin;
@synthesize exploding;


-(void)dealloc {
	NSLog(@"Bullet::dealloc");
	[super dealloc];
}


+(id)bulletFrom:(PlayerView *)thePlayer WithType:(id)type {
	Bullet *bullet = [[[Bullet alloc] initWithFrame:CGRectMake(0.0, 0.0, 70, 70)] autorelease];
	[bullet setContentMode:UIViewContentModeCenter];
	[bullet setImage:[UIImage imageNamed:@"tank_bullet.png"]];
	[bullet setPlayer:thePlayer];
	[bullet setCenter:[thePlayer center]];
	[bullet setOrigin:[thePlayer center]];
	[bullet setRot:[thePlayer rot]];
	return bullet;
}


-(id)initWithFrame:(CGRect)theFrame {
	if (self = [super initWithFrame:theFrame]) {
		speed = kBulletSpeed;
		timeSpentExploding = 0;
		timeSpentFlying = 0;
		exploding = NO;
	}
	return self;
}


-(void)update:(NSTimeInterval)dt {
	timeSpentFlying += dt;
	pos = self.center;
	direction = CGPointMake(-sin(rot),cos(rot));
	pos = CGPointMake(pos.x - direction.x * (speed * dt), pos.y - direction.y * (speed * dt));
	self.transform = CGAffineTransformMakeRotation(rot);
	self.center = pos;
	
	if (exploding) {
		timeSpentExploding += dt;
		if (timeSpentExploding > kExplodingTime) {
			[self setHidden:YES];
			[self stopAnimating];
		}
	} else if (timeSpentFlying > kFlyingTime) {
		[self explode];
	}
}


-(void)explode {
	speed = 0;
	NSArray *explosion = [NSArray arrayWithObjects:
						  [UIImage imageNamed:@"bang0001.png"],
						  [UIImage imageNamed:@"bang0002.png"],
						  [UIImage imageNamed:@"bang0003.png"],
						  [UIImage imageNamed:@"bang0004.png"],
						  [UIImage imageNamed:@"bang0005.png"],
						  [UIImage imageNamed:@"bang0006.png"],
						  [UIImage imageNamed:@"bang0007.png"],
						  [UIImage imageNamed:@"bang0008.png"],
						  [UIImage imageNamed:@"bang0009.png"],
						  [UIImage imageNamed:@"bang0010.png"],
						  [UIImage imageNamed:@"bang0011.png"], nil];
	[self setAnimationRepeatCount:1];
	[self setAnimationDuration:1];
	[self setAnimationImages:explosion];
	[self startAnimating];
	exploding = YES;
}

@end