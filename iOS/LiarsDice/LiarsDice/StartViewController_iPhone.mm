//
//  StartViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/1/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "StartViewController_iPhone.h" 

#import "LiarsDiceLobbyViewController_iPhone.h"
#import "GeneralSettingsViewController_iPhone.h"
#import "CooperGameplayLayoutViewController.h"
#import "RoundPlayViewController_iPhone.h"

#include <LiarsDiceEngine.h>
#include <GamePlayers.h>
#include <memory>
@interface StartViewController_iPhone ()

@end

@implementation StartViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onlineGameButton:(id)sender
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:@"playerName"] == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Online Profile" message:@"You can't play an online game until you've setup your profile in the settings." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    LiarsDiceLobbyViewController_iPhone *ldlvc = [[LiarsDiceLobbyViewController_iPhone alloc] init];
    [[self navigationController] pushViewController:ldlvc animated:YES];
}

- (IBAction)settingsButton:(id)sender
{
    GeneralSettingsViewController_iPhone *gsvc = [[GeneralSettingsViewController_iPhone alloc] init];
    [[self navigationController] pushViewController:gsvc animated:YES];
}

- (IBAction)cooperButton:(id)sender
{
    CooperGameplayLayoutViewController *cglvc = [[CooperGameplayLayoutViewController alloc] init];
    [[self navigationController] pushViewController:cglvc animated:YES];
}

- (IBAction)roundPlayButton:(id)sender
{
    GamePlayers::getInstance().AddPlayer("David", 1911, true, false);
    GamePlayers::getInstance().AddPlayer("Bob", 1922, false, true);
    GamePlayers::getInstance().AddPlayer("Chief Wiggum", 1933, false, true);
    GamePlayers::getInstance().AddPlayer("Spartacus", 1944, false, true);
    std::shared_ptr<LiarsDiceEngine> liarsDice = std::make_shared<LiarsDiceEngine>(5, true, 1977);
    RoundPlayViewController_iPhone *rpvc = [[RoundPlayViewController_iPhone alloc] initWithLiarsDice:liarsDice];
    [[self navigationController] pushViewController:rpvc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
@end
