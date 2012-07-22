  //
//  PlayerView.m
//  devcampipad
//
//  Created by Brad Smith on 4/17/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import "devcampipadAppDelegate.h"
#import "Player.h"
#import "Bullet.h"
#import "math.h"
#import "Vector.h"


#define kBoardWidth 720.0
#define kBoardHeight 1024.0

#define kPlayerwidth 60
#define kPlayerHeight 60

#define kShieldWidth 75
#define kShieldHeight 75

#define kMaxTankSpeed 100.0
#define kTurnRate 6.0
#define stepSize 5
#define kTankAcceleration 10.0
#define kTimeBetweenFire 0.05
//0.00125
#define kTakeDamageDuration 0.5

#define kCyborgSpeed 0.0


@implementation Player


@synthesize direction;
@synthesize rot;
@synthesize pos;
@synthesize peerID;
@synthesize lastFiredAt;
@synthesize lastTookDamageAt;
@synthesize takingDamage;
@synthesize shieldView;
@synthesize lastGotShieldBonusAt;
@synthesize playerName;
//@synthesize loc;


- (void)dealloc {
	NSLog(@"Player::dealloc");
	[peerID release];
	[lastGotShieldBonusAt release];
	[lastTookDamageAt release];
	[lastFiredAt release];
	[shieldView release];
    [super dealloc];
}


-(id)initWithID:(NSString *)pID {
	if ((self = [super initWithFrame:CGRectMake(0, 0, kPlayerwidth, kPlayerHeight)])) {
		[self setPeerID:pID];
		[self setImage:[UIImage imageNamed:@"tank_01.png"]];
		[self setCenter:CGPointMake(720/2, 1024/2)];
		[self setContentMode:UIViewContentModeScaleToFill];
		
		rot = 0.0;
		speed = kCyborgSpeed;
		direction = CGPointMake(0.0, 0.0);
		pos = [self center];
		direction = CGPointMake(-sin(rot),cos(rot));
		leftSliderValue = 0.0;
		rightSliderValue = 0.0;
		hasMultiShotBonus = NO;
		hasShieldBonus = NO;
		shieldRot = 0.1;
		
		[self setLastTookDamageAt:[NSDate date]];
		[self setLastFiredAt:[NSDate dateWithTimeIntervalSinceNow:-kTimeBetweenFire]];
		
		shieldView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, kShieldWidth, kShieldHeight)];
		[shieldView setHidden:YES];
		[shieldView setImage:[UIImage imageNamed:@"shield.png"]];
		shieldView.transform = CGAffineTransformTranslate(self.transform, -(kShieldWidth - kPlayerwidth) * 0.5, -(kShieldHeight - kPlayerHeight) * 0.5);
		[self addSubview:shieldView];
		[self setUserInteractionEnabled:YES];
    }
    return self;
}

+ (UIImage *) imageForTankID:(NSUInteger)tankID {
	if (tankID == 1)   return [UIImage imageNamed:@"tank_01.png"];
	if (tankID == 2)  return [UIImage imageNamed:@"tank_02.png"];
	if (tankID == 3)  return [UIImage imageNamed:@"tank_03.png"];
	if (tankID == 4)  return [UIImage imageNamed:@"tank_04.png"];
	if (tankID == 5)  return [UIImage imageNamed:@"tank_05.png"];
	if (tankID == 6)  return [UIImage imageNamed:@"tank_06.png"];
	if (tankID == 7)  return [UIImage imageNamed:@"tank_07.png"];
	if (tankID == 8)  return [UIImage imageNamed:@"tank_08.png"];
	if (tankID == 9)  return [UIImage imageNamed:@"tank_09.png"];
	if (tankID == 10) return [UIImage imageNamed:@"tank_10.png"];
	if (tankID == 11) return [UIImage imageNamed:@"tank_11.png"];
	if (tankID == 12) return [UIImage imageNamed:@"tank_12.png"];
	NSLog(@"Whoops imageForInvalid Tank ID!");
	return nil;
}

