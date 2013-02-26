//
//  LiarsDiceLobbyViewController_iPhone.h
//  LiarsDice
//
//  Created by David Raleigh on 2/4/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "LiarsDiceLobbyViewController.h"

@interface LiarsDiceLobbyViewController_iPhone : LiarsDiceLobbyViewController <UITextFieldDelegate>
{
    __weak IBOutlet UITableView *groupPlayersTable;
    __weak IBOutlet UITableView *availablePlayersTable;
   
    __weak IBOutlet UITextField *availablePlayersTextField;
    
    __weak IBOutlet UIButton *editGroupButtonText;
    __weak IBOutlet UIButton *sortByButtonText;
    int sortByKey;
}

- (IBAction)startGameButton:(id)sender;
- (IBAction)sortyByButton:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)editGroupButton:(id)sender;
- (IBAction)invitePlayer:(id)sender;


@end
