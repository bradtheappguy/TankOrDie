/*
 *  Map.cpp
 *  devcampipad
 *
 *  Created by Jon Bardin on 5/17/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include "Map.h"

Map::Map(id the_layer) {
	layer = the_layer;
}

Map::~Map() {
	delete layer;
}

void Map::NodeToXY( void* node, int* x, int* y ) 
{
	int index = (int)node;
	*y = index / 24;
	*x = index - *y * 24;
}

void* Map::XYToNode( int x, int y )
{
	return (void*) ( y * 24 + x );
}


float Map::LeastCostEstimate( void* nodeStart, void* nodeEnd ) 
{
	int xStart, yStart, xEnd, yEnd;
	NodeToXY( nodeStart, &xStart, &yStart );
	NodeToXY( nodeEnd, &xEnd, &yEnd );
	
	/* Compute the minimum path cost using distance measurement. It is possible
	 to compute the exact minimum path using the fact that you can move only 
	 on a straight line or on a diagonal, and this will yield a better result.
	 */
	int dx = xStart - xEnd;
	int dy = yStart - yEnd;
	return (float) sqrt( (double)(dx*dx) + (double)(dy*dy) );
}

void Map::AdjacentCost( void* node, std::vector<StateCost> *neighbors ) 
{
	int x, y;

	//const int dx[8] = { 1, 1, 0, -1, -1, -1,  0,  1 };
	//const int dy[8] = { 0, 1, 1,  1,  0, -1, -1, -1 };
	
	const int dx[4] = { 1, 0, -1,  0 };
	const int dy[4] = { 0, 1,  0, -1 };
	
	const float cost[8] = { 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f };
	//const float cost[8] = { 1.0f, 1.41f, 1.0f, 1.41f, 1.0f, 1.41f, 1.0f, 1.41f };
	//const float cost[8] = { 3.0f, 2.0f, 3.0f, 2.0f, 3.0f, 2.0f, 3.0f, 2.0f };

	NodeToXY( node, &x, &y );
	
	for( int i=0; i<4; ++i ) {
		int nx = x + dx[i];
		int ny = y + dy[i];
		
		int pass = Passable( nx, ny );
		if (pass > 0) {
			StateCost nodeCost = { XYToNode(nx, ny), cost[i]};
			neighbors->push_back(nodeCost);
		} else {
		}
	}
}

void Map::PrintStateInfo( void* node ) 
{
	int x, y;
	NodeToXY( node, &x, &y );
	printf( "(%d,%d)", x, y );
}

int Map::Passable( int nx, int ny ) 
{
	if (nx >= 0 && nx < 24 && ny >= 0 && ny < 32)
	{
		int gid = [layer tileGIDAt:ccp(nx, ny)];
		return gid == 0;
	}
	return 0;
}