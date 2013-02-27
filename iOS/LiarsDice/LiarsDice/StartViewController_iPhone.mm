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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
@end
