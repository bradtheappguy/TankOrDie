//
//  BulletParticleSystem.m
//  devcampipad
//
//  Created by Jon Bardin on 5/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BulletParticleSystem.h"
#import "CCTextureCache.h"


@implementation BulletParticleSystem

-(id) init
{
	return [self initWithTotalParticles:200];
}

-(id) initWithTotalParticles:(int) p
{
	if( (self=[super initWithTotalParticles:p]) ) {
		
		// duration
		duration = -1;
		
		// gravity
		gravity.x = 0.0;
		gravity.y = 0.0;
		
		// angle
		angle = 0.0;
		angleVar = 5.0;
		
		// radial acceleration
		
		radialAccel = 0.0;
		radialAccelVar = 0.0;
		
		// tagential
		tangentialAccel = 0.0;
		tangentialAccelVar = 1.0;
		
		// life of particles
		life = 4.0;
		lifeVar = 0.0;
		
		// speed of particles
		speed = 150.0;
		speedVar = 0.0;
		
		// size, in pixels
		startSize = 30.0f;
		startSizeVar = 0.0f;
		endSize = kCCParticleStartSizeEqualToEndSize;
		
		// emits per frame
		emissionRate = 20.0;
		//emissionRate = totalParticles/life;
		
		//spin
		//startSpin = 75.0;
		startSpinVar = 0.0;
		
		//endSpin = 75.0;
		endSpinVar = 0.0;
		
		// color of particles
		startColor.r = 0.8f;
		startColor.g = 0.8f;
		startColor.b = 0.8f;
		startColor.a = 1.0f;
		startColorVar.r = 0.02f;
		startColorVar.g = 0.02f;
		startColorVar.b = 0.02f;
		startColorVar.a = 0.0f;
		endColor.r = 0.0f;
		endColor.g = 0.0f;
		endColor.b = 0.0f;
		endColor.a = 1.0f;
		endColorVar.r = 0.0f;
		endColorVar.g = 0.0f;
		endColorVar.b = 0.0f;
		endColorVar.a = 0.0f;
		
		self.texture = [[CCTextureCache sharedTextureCache] addImage: @"tank_bullet.png"];
		
		// additive
		blendAdditive = NO;
	}
	
	return self;
}
@end
