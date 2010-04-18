//
//  PlayerView.h
//  devcampipad
//
//  Created by Brad Smith on 4/17/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Bullet;

@interface PlayerView : UIImageView {
	float rotation;
	float leftSliderValue;
	float rightSliderValue; 
	
	
	NSString *peerID;
	SlaveBoard *board;
	BOOL inLocalBoard;
	
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
}


-(void)didClickFire:(id)bulletType;
-(void)update:(NSTimeInterval)dt;
-(id)initWithBoard:(SlaveBoard *)_board ID:(NSString *)pID;
-(void)takeDamage;
-(void) setTank:(NSString *) tankID;
-(void) sliderDidChange:(NSString *)data;


@property BOOL inLocalBoard;
@property CGPoint direction;
@property float rot;
@property (nonatomic, retain) NSDate *lastFiredAt;
@property (nonatomic, retain) NSDate *lastTookDamageAt;
@property (nonatomic, retain) SlaveBoard *board;
@property (nonatomic, retain) NSString *peerID;
@property BOOL takingDamage;


@end