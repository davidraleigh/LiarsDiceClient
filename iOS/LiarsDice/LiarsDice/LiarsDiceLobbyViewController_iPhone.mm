//
//  LiarsDiceLobbyViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/4/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "LiarsDiceLobbyViewController_iPhone.h"

#import "GameSetupViewController_iPhone.h"
#import "StringConversion.h"

#include <GamePlayers.h>
#include <PlayersInLobby.h>
#include <json/json.h>

#define TABLE_VIEW_AVAILABLE_PLAYERS_TAG 36

@interface LiarsDiceLobbyViewController_iPhone ()

@end

@implementation LiarsDiceLobbyViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sortByKey = PlayersInLobby::Distance;
        PlayersInLobby::getInstance().SetSortType(sortByKey);
    }
    return self;
}

- (IBAction)backgroundTapped:(id)sender
{
    [[self view] endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editGroupButton:(id)sender
{
    if ([groupPlayersTable isEditing])
    {
        [sender setTitle:@"Edit Group" forState:UIControlStateNormal];
        
        
        [groupPlayersTable setEditing:NO animated:YES];
    }
    else
    {
        if (GamePlayers::getInstance().PlayerCount() == 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Error" message:@"You cannot remove yourself from the group" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        
        [groupPlayersTable setEditing:YES animated:YES];
    }
}

+ (NSMutableArray *)indexPathesToRemove:(std::deque<int>)indicesToRemove
{
    NSMutableArray *indexPathes = [[NSMutableArray alloc] init];
    std::deque<int>::iterator iter;
    for (iter = indicesToRemove.begin(); iter != indicesToRemove.end(); iter++)
        [indexPathes addObject:[NSIndexPath indexPathForRow:(*iter) inSection:0]];

    return indexPathes;
}

- (IBAction)invitePlayer:(id)sender
{
    NSIndexPath *selectedIndex = [availablePlayersTable indexPathForSelectedRow];
    if (selectedIndex == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit Group Error" message:@"You need to select a player from the left column to invite" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    PlayersInLobby::player_t playerDetails = PlayersInLobby::getInstance().GetPlayerAtPosition([selectedIndex row]);
    
    
//    PlayersInLobby::getInstance().DeletePlayerAtPosition([selectedIndex row]);
//    
//    [availablePlayersTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndex] withRowAnimation:UITableViewRowAnimationFade];
    
    if (GamePlayers::getInstance().ContainsPlayer(playerDetails.playerUID) ||
        GamePlayers::getInstance().ContainsPlayer(playerDetails.playerName))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invite Error" message:@"You have already invited this player" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //!!!!!!
    //TODO THIS IS A TEST SETUP.  AS
    // LONG AS THIS IS A TEST SETUP
    // THEN AI WILL BE USED FOR ALL PLAYERS
    // THAT ARE ADDED TO THE GAME
    //!!!!!!
    bool success = GamePlayers::getInstance().AddPlayer(playerDetails.playerName, playerDetails.playerUID, false, true);
    if (!success)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invite Error" message:@"big error in invitePlayer" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    int lastRow = GamePlayers::getInstance().GetPlayerPosition(playerDetails.playerUID);
    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    // insert this new row into the table
    [groupPlayersTable insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
}

- (IBAction)playerTextFieldChanged:(id)sender
{
    // get the appropriate TableView
    UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLE_VIEW_AVAILABLE_PLAYERS_TAG];
    
    NSString *textField = [availablePlayersTextField text];
    std::string userText = [textField getstringTrimmed];
    
    // user text is longer than before
    // remove more of the 'available players'
    // check that the first few letters are the same
    if (userText.size() > playerTextField.size() && userText.compare(0, playerTextField.size(), playerTextField) == 0)
    {
        std::deque<int> indexStack = PlayersInLobby::getInstance().HidePlayers(userText);
        
        [tableView deleteRowsAtIndexPaths:[LiarsDiceLobbyViewController_iPhone indexPathesToRemove:indexStack] withRowAnimation:UITableViewRowAnimationFade];
        
        PlayersInLobby::getInstance().Sort();
        [tableView reloadData];
    }
    else if (userText.size() < playerTextField.size() && playerTextField.compare(0, userText.size(), userText) == 0)
    {
        std::deque<int> indexVector = PlayersInLobby::getInstance().RevealPlayers(userText);
        
        [tableView insertRowsAtIndexPaths:[LiarsDiceLobbyViewController_iPhone indexPathesToRemove:indexVector] withRowAnimation:UITableViewRowAnimationTop];
        
        PlayersInLobby::getInstance().Sort();
        [tableView reloadData];
    }
    else if (playerTextField.compare(userText) != 0)
    {
        std::deque<int> indexVector = PlayersInLobby::getInstance().RevealPlayers(userText);
        
        [tableView insertRowsAtIndexPaths:[LiarsDiceLobbyViewController_iPhone indexPathesToRemove:indexVector] withRowAnimation:UITableViewRowAnimationTop];
        
        std::deque<int> indexStack = PlayersInLobby::getInstance().HidePlayers(userText);
        
        [tableView deleteRowsAtIndexPaths:[LiarsDiceLobbyViewController_iPhone indexPathesToRemove:indexStack] withRowAnimation:UITableViewRowAnimationFade];
        
        PlayersInLobby::getInstance().Sort();
        [tableView reloadData];
    }
    
    playerTextField = userText;
    
    // user text is shorter than before
    // add more to the 'available players'
    // check that the first few letters are the same
}



- (IBAction)sortyByButton:(id)sender
{
    PlayersInLobby::getInstance().SetSortType(sortByKey);
    PlayersInLobby::getInstance().Sort();
    // get the appropriate TableView
    UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLE_VIEW_AVAILABLE_PLAYERS_TAG];
    [tableView reloadData];
    if (sortByKey == PlayersInLobby::Distance)
    {
//        [sender setTitle:@"By Familiarity" forState:UIControlStateNormal];
//        sortByKey = PlayersInLobby::Familiarity;
//    }
//    else if (sortByKey == PlayersInLobby::Familiarity)
//    {
        [sender setTitle:@"By 1st Name" forState:UIControlStateNormal];
        sortByKey = PlayersInLobby::FirstName;
    }
    else if (sortByKey == PlayersInLobby::FirstName)
    {
        [sender setTitle:@"By Last Name" forState:UIControlStateNormal];
        sortByKey = PlayersInLobby::LastName;
    }
    else if (sortByKey == PlayersInLobby::LastName)
    {
        [sender setTitle:@"By Distance" forState:UIControlStateNormal];
        sortByKey = PlayersInLobby::Distance;
    }
}

- (IBAction)startGameButton:(id)sender
{
    GameSetupViewController_iPhone *gsvc = [[GameSetupViewController_iPhone alloc] init];
    [[self navigationController] pushViewController:gsvc animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // if the table view is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete && [tableView tag] == 37)
    {
        // if player is "Me" then don't delete
        
        
        // remove from game players singleton
        GamePlayers::getInstance().DeletePlayerAtPosition([indexPath row]);
        
        // also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView tag] == 36)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        // if there is no reusable cell of this type create a new one
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        }
        
        PlayersInLobby::player_t playerDetails = PlayersInLobby::getInstance().GetPlayerAtPosition([indexPath row]);
        NSString *playerName = [NSString stringWithstring:playerDetails.playerName];
        [[cell textLabel] setText:playerName];
        
        NSString *details = [[NSString alloc] initWithFormat:@"Group #:%d", playerDetails.groupUID];
        if (playerDetails.bIsGroupLeader)
            details = [[NSString alloc] initWithFormat:@"%@ Leader", details];
        else
            details = [[NSString alloc] initWithFormat:@"%@ Member", details];
        
        [[cell detailTextLabel] setText:details];
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        // if there is no reusable cell of this type create a new one
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        }
        
        Player *player = GamePlayers::getInstance().GetPlayerAtPosition([indexPath row]);
        NSString *playerName = [NSString stringWithstring:player->GetPlayerName()];
        [[cell textLabel] setText:playerName];
        
        // TESTING
        unsigned int playerUID = player->GetPlayerUID();
        short playerPosition = GamePlayers::getInstance().GetPlayerPosition(playerUID);
        NSString *details = [[NSString alloc] initWithFormat:@"Player #%d, UID = %d", playerPosition + 1, playerUID];
        [[cell detailTextLabel] setText:details];
        // TESTING
        
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView tag] == 36)
    {
        return PlayersInLobby::getInstance().Size();
    }
    else
    {
        return GamePlayers::getInstance().PlayerCount();;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (GamePlayers::getInstance().PlayerCount() > 1)
    {
        [groupPlayersTable reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    clientPlayerName = [ud objectForKey:@"playerName"];
    clientPlayerUID = [[ud objectForKey:@"playerUID"] unsignedIntValue];
    
    currentGroupUID = clientPlayerUID;
    Json::Value availablePlayers;
    
    // only for testing
    PlayersInLobby::getInstance()._GenerateLobbyPlayers(availablePlayers);
    // Query remote database for available players
    
    // TODO query location
    double latitude = 30;
    double longitude = 30;
    
    // put the available players in the lobby
    PlayersInLobby::getInstance().InitializePlayers(availablePlayers, clientPlayerUID, latitude, longitude);
    // add the deviced owner to the player list
    GamePlayers::getInstance().AddPlayer([clientPlayerName getstring], clientPlayerUID, true, false);
    // Set the device owner as his own group leader
    GamePlayers::getInstance().SetGroupLeader(clientPlayerUID);
    
    playerTextField = "";
}


@end
