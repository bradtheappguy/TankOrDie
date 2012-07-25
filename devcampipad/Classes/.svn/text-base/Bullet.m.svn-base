//
//  Bullet.m
//  devcampipad
//
//  Created by Jon Bardin on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Bullet.h"


#define kBulletWidth 15.0
#define kBulletHeight 15.0
#define kFlyingTime 4.0
#define kExplodingTime 0.5
#define kBulletSpeed 40.0


@implementation Bullet


@synthesize player;
@synthesize direction;
@synthesize rot;
@synthesize origin;
@synthesize exploding;
@synthesize damage;


-(void)dealloc {
	NSLog(@"Bullet::dealloc");
	[player release];
	[super dealloc];
}


-(id)initWithImage:(UIImage *)theImage AndPlayer:(Player *)thePlayer {
	if (self = [super initWithFrame:CGRectMake(0.0, 0.0, kBulletWidth, kBulletHeight)]) {
		[self setPlayer:thePlayer];

		[self setImage:[UIImage imageNamed:@"tank_bullet.png"]];
		[self setContentMode:UIViewContentModeScaleAspectFit];
		[self setCenter:[player center]];
		[self setRot:[player rot]];
		
		speed = kBulletSpeed;
		timeSpentExploding = 0;
		timeSpentFlying = 0;
		exploding = NO;
		
		/*
		[self setTransform:CGAffineTransformScale([self transform], 5.0, 5.0)];
		[self setImage:nil];
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
		//[self setAnimationRepeatCount:1];
		[self setAnimationDuration:kExplodingTime];
		[self setAnimationImages:explosion];
		[self startAnimating];
		 */
		
	}	
	return self;
}


-(void)update:(NSTimeInterval)dt {
	if (exploding) {
		timeSpentExploding += dt;
		if (timeSpentExploding > kExplodingTime) {
			[self setHidden:YES];
			[self stopAnimating];
		} else {
			[self setTransform:CGAffineTransformRotate([self transform], 0.1)];
		}
	} else if (timeSpentFlying > kFlyingTime) {
		[self explode];
	} else {
		timeSpentFlying += dt;
		pos = self.center;
		direction = CGPointMake(-sin(rot),cos(rot));
		//self.transform = CGAffineTransformRotate([self transform], rot);
		self.transform = CGAffineTransformMakeRotation(rot);
	}
	
	pos = CGPointMake(pos.x - direction.x * (speed * dt), pos.y - direction.y * (speed * dt));

	self.center = pos;

}


-(void)explode {
	speed = 0;
	
	[self setTransform:CGAffineTransformScale([self transform], 5.0, 5.0)];
	[self setImage:nil];
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
	[self setAnimationDuration:kExplodingTime];
	[self setAnimationImages:explosion];
	[self startAnimating];
	
	exploding = YES;
}

@end