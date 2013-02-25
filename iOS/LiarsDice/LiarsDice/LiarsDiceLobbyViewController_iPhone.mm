//
//  LiarsDiceLobbyViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/4/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "LiarsDiceLobbyViewController_iPhone.h"

#import "GameSetupViewController_iPhone.h"

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
