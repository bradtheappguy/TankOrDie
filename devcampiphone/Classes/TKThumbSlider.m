//
//  TKThumbSlider.m
//  devcampiphone
//
//  Created by Brad Smith on 4/17/10.
//  Copyright 2010 Clixtr. All rights reserved.
//

#import "TKThumbSlider.h"


@implementation TKThumbSlider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
	CGRect superrect = [super thumbRectForBounds:bounds trackRect:rect value:value];
	return CGRectMake(superrect.origin.x-25, superrect.origin.y, superrect.size.width+50, superrect.size.height);
}

@end
