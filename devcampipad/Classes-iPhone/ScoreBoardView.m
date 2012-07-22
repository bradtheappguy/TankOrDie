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

static CGFloat miny = 0;
static CGFloat maxy;
-(void) awakeFromNib {
  [super awakeFromNib];
  player1View.backgroundColor = [UIColor clearColor];
  player2View.backgroundColor = [UIColor clearColor];
  player3View.backgroundColor = [UIColor clearColor];
  player4View.backgroundColor = [UIColor clearColor];
  
  
  
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYER_WAS_HIT" object:player];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYER_SCORED" object:bullet.player];

  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerScored:) name:@"PLAYER_SCORED" object:nil];
  maxy = player1View.frame.origin.y;
}


-(void) playerScored:(NSNotification *)b {
  [UIView beginAnimations:nil context:nil];
  NSArray *players = [[GameServer sharedInstance] connectedPeers];
  player1View.hidden = YES;
  player2View.hidden = YES;
  player3View.hidden = YES;
  player4View.hidden = YES;
  
  
  if (players.count > 0) {
    player1View.hidden = NO;
    Player *player = [players objectAtIndex:0];
    player1View.image = player.image;
    NSLog(@"P1 Score: %d",player.score);
    
    CGFloat ww =  maxy - (player.score * 12);
    player1View.frame = CGRectMake(player1View.frame.origin.x,ww,player1View.frame.size.width,player1View.frame.size.height);
    NSLog(@"%f",ww);
    if (player.score > 20 && ww < 25) {
      [self playerWon:player];
    }
  }
  if (players.count > 1) {
    
    player2View.hidden = NO;
    Player *player = [players objectAtIndex:1];
    player2View.image = player.image;
    NSLog(@"P2 Score: %d",player.score);
    
    CGFloat ww =  maxy - (player.score * 12);
    player2View.frame = CGRectMake(player2View.frame.origin.x,ww,player2View.frame.size.width,player2View.frame.size.height);
    NSLog(@"%f",ww);
    
    if (player.score > 20 && ww < 25) {
      [self playerWon:player];
    }
  }
  if (players.count > 2) {
    
    player3View.hidden = NO;
    Player *player = [players objectAtIndex:2];
    player3View.image = player.image;
    NSLog(@"P3 Score: %d",player.score);
    
    CGFloat ww =  maxy - (player.score * 12);
    player3View.frame = CGRectMake(player3View.frame.origin.x,ww,player3View.frame.size.width,player3View.frame.size.height);
    NSLog(@"%f",ww);
    
    if (player.score > 20 && ww < 25) {
      [self playerWon:player];
    }
  }
  if (players.count > 3) {
    
    player4View.hidden = NO;
    Player *player = [players objectAtIndex:3];
    player4View.image = player.image;
    NSLog(@"P4 Score: %d",player.score);
    
    CGFloat ww =  maxy - (player.score * 12);
    player4View.frame = CGRectMake(player4View.frame.origin.x,ww,player4View.frame.size.width,player4View.frame.size.height);
    NSLog(@"%f",ww);
    if (player.score > 20 && ww < 25) {
      [self playerWon:player];
    }
    
  }
  [UIView commitAnimations];
}

-(void) playerWon:(Player *)player {
  [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYER_WON" object:player];
}

@end
