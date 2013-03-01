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
    __weak IBOutlet UITableView *groupSortTableView;
    __weak IBOutlet UIButton *editGroupButtonText;
    __weak IBOutlet UISegmentedControl *segmentedControl;
}

- (IBAction)backgroundTapped:(id)sender;
- (IBAction)editGroupOrderButton:(id)sender;

- (IBAction)invitePlayersButton:(id)sender;
- (IBAction)startGameButton:(id)sender;
@end
