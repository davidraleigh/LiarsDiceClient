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

- (IBAction)startGameButton:(id)sender
{
    GameSetupViewController_iPhone *gsvc = [[GameSetupViewController_iPhone alloc] init];
    [[self navigationController] pushViewController:gsvc animated:YES];
}
@end
