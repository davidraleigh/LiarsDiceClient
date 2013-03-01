//
//  GameStartLobbyViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/4/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "GameStartLobbyViewController_iPhone.h"

#import "RollForFirstPlayViewController_iPhone.h"
#import "StringConversion.h"
#include <LiarsDiceEngine.h>
#include <GamePlayers.h>

@interface GameStartLobbyViewController_iPhone ()

@end

@implementation GameStartLobbyViewController_iPhone
@synthesize isWild;
@synthesize diceCount;
@synthesize wildSeed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (IBAction)rollForFirstPlayButton:(id)sender
{
    if (![[wildSeedTextField text] isInteger])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit Error" message:@"You cannot have a seed that is not an Integer. Edit seed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [wildSeedTextField setText:@""];
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[wildSeedTextField text] forKey:@"wildSeed"];
    
    wildSeed = [[wildSeedTextField text] intValue];
    //(int numberOfDicePerPlayer, bool bOnesWild, unsigned int seed)
    std::shared_ptr<LiarsDiceEngine> liarsDice = std::make_shared<LiarsDiceEngine>(diceCount, isWild, wildSeed);
    
    RollForFirstPlayViewController_iPhone *rffpvc = [[RollForFirstPlayViewController_iPhone alloc] init];
    [rffpvc setLiarsDiceGame:liarsDice];
    [[self navigationController] pushViewController:rffpvc animated:YES];
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return GamePlayers::getInstance().PlayerCount();;
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
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:@"wildSeed"] == nil)
        [wildSeedTextField setText:@"1977"];
    else
        [wildSeedTextField setText:[ud objectForKey:@"wildSeed"]];
    
    NSString *textView = [[NSString alloc] initWithFormat:@"Number of Dice:  %d\nOnes are wild:  %@", diceCount, (isWild ? @"YES" : @"NO")];
    
    [gameDetailsTextView setText:textView];
}
@end
