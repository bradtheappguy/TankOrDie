//
//  SlaveBoard.h
//  devcampipad
//
//  Created by Brad Smith on 4/17/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BOARD_SIZE_Y 1024
#define BOARD_SIZE_X 768

#define BOARD_NORTH 0
#define BOARD_EAST 1
#define BOARD_SOUTH 2
#define BOARD_WEST 3

// produce -1, 0, 1 * steps, where steps is BOARD_SIZE_X or _Y. 
#define GET_OFFSET_CHANGE(steps,dir,pos,neg) (steps * (0 + (dir == pos ? 1 : 0) - (dir == neg ? 1 : 0)))

// produce a location on the screen for indicator -- possibly temporary defines
#define GET_PORTAL_POS_X(dir) (dir == BOARD_EAST ? BOARD_SIZE_X-50 : 50)
#define GET_PORTAL_POS_Y(dir) (dir == BOARD_SOUTH ? BOARD_SIZE_Y-50 : 50)

// get opposite direction integer
#define OPP(dir) (dir-2<0?dir+2:dir-2)

@interface SlaveBoard : NSObject {
	NSString *peerID;
	int xoffs, yoffs;
	NSMutableArray *neighbors;
}

-(SlaveBoard *)connectionAt:(int)dir;
-(id) initWithPeerId:(NSString *)peer;
-(void) setXOffset: (int)_xoffs YOffset:(int)_yoffs;
-(void) attachBoard: (SlaveBoard *)other inDirection: (int)dir;

@property (nonatomic, retain) NSString *peerID;
@property (nonatomic, retain) NSMutableArray *neighbors;

@end
