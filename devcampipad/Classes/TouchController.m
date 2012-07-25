//
//  TouchController.m
//  devcampipad
//
//  Created by Jon Bardin on 4/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TouchController.h"


@implementation TouchController


@synthesize lastTouchedPoint;


-(id)init {
	if (self = [super init]) {
		[self setView:[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 768.0, 1024.0)]];
		[self.view setUserInteractionEnabled:YES];
		
	}
	
	return self;
}				


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	lastTouchedPoint = [[touches anyObject] locationInView:[[self view] superview]];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {	
	lastTouchedPoint = [[touches anyObject] locationInView:[[self view] superview]];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	lastTouchedPoint = [[touches anyObject] locationInView:[[self view] superview]];
}


@end