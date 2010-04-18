//
//  TXSlider.m
//  devcampiphone
//
//  Created by Brad Smith on 4/17/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import "TXSlider.h"


@implementation TXSlider

-(void) drawRect:(CGRect)rect {
	[super drawRect:rect];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"");
}

//min 220
//max 120

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	CGPoint previousLocation = [[touches anyObject] previousLocationInView:[self superview]];
	CGPoint newLocation = [[touches anyObject] locationInView:[self superview]];
	float newY = self.center.y-(previousLocation.y-newLocation.y);
	if (newY > 220) {
		newY = 220;
	}else if (newY < 120) {
		newY = 120;
	}
	self.center = CGPointMake(self.center.x, newY);
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"%f  <-----",self.center.y);	
}

-(float) value {
	return 1 - ((self.center.y-120) / 100); 
}






@end
