/*
 *  Map.h
 *  devcampipad
 *
 *  Created by Jon Bardin on 5/17/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#import "micropather.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

#include <ctype.h>
#include <stdio.h>
#include <memory.h>
#include <math.h>

#include <vector>
#include <iostream>

using namespace micropather;

class Map : public Graph {

public:
	
	CCTMXLayer *layer;
	
	Map(id theLayer);
	~Map();
	
	void NodeToXY( void* node, int* x, int* y );
	
	void* XYToNode( int x, int y );
	
	float LeastCostEstimate( void* nodeStart, void* nodeEnd );
	void AdjacentCost( void* node, std::vector< StateCost > *neighbors );
	void PrintStateInfo( void* node );
	
	int Passable( int nx, int ny );
	
	
};