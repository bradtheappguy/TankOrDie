//
//  StartTankViewController.h
//  devcampipad
//
//  Created by Bess Ho on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartTankViewController : UIViewController {
    IBOutlet UIButton *newgameButton;
    IBOutlet UIButton *joinButton;  
}

@property (nonatomic, retain) IBOutlet UIButton *newgameButton;
@property (nonatomic, retain) IBOutlet UIButton *joinButton;

- (IBAction) newgameButton:(id) sender;
- (IBAction) joinButton:(id) sender;

@end
