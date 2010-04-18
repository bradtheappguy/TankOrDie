//
//  PlayerView.m
//  devcampipad
//
//  Created by Brad Smith on 4/17/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import "devcampipadAppDelegate.h"
#import "PlayerView.h"
#import "Bullet.h"


#define kPlayerHeight 80
#define kPlayerwidth 80
#define kMaxTankSpeed 70.0
#define kTurnRate 1.25
#define stepSize 5
#define kTankAcceleration 5.0
#define kTimeBetweenFire 2.0
#define kTakeDamageDuration 3.0


@implementation PlayerView


@synthesize direction;
@synthesize rot;
@synthesize lastFiredAt;
@synthesize board;
@synthesize peerID;
@synthesize inLocalBoard;
@synthesize lastTookDamageAt;
@synthesize takingDamage;


-(id)initWithBoard:(SlaveBoard *)_board ID:(NSString *)pID {
	if ((self = [super initWithFrame:CGRectMake(0, 0, kPlayerwidth, kPlayerHeight)])) {
        self.backgroundColor = [UIColor clearColor];
		self.image = [UIImage imageNamed:@"tank_01.png"];
		self.center = CGPointMake(720/2, 1024/2);
		self.board = _board;
		self.peerID = pID;
		rot = 0.5;
		speed = 1.0;
		direction = CGPointMake(1.0, 1.0);
		inLocalBoard = YES;
		pos = self.center;
		direction = CGPointMake(-sin(rot),cos(rot));
		leftSliderValue = 0.1;
		rightSliderValue = 1.0;
		hasMultiShotBonus = YES;
		hasShieldBonus = NO;
		
		[self setLastFiredAt:[NSDate dateWithTimeIntervalSinceNow:-kTimeBetweenFire]];
    }
    return self;
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


- (id)initWithFrame:(CGRect)frame {
    NSAssert(false,@"Juut use init on Player!");
	return nil;
}


- (void)dealloc {
    [super dealloc];
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
	if (p < 0) {
		if ([self.board connectionAt:negdir]) {
			NSLog(@"** okay there's a board in that (%d) direction!", negdir);
			return negdir+1;
		} else {
			NSLog(@"** there's no board in that direction (%d)", negdir);
		}
	} else if (p > size) {
		if ([self.board connectionAt:posdir]) {
			NSLog(@"** okay there's a board in that (%d) direction!", posdir);
			return posdir+1;
		} else {
			NSLog(@"** there's no board in that direction (%d)", posdir);
		}
	}
	return 0;
}

-(void) relocate {
	int newdir = [self couldRelocate:pos.x size:768 positiveDirection:BOARD_EAST negativeDirection:BOARD_WEST];
	if (!newdir) newdir = [self couldRelocate:pos.y size:1024 positiveDirection:BOARD_SOUTH negativeDirection:BOARD_NORTH];
	if (!newdir) {
		NSLog(@"can't move out of here! boo");
		if (pos.x < 0) pos.x = 0;
		if (pos.x > BOARD_SIZE_X) pos.x = BOARD_SIZE_X;
		if (pos.y < 0) pos.y = 0;
		if (pos.y > BOARD_SIZE_Y) pos.y = BOARD_SIZE_Y;
	} else {
		newdir--;
		NSLog(@"okay we can move out of here in direction %d!", newdir);
		inLocalBoard = NO;
		pos = CGPointMake(200.0, 200.0);
		[self setHidden:YES];
		[(devcampipadAppDelegate *)[[UIApplication sharedApplication] delegate] relocatePlayer:self inDir:newdir];
	}
}

-(void)update:(NSTimeInterval)dt {
	#warning Not sure what to do here yet...
	if (!inLocalBoard) {
		return;
	}
	
	pos = self.center;
	
	moveForward = NO;
	moveBackward = NO;
	turnLeft = NO;
	turnRight = NO;
	
	float sliderDelta = leftSliderValue - rightSliderValue;
	float absDelta = fabs(sliderDelta);
	
	if (absDelta > 0.2) {
		if (sliderDelta < 0.0) {
			turnLeft = YES;
		} else {
			turnRight = YES;
		}
	}
	
	if (rightSliderValue >= 0.5 && leftSliderValue >= 0.5) {
		moveForward = YES;
	} else if (rightSliderValue < 0.4 && leftSliderValue < 0.4) {
		moveBackward = YES;
	}
	
	if (turnLeft) {
		rot -= kTurnRate * dt;
		direction = CGPointMake(-sin(rot),cos(rot));
	} else if (turnRight) {
		rot += kTurnRate * dt;
		direction = CGPointMake(-sin(rot),cos(rot));
	}
	
	if (moveForward) {
		speed += kTankAcceleration;
		if (speed > kMaxTankSpeed) {
			speed = kMaxTankSpeed;
		}
		pos = CGPointMake(pos.x - direction.x * (speed * dt), pos.y - direction.y * (speed * dt));
	} else if (moveBackward) {
		speed -= kTankAcceleration;
		if (speed < -kMaxTankSpeed) {
			speed = -kMaxTankSpeed;
		}
		pos = CGPointMake(pos.x - direction.x * (speed * dt), pos.y - direction.y * (speed * dt));
	} else {
		pos = CGPointMake(pos.x - direction.x * (speed * dt), pos.y - direction.y * (speed * dt));
	}
	
	if (pos.x < 0 || pos.x > 768 || pos.y < 0 || pos.y > 1024) {
		[self relocate];
		NSLog(@"**** OFF SCREEN GOING ELSEWHERE ****");
	}
	
	if (takingDamage) {
		NSTimeInterval timeSinceLastTookDamage = [[NSDate date] timeIntervalSinceDate:lastTookDamageAt];
		if (timeSinceLastTookDamage > kTakeDamageDuration) {
			takingDamage = NO;
		} else {
			rot += 1.0;
			pos = self.center;
		}
	}
	
	self.transform = CGAffineTransformMakeRotation(rot);
	self.center = pos;
}


-(void)didClickFire:(id)bulletType {
	NSTimeInterval timeSinceLastFired = [[NSDate date] timeIntervalSinceDate:lastFiredAt];
	
	if (timeSinceLastFired >= kTimeBetweenFire && !takingDamage) {
		if (hasMultiShotBonus) {
			for (int i = -1; i<2; i++) {
				Bullet *bullet = [Bullet bulletFrom:self WithType:bulletType];
				[bullet setRot:rot + (i * 0.5)];
				[(devcampipadAppDelegate *)[[UIApplication sharedApplication] delegate] player:self didFire:bullet];
			}
		} else {
			Bullet *bullet = [Bullet bulletFrom:self WithType:bulletType];
			[(devcampipadAppDelegate *)[[UIApplication sharedApplication] delegate] player:self didFire:bullet];
		}

		[self setLastFiredAt:[NSDate date]];
	}
}


-(void)takeDamage {
	[self setLastTookDamageAt:[NSDate date]];
	takingDamage = YES;
}


@end
