//
//  TouchController.h
//  devcampipad
//
//  Created by Jon Bardin on 4/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TouchController : UIViewController {
	
	CGPoint lastTouchedPoint;
	
}


@property CGPoint lastTouchedPoint;


@end