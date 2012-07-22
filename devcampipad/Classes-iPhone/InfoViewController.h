//
//  InfoViewController.h
//  devcampipad
//
//  Created by Bess Ho on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfoViewControllerDelegate;

@interface InfoViewController : UIViewController 
{
    id <InfoViewControllerDelegate> delegate;
}
@property (nonatomic, assign) id <InfoViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;
@end

@protocol InfoViewControllerDelegate
- (void) InfoViewControllerDidFinish:(InfoViewController *)controller;
@end
