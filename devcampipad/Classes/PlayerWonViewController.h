//
//  PlayerWonViewController.h
//  devcampipad
//
//  Created by Brad Smith on 7/22/12.
//  Copyright (c) 2012 Focal Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerWonViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIImageView *winnerimageView;
@property (retain, nonatomic) IBOutlet UIImageView *loser1ImageView;
@property (retain, nonatomic) IBOutlet UIImageView *loser2ImageView;
@property (retain, nonatomic) IBOutlet UIImageView *loser3ImageView;
@property (retain, nonatomic) IBOutlet UILabel *winnerLabel;
@property (retain, nonatomic) IBOutlet UILabel *loser1Label;
@property (retain, nonatomic) IBOutlet UILabel *loser2Label;
@property (retain, nonatomic) IBOutlet UILabel *loser3Label;
@end