-(void) setTank:(NSString *) tankID {
	if ([tankID isEqualToString:@"1"]) self.image = [UIImage imageNamed:@"tank_01.png"];
	if ([tankID isEqualToString:@"2"]) self.image = [UIImage imageNamed:@"tank_02.png"];
	if ([tankID isEqualToString:@"3"]) self.image = [UIImage imageNamed:@"tank_03.png"];
	if ([tankID isEqualToString:@"4"]) self.image = [UIImage imageNamed:@"tank_04.png"];
	if ([tankID isEqualToString:@"5"]) self.image = [UIImage imageNamed:@"tank_05.png"];
	if ([tankID isEqualToString:@"6"]) self.image = [UIImage imageNamed:@"tank_06.png"];
	if ([tankID isEqualToString:@"7"]) self.image = [UIImage imageNamed:@"tank_07.png"];
	if ([tankID isEqualToString:@"8"]) self.image = [UIImage imageNamed:@"tank_08.png"];
    if ([tankID isEqualToString:@"9"]) self.image = [UIImage imageNamed:@"tank_09.png"];
	if ([tankID isEqualToString:@"10"]) self.image = [UIImage imageNamed:@"tank_10.png"];
	if ([tankID isEqualToString:@"11"]) self.image = [UIImage imageNamed:@"tank_11.png"];
	if ([tankID isEqualToString:@"12"]) self.image = [UIImage imageNamed:@"tank_12.png"];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	hasShieldBonus = !hasShieldBonus;
}





-(void) sliderDidChange:(NSString *)data {
	NSArray *args = [data componentsSeparatedByString:@" "];
	leftSliderValue = [[args objectAtIndex:0] floatValue];
	rightSliderValue = [[args objectAtIndex:1] floatValue];	
}


/**
 * transfer this player to another iPad
 */
-(int) couldRelocate:(CGFloat)p size:(int)size positiveDirection:(int)posdir negativeDirection:(int)negdir {
	/*
	for (int i = 0; i < 4; i++) 
		if ([self.board connectionAt:i]) NSLog(@"- %@ (%d)", [[self.board connectionAt:i] peerID], i);
	
	if (p < 0) {
		if ([self.board connectionAt:negdir]) {
			//NSLog(@"** okay there's a board in that (%d) direction!", negdir);
			return negdir+1;
		} else {
			//NSLog(@"** there's no board in that direction (%d)", negdir);
		}
	} else if (p > size) {
		if ([self.board connectionAt:posdir]) {
			//NSLog(@"** okay there's a board in that (%d) direction!", posdir);
			return posdir+1;
		} else {
			//NSLog(@"** there's no board in that direction (%d)", posdir);
		}
	}
	 */
	return 0;
}

/*
-(CGFloat)magnitude:(CGPoint)heading {
	// Compute and display the magnitude (size or strength) of the vector.
	//      magnitude = sqrt(x^2 + y^2 + z^2)
	CGFloat magnitude = sqrt(heading.x * heading.x + heading.y * heading.y + 0);
	return magnitude;
}

-(CGPoint)steer:(CGPoint)target {
	CGPoint steer;  // The steering vector
	CGPoint desired = PVector.sub(target,loc);  // A vector pointing from the location to the target
	float d = desired.mag(); // Distance from the target is the magnitude of the vector
	// If the distance is greater than 0, calc steering (otherwise return zero vector)
	if (d > 0) {
		// Normalize desired and give it magnitude determined by maxspeed
		desired.normalize();
		desired.mult(maxspeed);
		// Steering = Desired minus Velocity
		steer = PVector.sub(desired,vel);
		steer.limit(maxforce);  // Limit to maximum steering force
	} else {
		steer = new PVector(0,0);
	}
	return steer;
}
 */


-(CGPoint)steer:(CGPoint)target {
	
	CGPoint steer;  // The steering vector
	
	CGPoint desired = [Vector subtract:target from:pos];
	
	// = [Vector sub(target,);  // A vector pointing from the location to the target
	float d = [Vector length:desired]; //mag(); // Distance from the target is the magnitude of the vector
	// If the distance is greater than 0, calc steering (otherwise return zero vector)
	if (d > 0) {
		// Normalize desired and give it magnitude determined by maxspeed
		//desired.normalize();
		///[Vector 
		//desired.mult(maxspeed);
		// Steering = Desired minus Velocity
		//steer = PVector.sub(desired,vel);
		//steer.limit(maxforce);  // Limit to maximum steering force
	} else {
		//steer = new PVector(0,0);
	}
	return steer;
}


