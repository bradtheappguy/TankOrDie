//
//  ScoreBoardView.m
//  devcampipad
//
//  Created by Brad Smith on 7/21/12.
//  Copyright (c) 2012 Focal Labs. All rights reserved.
//

#import "ScoreBoardView.h"
#import "Player.h"
#import "GameServer.h"

@implementation ScoreBoardView

-(void) awakeFromNib {
  [super awakeFromNib];
  player1View.backgroundColor = [UIColor redColor];
  player2View.backgroundColor = [UIColor blueColor];
  player3View.backgroundColor = [UIColor greenColor];
  player4View.backgroundColor = [UIColor orangeColor];
  
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYER_WAS_HIT" object:player];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYER_SCORED" object:bullet.player];

  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerScored:) name:@"PLAYER_SCORED" object:nil];

}


-(void) playerScored:(NSNotification *)b {
  NSArray *players = [[GameServer sharedInstance] connectedPeers];
  
  if (players.count > 0) {
    Player *player = [players objectAtIndex:0];
    NSLog(@"P1 Score: %d",player.score);
  }
  if (players.count > 1) {
    Player *player = [players objectAtIndex:1];
    NSLog(@"P2 Score: %d",player.score);
  }
  if (players.count > 2) {
    
    Player *player = [players objectAtIndex:2];
    NSLog(@"P3 Score: %d",player.score);
  }
  if (players.count > 3) {
    
    Player *player = [players objectAtIndex:3];
    NSLog(@"P4 Score: %d",player.score);
  }
}

@end
