//
//  PlayerView.h
//  devcampipad
//
//  Created by Brad Smith on 4/17/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bullet.h"


@class Bullet;

@class Vector;

@interface Player : UIImageView {
	float rotation;
	float leftSliderValue;
	float rightSliderValue; 
	
	
	NSString *peerID;
	
	float shieldRot;
	float rot;
	float speed;
	CGPoint direction;
	CGPoint pos;
	
	BOOL turnLeft;
	BOOL turnRight;
	BOOL moveForward;
	BOOL moveBackward;
	BOOL hasMultiShotBonus;
	BOOL hasShieldBonus;
	BOOL takingDamage;
	
	NSDate *lastTookDamageAt;
	NSDate *lastFiredAt;
	NSDate *lastGotShieldBonusAt;
	
	UIImageView *shieldView;
	
	NSString *playerName;
	//CGPoint loc;
}

+(UIImage *) imageForTankID:(NSUInteger)tankID;

-(void)update:(NSTimeInterval)dt pointOfInterest:(CGPoint)pointOfInterest;
-(id)initWithID:(NSString *)pID;
-(BOOL)takeDamage;
-(void)setTank:(NSString *) tankID;
-(void)sliderDidChange:(NSString *)data;
-(BulletEmitPattern)fireBullet;


@property CGPoint direction;
@property float rot;
@property (nonatomic, retain) NSDate *lastFiredAt;
@property (nonatomic, retain) NSDate *lastTookDamageAt;
@property (nonatomic, retain) NSDate *lastGotShieldBonusAt;
@property (nonatomic, retain) NSString *peerID;
@property BOOL takingDamage;
@property CGPoint pos;
@property (nonatomic, retain) UIImageView *shieldView;
@property (nonatomic, retain) NSString *playerName;
//@property CGPoint loc;

@end