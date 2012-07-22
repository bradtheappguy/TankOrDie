//
//  GameHostViewControllerViewController.h
//  devcampipad
//
//  Created by Brad Smith on 7/21/12.
//  Copyright (c) 2012 Focal Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameHostViewControllerViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *player1ImageView;
@property (retain, nonatomic) IBOutlet UIImageView *player2ImageView;
@property (retain, nonatomic) IBOutlet UIImageView *player3ImageView;
@property (retain, nonatomic) IBOutlet UIImageView *player4ImageView;

@property (retain, nonatomic) IBOutlet UILabel *player1NameLabel;
@property (retain, nonatomic) IBOutlet UILabel *player2NameLabel;
@property (retain, nonatomic) IBOutlet UILabel *player3NameLabel;
@property (retain, nonatomic) IBOutlet UILabel *player4NameLabel;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)startGameButtonPressed:(id)sender;

@end
