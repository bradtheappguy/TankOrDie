//
//  World.m
//  devcampipad
//
//  Created by Jon Bardin on 5/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "World.h"

#import "SpaceManager.h"
#import "cpCCSprite.h"
#import "cpShapeNode.h"
#import "CCPointParticleSystem.h"
#import "CCParticleSystem.h"
#import "BulletParticleSystem.h"
#import "micropather.h"

using namespace micropather;

#import "Map.h"

@implementation World

+(id)scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	World *layer = [World node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id) init
{
	if( (self=[super init])) {
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		 
		
		
		//balls = [[CCSpriteSheet alloc] initWithTexture:[[CCTextureCache sharedTextureCache] addImage: @"ball.png"] capacity:50];
		
		
		smgr = [[SpaceManager alloc] init];
		
		map = [CCTMXTiledMap tiledMapWithTMXFile:@"001.tmx"];

		//smokeEmitter = [[BulletParticleSystem alloc] init];
		
		/*
		smokeEmitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"smoke.png"];

		
		// duration
		smokeEmitter.duration = -1;
		
		
		// gravity
		smokeEmitter.gravity.x = 0;
		smokeEmitter.gravity.y = 0;
		
		// angle
		smokeEmitter.angle = 90;
		smokeEmitter.angleVar = 5;
		
		// radial acceleration
		smokeEmitter.radialAccel = 0;
		smokeEmitter.radialAccelVar = 0;
		
		// emitter position
		smokeEmitter.posVar = ccp(0, 0);
		
		// life of particles
		smokeEmitter.life = 4;
		smokeEmitter.lifeVar = 1;
		
		// speed of particles
		smokeEmitter.speed = 25;
		smokeEmitter.speedVar = 10;
		
		// size, in pixels
		smokeEmitter.startSize = 10.0f;
		smokeEmitter.startSizeVar = 0.0f;
		smokeEmitter.endSize = 10.0f;
		smokeEmitter.endSizeVar = 0.0;
		
		// emits per frame
		smokeEmitter.emissionRate = smokeEmitter.totalParticles / smokeEmitter.life;
		
		
		
		// color of particles
		smokeEmitter.startColor.r = 0.8f;
		smokeEmitter.startColor.g = 0.8f;
		smokeEmitter.startColor.b = 0.8f;
		smokeEmitter.startColor.a = 1.0f;
		smokeEmitter.startColorVar.r = 0.02f;
		smokeEmitter.startColorVar.g = 0.02f;
		smokeEmitter.startColorVar.b = 0.02f;
		smokeEmitter.startColorVar.a = 0.0f;
		smokeEmitter.endColor.r = 0.0f;
		smokeEmitter.endColor.g = 0.0f;
		smokeEmitter.endColor.b = 0.0f;
		smokeEmitter.endColor.a = 1.0f;
		smokeEmitter.endColorVar.r = 0.0f;
		smokeEmitter.endColorVar.g = 0.0f;
		smokeEmitter.endColorVar.b = 0.0f;
		smokeEmitter.endColorVar.a = 0.0f;
		
		smokeEmitter.blendAdditive = NO;
		 */
		
		
		
		//[smokeEmitter setTexture:[[CCTextureCache sharedTextureCache] addImage: @"smoke.png"]];

		
		
		[smgr setGravity:cpvzero];
		[smgr setDamping:0.5];
		
		[smgr addWindowContainmentWithFriction:1.0 elasticity:1.0 inset:cpvzero];
		

		
		[smgr addCollisionCallbackBetweenType:1
									otherType:1
									   target:self                      
									 selector:@selector(handleCollision:arbiter:space:)];
		
		
		
		
		layer = [map layerNamed:@"Walls"];
		[layer setVertexZ:10];
		
		for (int row=0; row<layer.layerSize.width; row++) {
			for (int col=0; col<layer.layerSize.height; col++) {
				int tileId=[layer tileGIDAt:ccp(row,col)];
				//NSLog(@"tileId: %d %d %d", row, col, tileId);
				if (0 != tileId) {
					CGPoint p = [layer positionAt:ccp(row,col)];
					p.x += 16;
					p.y += 16;
					cpShape* treeTile = [smgr addRectAt:p mass:STATIC_MASS width:32.0 height:32.0 rotation:0];
					[self addChild:[cpCCNode nodeWithShape:treeTile]];
					//[self addChild:[cpShapeNode nodeWithShape:treeTile]];
				}
			}
		}

		

		
		
		/*
		 emitter.startSize = 10;
		 emitter.duration = 1;
		 emitter.lifeVar = 1;
		 emitter.life = 1;
		 emitter.speed = 100;
		 emitter.speedVar = 10;
		 emitter.emissionRate = 5000;
		 emitter.position = pt;
		 */
		
		
		// We joint the tank to the control body and control the tank indirectly by modifying the control body.
		tankControlBody = cpBodyNew(STATIC_MASS, INFINITY);
		cpShape *tank = [smgr addCircleAt:cpv(16.0, 1010.0) mass:1.0 radius:10.0];
		//cpShape *tank = [smgr addRectAt:cpv(0.0, 0.0) mass:50.0 width:20.0 height:20.0 rotation:0.0];		
		tank->collision_type = 1;
		tankSprite = [cpCCSprite spriteWithShape:tank texture:[[CCTextureCache sharedTextureCache] addImage: @"tank_01.png"]];
		
		cpConstraint *pivot = [smgr addPivotToBody:tankControlBody fromBody:[tankSprite shape]->body toBodyAnchor:cpvzero fromBodyAnchor:cpvzero];
		pivot->biasCoef = 0.0; // disable joint correction
		pivot->maxForce = 10000.0; // emulate linear friction
		cpConstraint *gear = [smgr addGearToBody:tankControlBody fromBody:[tankSprite shape]->body phase:0.0 ratio:1.0];
		//gear->biasCoef = 1.0; // disable joint correction
		//gear->maxBias = 1.0;
		//gear->maxForce = 500000.0; // emulate angular friction
		
		/*
		for (int i=0; i<25; i++) {
			cpShape *ball = [smgr addCircleAt:cpv(500 + i * 5, 500 + i * 5) mass:2.0 radius:10];
			ball->collision_type = 1;
			cpCCSprite *ballSprite = [cpCCSprite spriteWithShape:ball texture:[[CCTextureCache sharedTextureCache] addImage: @"ball.png"]];
			[balls addChild:ballSprite];
		}
		 */
		
		
		[self addChild:map];
		[self addChild:tankSprite];
		//[smokeEmitter setVertexZ:20];
		//[self addChild:smokeEmitter];

		
		
		
		
		
		Map *m = new Map(layer);
		
		
		MicroPather pather(m);
		
		
		float totalCost;
		
		
		void *startState = (void*)(0 * 24 + 0);
		void *endState = (void*)(10 * 24 + 15);
		//void *endState = (void*)(10 * 24 + 0);

		int result = pather.Solve( startState, endState, &path, &totalCost );
		
		
		if ( result == MicroPather::SOLVED ) {
			NSLog(@"good");
		}
		NSLog(@"Pather returned %d\n", result);
		
		/*
		void NodeToXY( void* node, int* x, int* y ) 
		{
			int index = (int)node;
			*y = index / MAPX;
			*x = index - *y * MAPX;
		}
		
		void* XYToNode( int x, int y )
		{
			return (void*) ( y*MAPX + x );
		}
		 */
		
		
		
		
		
		unsigned k;
		// Wildly inefficient demo code.
		unsigned size = path.size();
		for( k=0; k<size; ++k ) {
			int x, y;
			
			int index = (int)path[k];
			y = index / 24;
			x = index - y * 24;			
			
			CGPoint p = [layer positionAt:ccp(x,y)];
			p.x += 16;
			p.y += 16;
			//CCSprite *ball = [CCSprite spriteWithFile:@"ball.png"];
			//[ball setPosition:p];
			//[self addChild:ball];
			
			//cpShape* pathTile = [smgr addRectAt:p mass:STATIC_MASS width:32.0 height:32.0 rotation:0];
			//[self addChild:[cpCCNode nodeWithShape:treeTile]];
			//[self addChild:[cpShapeNode nodeWithShape:pathTile]];
			
		}
		
		currentPathStep = 1;
		currentDirection = 1;

		
		ticks = 0;
		[self schedule:@selector(step:)];


	}
	
	return self;
}


