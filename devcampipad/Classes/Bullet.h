//
//  Bullet.h
//  devcampipad
//
//  Created by Jon Bardin on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
	kNone,
	kSingle,
	kTriple
} BulletEmitPattern;


@class Player;


@interface Bullet : UIImageView {
	Player *player;
	float rot;
	float speed;
	CGPoint direction;
	CGPoint origin;
	CGPoint pos;
	NSTimeInterval timeSpentExploding;
	NSTimeInterval timeSpentFlying;
	BOOL exploding;
	float damage;
}

-(id)initWithImage:(UIImage *)theImage AndPlayer:(Player *)thePlayer;
-(void)update:(NSTimeInterval)dt;
-(void)explode;


@property (nonatomic, retain) Player *player;
@property float rot;
@property CGPoint direction;
@property CGPoint origin;
@property BOOL exploding;
@property float damage;

@end