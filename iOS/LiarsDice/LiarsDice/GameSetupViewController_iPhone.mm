//
//  GameSetupViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/4/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "GameSetupViewController_iPhone.h"

#import "GameStartLobbyViewController_iPhone.h"

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

- (IBAction)invitePlayersButton:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)startGameButton:(id)sender
{
    GameStartLobbyViewController_iPhone *gslvc = [[GameStartLobbyViewController_iPhone alloc] init];
    [[self navigationController] pushViewController:gslvc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end