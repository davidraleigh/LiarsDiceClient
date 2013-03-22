//
//  SetUserNameViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/1/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "SetUserNameViewController_iPhone.h"

#import "StartViewController_iPhone.h"
#import "StringConversion.h"
#include <HttpClient.h>

@interface SetUserNameViewController_iPhone ()

@end

@implementation SetUserNameViewController_iPhone

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

- (IBAction)usernameTextFieldChanged:(id)sender
{
    if ([[usernameTextField text] length] <= 2)
        [userFeedbackImageView setImage:[UIImage imageNamed:@"GrayCircle.png"]];
    else if (HttpClient::PlayerNameIsAvailble([[usernameTextField text] getstringTrimmed]))
        [userFeedbackImageView setImage:[UIImage imageNamed:@"GreenCheck.png"]];
    else
        [userFeedbackImageView setImage:[UIImage imageNamed:@"redx.png"]];
}

- (IBAction)saveUsernameButton:(id)sender
{
    if ([[usernameTextField text] length] <= 2 ||
        !HttpClient::PlayerNameIsAvailble([[usernameTextField text] getstringTrimmed]))
    {
        [userFeedbackImageView setImage:[UIImage imageNamed:@"redx.png"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name Change" message:@"The name you have chosen is too short or needs to be composed of more than 2 characters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    [usernameTextField resignFirstResponder];
    NSString *newPlayerName = [[usernameTextField text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setObject:newPlayerName forKey:@"playerName"];
    [ud setObject:[[NSNumber alloc] initWithUnsignedInt:1977] forKey:@"playerUID"];
}

- (IBAction)mainMenuButton:(id)sender
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (([ud objectForKey:@"playerName"] == nil) || (![[usernameTextField text] isEqualToString:[ud objectForKey:@"playerName"]]))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Name Change" message:@"Your name change was not updated." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:@"playerName"] == nil)
        return;
    
    [usernameTextField setText:[ud objectForKey:@"playerName"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
@end
