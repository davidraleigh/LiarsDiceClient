//
//  PlayersShowDiceViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/1/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "PlayersShowDiceViewController_iPhone.h"

#import "SummarizeRoundViewController_iPhone.h"
@interface PlayersShowDiceViewController_iPhone ()

@end

@implementation PlayersShowDiceViewController_iPhone

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

- (IBAction)QAButtonThrowAWayDice:(id)sender
{
    SummarizeRoundViewController_iPhone *srvc = [[SummarizeRoundViewController_iPhone alloc] init];
    [[self navigationController] pushViewController:srvc animated:YES];
}
@end
