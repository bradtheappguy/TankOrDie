//
//  World.h
//  devcampipad
//
//  Created by Jon Bardin on 5/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"
#import "SpaceManager.h"
#import "cpCCSprite.h"


#include "Map.h"


@interface World : CCLayer {

	
	SpaceManager *smgr;
	CCSpriteSheet *balls;
	
	cpBody *tankControlBody;
	cpCCSprite *tankSprite;
	CCParticleSmoke *smokeEmitter;
	
	CCTMXTiledMap *map;
	CCTMXLayer *layer;
	
	std::vector< void* > path;
	int currentPathStep;
	int currentDirection;
	
	int ticks;
	CGPoint mousePoint;
	
}


+(id) scene;
-(void)step:(ccTime)dt;


@end