-(void)update:(NSTimeInterval)dt pointOfInterest:(CGPoint)pointOfInterest {
	/*
	void update() {
		vel.add(acc);
		vel.limit(maxspeed);
		loc.add(vel);
		acc.setXYZ(0,0,0);
	}
	
	void seek(PVector target) {
		acc.add(steer(target));
	}
	 */
	
	
	
	
	//slope = tan(theta)
	//theta = arctan(slope) 
	
	pos = self.center;
	
	moveForward = NO;
	moveBackward = NO;
	turnLeft = NO;
	turnRight = NO;
	float sliderDelta;
	
	sliderDelta = leftSliderValue - rightSliderValue;
	
	float absDelta = fabs(sliderDelta);
	
	if (absDelta > 0.2) {
		if (sliderDelta < 0.0) {
			turnLeft = YES;
		} else {
			turnRight = YES;
		}
	}
	
	if (rightSliderValue > 0.5 && leftSliderValue > 0.5) {
		moveForward = YES;
	} else if (rightSliderValue < 0.4 && leftSliderValue < 0.4) {
		moveBackward = YES;
	}
	
	if ([peerID isEqualToString:@"dbgPlayer"]) {
		leftSliderValue = sin([[NSDate date] timeIntervalSinceDate:lastTookDamageAt]);
		rightSliderValue = cos([[NSDate date] timeIntervalSinceDate:lastTookDamageAt]);
		
		//float dx = self.center.x - pointOfInterest.x;
		//float dy = self.center.y - pointOfInterest.y;
		
		//float slope = dy / dx;
		
		//float slope = pointOfInterest.y / pointOfInterest.x;
		
		//float theta = atanf(slope);
		
		//NSLog(@"%f", theta);
		//float dr = rot - theta;
		//rot = theta;
		
		//if (dr > 0) {
		//	leftSliderValue = 0.0;
		//	rightSliderValue = 0.0;
		//} else if (dr < 0) {
		//	leftSliderValue = 0.0;
		//	rightSliderValue = 0.0;
		//} else if (dr == 0.0) {
		//	leftSliderValue = 0.0;
		//	leftSliderValue = 0.0;
		//}
		//leftSliderValue = 1.0;
		//rightSliderValue = 0.6;
		speed = 50.0;
		//rot = theta;
		
		//turnLeft = YES;
		moveForward = YES;
		//absDelta = theta;
	}
	

	
	if (turnLeft) {
		rot -= kTurnRate * absDelta * dt;
	} else if (turnRight) {
		rot += kTurnRate * absDelta * dt;
	}
	
	direction = CGPointMake(-sin(rot),cos(rot));
	
	if (moveForward) {
		speed += kTankAcceleration;
		if (speed > kMaxTankSpeed) {
			speed = kMaxTankSpeed;
		}
	} else if (moveBackward) {
		speed -= kTankAcceleration;
		if (speed < -kMaxTankSpeed) {
			speed = -kMaxTankSpeed;
		}
	}
	
	pos = CGPointMake(pos.x - direction.x * (speed * dt), pos.y - direction.y * (speed * dt));
	
	if (takingDamage) {
		NSTimeInterval timeSinceLastTookDamage = [[NSDate date] timeIntervalSinceDate:lastTookDamageAt];
		if (timeSinceLastTookDamage > kTakeDamageDuration) {
			takingDamage = NO;
		} else {
			rot += 1.25;
			pos = self.center;
		}
	}
	
	if (hasShieldBonus) {
		[shieldView setHidden:NO];
	} else {
		[shieldView setHidden:YES];
	}
	
	self.transform = CGAffineTransformMakeRotation(rot);

	
	//if (pos.x < 0 || pos.x > 768 || pos.y < 0 || pos.y > 1024) {
		if (pos.x < 0) {
			pos.x = 0;
		}
		if (pos.x > 768) {
			pos.x = 768;
		}
		if (pos.y < 0) {
			pos.y = 0;
		}
		if (pos.y > 1024) {
			pos.y = 1024;
		}
	//}
		self.center = pos;

	
	
	
	//shieldView.transform = CGAffineTransformTranslate(self.transform, -10.0, -5.0);
	//CGAffineTransformRotate(shieldView.transform, shieldRot);
	//CGAffineTransformMakeRotation();
	//CGAffineTransformTranslate(self.transform, -10.0, -5.0)

}


-(BulletEmitPattern)fireBullet {
	NSTimeInterval timeSinceLastFired = [[NSDate date] timeIntervalSinceDate:lastFiredAt];
	
	if (timeSinceLastFired >= kTimeBetweenFire && !takingDamage) {
		[self setLastFiredAt:[NSDate date]];
		if (hasMultiShotBonus) {
			return kTriple;	
		} else {
			return kSingle;
		}
	}
	
	return kNone;
}


-(BOOL)takeDamage {
	if (hasShieldBonus) {
		//
	} else {
		[self setLastTookDamageAt:[NSDate date]];
		takingDamage = YES;
	}
	return takingDamage;
}


@end
