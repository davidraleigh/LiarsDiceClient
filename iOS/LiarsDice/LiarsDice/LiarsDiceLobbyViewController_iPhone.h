//
//  LiarsDiceLobbyViewController_iPhone.h
//  LiarsDice
//
//  Created by David Raleigh on 2/4/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "LiarsDiceLobbyViewController.h"


#include <PlayersInLobby.h>
#include <string>
#include <deque>
#include <vector>

@interface LiarsDiceLobbyViewController_iPhone : LiarsDiceLobbyViewController <UITextFieldDelegate>
{
    unsigned int clientPlayerUID;
    NSString *clientPlayerName;
    unsigned int currentGroupUID;
    std::string playerTextField;
    
    __weak IBOutlet UITableView *groupPlayersTable;
    __weak IBOutlet UITableView *availablePlayersTable;
   
    __weak IBOutlet UITextField *availablePlayersTextField;
    
    __weak IBOutlet UIButton *editGroupButtonText;
    __weak IBOutlet UIButton *sortByButtonText;
    PlayersInLobby::SortType sortByKey;
}

- (IBAction)startGameButton:(id)sender;
- (IBAction)sortyByButton:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)editGroupButton:(id)sender;
- (IBAction)invitePlayer:(id)sender;
- (IBAction)playerTextFieldChanged:(id)sender;

+ (NSMutableArray *)indexPathesToRemove:(std::deque<int>) indicesToRemove;

@end
