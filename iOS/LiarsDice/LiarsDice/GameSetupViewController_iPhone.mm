//
//  GameSetupViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/4/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "GameSetupViewController_iPhone.h"

#import "GameStartLobbyViewController_iPhone.h"
#import "StringConversion.h"
#include <Player.h>
#include <GamePlayers.h>

@interface GameSetupViewController_iPhone ()

@end

@implementation GameSetupViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundTapped:(id)sender
{
    [[self view] endEditing:YES];
}

- (IBAction)editGroupOrderButton:(id)sender
{
//    // if the button is the Leave Group button
//    if (clientPlayerUID != currentGroupUID)
//    {
//        // move the client to the last position
//        int clientPlayerPosition = GamePlayers::getInstance().GetPlayerPosition(clientPlayerUID);
//        int lastPosition = GamePlayers::getInstance().PlayerCount() - 1;
//        NSIndexPath *clientIndexPath = [NSIndexPath indexPathForRow:clientPlayerPosition inSection:0];
//        NSIndexPath *destinationIndexPath = [NSIndexPath indexPathForRow:lastPosition inSection:0];
//        [gamePlayersTable moveRowAtIndexPath:clientIndexPath toIndexPath:destinationIndexPath];
//        
//        // Delete all the contents of Game Players except for
//        // the client
//        
//        for (int position = lastPosition - 1; position >= 0; position--)
//        {
//            NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForRow:position inSection:0];
//            GamePlayers::getInstance().DeletePlayerAtPosition(position);
//            [gamePlayersTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:deleteIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }
//        
//        [sender setTitle:@"Edit Group" forState:UIControlStateNormal];
//        [gamePlayersTable setEditing:NO animated:YES];
//        
//        return;
//    }
    
    if ([groupSortTableView isEditing])
    {
        [sender setTitle:@"Edit Group" forState:UIControlStateNormal];
        
        
        [groupSortTableView setEditing:NO animated:YES];
    }
    else
    {
//        if (GamePlayers::getInstance().PlayerCount() == 1)
//        {
//            [messageBoxTextView setText:@"Can't edit if only 1 player"];
//            return;
//        }
        
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        
        [groupSortTableView setEditing:YES animated:YES];
    }
}


- (IBAction)invitePlayersButton:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)startGameButton:(id)sender
{
    if (![[numberOfDiceTextField text] isInteger])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit Error" message:@"You cannot have a number of dice that is not an Integer. Edit field." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [numberOfDiceTextField setText:@""];
        return;
    }
    
    GameStartLobbyViewController_iPhone *gslvc = [[GameStartLobbyViewController_iPhone alloc] init];

    gslvc.diceCount = [[numberOfDiceTextField text] intValue];
    gslvc.isWild = segmentedControl.selectedSegmentIndex == 0;
    
    [[self navigationController] pushViewController:gslvc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    // if there is no reusable cell of this type create a new one
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    GamePlayers::getInstance().MovePlayer([sourceIndexPath row], [destinationIndexPath row]);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return GamePlayers::getInstance().PlayerCount();;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([numberOfDiceTextField isEditing])
        [numberOfDiceTextField resignFirstResponder];
    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
