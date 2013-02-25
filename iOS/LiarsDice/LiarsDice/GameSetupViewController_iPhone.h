//
//  GameSetupViewController_iPhone.h
//  LiarsDice
//
//  Created by David Raleigh on 2/4/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "GameSetupViewController.h"

@interface GameSetupViewController_iPhone : GameSetupViewController <UITextFieldDelegate>
{
    __weak IBOutlet UITextField *numberOfDiceTextField;
    
}
- (IBAction)backgroundTapped:(id)sender;

- (IBAction)invitePlayersButton:(id)sender;
- (IBAction)startGameButton:(id)sender;
@end