-(void) onEnter
{
	[super onEnter];
}

CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};



-(void)step:(ccTime)delta
{
	ticks++;
	
	int x, y;
	int index = (int)path[currentPathStep];
	y = index / 24;
	x = index - y * 24;	
	
	CGPoint p = [layer positionAt:ccp(x,y)];
	p.x += 16;
	p.y += 16;
	
	mousePoint = p;
	
	cpVect mouseDelta = cpvsub(mousePoint, [tankSprite position]);
	cpFloat turn = cpvtoangle(cpvunrotate([tankSprite shape]->body->rot, mouseDelta));
	cpBodySetAngle(tankControlBody, [tankSprite shape]->body->a - turn);
	
	cpFloat direction;
	
	// drive the tank towards the mouse
	if(cpvnear(mousePoint, [tankSprite position], 24.0)) {

		currentPathStep += currentDirection;

		if (currentPathStep >= path.size() || currentPathStep <= 0) {
			currentDirection *= -1;
			currentPathStep += currentDirection;

		}
		

		
	} else {
		direction = (cpvdot(mouseDelta, [tankSprite shape]->body->rot) > 0.0 ? 1.0 : -1.0);
		cpBodySetVel(tankControlBody, cpvrotate([tankSprite shape]->body->rot, cpv(50.0f * direction, 0.0f)));
	}
	
	//[smokeEmitter setPosition:ccp(100.0, 100.0)];
	
	
	
	
	

	
	/*
	// additive
	blendAdditive = NO;
	
	*/
	
	
	
	
	//[smokeEmitter setDuration:-1];
	//[smokeEmitter setSpeed:100];
	//[smokeEmitter setLife:5.0];
	//[smokeEmitter setLifeVar:0.0];
	//[smokeEmitter setEmissionRate:5.0];
	//[smokeEmitter setPositionType:kCCPositionTypeGrouped];
	//NSLog(@"rot: %f %f %f", [tankSprite rotation], [tankSprite shape]->body->a, cpvtoangle([tankSprite shape]->body->rot));
	[smokeEmitter setPosition:[tankSprite position]];
	CGFloat angle = RadiansToDegrees(cpvtoangle([tankSprite shape]->body->rot));
	
	[smokeEmitter setAngle:angle];
	[smokeEmitter setStartSpin:-angle - 90.0];
	[smokeEmitter setEndSpin:-angle - 90.0];
	
	//[smokeEmitter setStartSize:15.0];
	//[smokeEmitter setStartSizeVar:0.0];
	//[smokeEmitter setPosVar:ccp(0.0, 0.0)];
	//[smokeEmitter setGravity:ccp(0.0, 0.0)];
	//[smokeEmitter setRadialAccel:0.0];
	//[smokeEmitter setTangentialAccel:0.0];
	
	//smokeEmitter.startSize = 15.0;
	//smokeEmitter.startSizeVar = 7.0;
	//smokeEmitter.endSize = 15.0;
	//smokeEmitter.endSizeVar = 5.0;
	//smokeEmitter.posVar = cpv(0.0, 0.0);
	//[smokeEmitter setGravity:ccp(0, 0)];
	
	
	//[smokeEmitter setGravity:cpvrotate([tankSprite shape]->body->rot, cpv(50.0f * direction, 0.0f))];
	//[smokeEmitter setAngle:[tankSprite rotation]];
	[smgr step:delta];
	 
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{	
	CGPoint pt = [self convertTouchToNodeSpace:[touches anyObject]];
	//mousePoint = pt;
	
	/*
	cpShape *touchedShape = [smgr getShapeAt:pt];
	
	if (touchedShape)
	{
		cpCCSprite *sprite = touchedShape->data;
		if (sprite) {
			CGPoint forceVect = ccpSub(pt, sprite.position);
			[sprite applyImpulse:ccpMult(forceVect, 200)];
		}
	}
	 */
	
	//for (int i=0; i<50; i++) {
		cpShape *ball = [smgr addCircleAt:pt mass:1.0 radius:5];
		ball->collision_type = 1;
		cpCCSprite *ballSprite = [cpCCSprite spriteWithShape:ball texture:[[CCTextureCache sharedTextureCache] addImage: @"ball.png"]];//[cpCCSprite spriteWithShape:ball spriteSheet:balls rect:CGRectZero]; //[cpCCSprite spriteWithShape:ball file:@"ball.png"];
		//[balls addChild:ballSprite];
		
		[self addChild:ballSprite];
	//}
}


- (BOOL) handleCollision:(CollisionMoment)moment 
                 arbiter:(cpArbiter*)arb 
                   space:(cpSpace*)space {
	
	CP_ARBITER_GET_SHAPES(arb,a,b);
    BOOL hit = YES;
    
	cpVect pt;
	CCParticleSystem* emitter;
	
    switch(moment)
    {
        case COLLISION_BEGIN:
			//do something at the beginning
			
			break;
        case COLLISION_PRESOLVE:
			
			if (cpArbiterIsFirstContact(arb)) {
				pt = cpArbiterGetPoint(arb, 0);
				emitter = [[CCParticleSun alloc] initWithTotalParticles:50];
				[self addChild: emitter z:10];
				[emitter setAutoRemoveOnFinish:YES];
				[emitter release];
				
				emitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars.pvr"];
				emitter.startSize = 10;
				emitter.duration = 1;
				emitter.lifeVar = 1;
				emitter.life = 1;
				emitter.speed = 100;
				emitter.speedVar = 10;
				emitter.emissionRate = 5000;
				emitter.position = pt;
				cpArbiterIgnore(arb);
			}
			
			break;
        case COLLISION_POSTSOLVE:
			//[smgr removeAndFreeShape:a]; //remove shape a
			
			break;
        case COLLISION_SEPARATE:
			//shapes separated, do something awesome!
			
			break;
    }
	
    return hit;
}


@end