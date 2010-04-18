//
//  Bullet.h
//  devcampipad
//
//  Created by Jon Bardin on 4/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PlayerView;


@interface Bullet : UIImageView {
	PlayerView *player;
	float rot;
	float speed;
	CGPoint direction;
	CGPoint origin;
	CGPoint pos;
	NSTimeInterval timeSpentExploding;
	NSTimeInterval timeSpentFlying;
	BOOL exploding;
}


+(id)bulletFrom:(PlayerView *)thePlayer WithType:(id)type;
-(void)update:(NSTimeInterval)dt;
-(void)explode;


@property (nonatomic, retain) PlayerView *player;
@property float rot;
@property CGPoint direction;
@property CGPoint origin;
@property BOOL exploding;

@end