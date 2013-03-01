//
//  GameStartLobbyViewController_iPhone.h
//  LiarsDice
//
//  Created by David Raleigh on 2/4/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "GameStartLobbyViewController.h"

@interface GameStartLobbyViewController_iPhone : GameStartLobbyViewController
{
    __weak IBOutlet UITextField *wildSeedTextField;
    
}
@property (readwrite)int diceCount;
@property (readwrite)bool isWild;
@property (readwrite)int wildSeed;

- (IBAction)rollForFirstPlayButton:(id)sender;

@end
