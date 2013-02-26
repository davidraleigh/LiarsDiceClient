//
//  LiarsDiceLobbyViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/4/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "LiarsDiceLobbyViewController_iPhone.h"

#import "GameSetupViewController_iPhone.h"

#include <GamePlayers.h>
#include <PlayersInLobby.h>


@interface LiarsDiceLobbyViewController_iPhone ()

@end

@implementation LiarsDiceLobbyViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sortByKey = 0;
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invite Error" message:@"You need to select a player from the left column to invite" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        
        [groupPlayersTable setEditing:YES animated:YES];
    }
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
    
    
    PlayersInLobby::getInstance().DeletePlayerAtPosition([selectedIndex row]);
    
    [availablePlayersTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:selectedIndex] withRowAnimation:UITableViewRowAnimationFade];
    
    if (GamePlayers::getInstance().ContainsPlayer(playerDetails.playerUID) ||
        GamePlayers::getInstance().ContainsPlayer(playerDetails.playerName))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invite Error" message:@"big error in invitePlayer" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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

- (IBAction)sortyByButton:(id)sender
{
    if (sortByKey == 0)
    {
        [sender setTitle:@"By Familiarity" forState:UIControlStateNormal];
        sortByKey = 1;
    }
    else if (sortByKey == 1)
    {
        [sender setTitle:@"By Name" forState:UIControlStateNormal];
        sortByKey = 2;
    }
    else if (sortByKey == 2)
    {
        [sender setTitle:@"By Distance" forState:UIControlStateNormal];
        sortByKey = 0;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


@end
