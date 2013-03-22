//
//  PlayersShowDiceViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/1/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "PlayersShowDiceViewController_iPhone.h"

#import "SummarizeRoundViewController_iPhone.h"
#include <LiarsDiceEngine.h>

@interface PlayersShowDiceViewController_iPhone ()

@end

@implementation PlayersShowDiceViewController_iPhone

- (id)initWithLiarsDice:(std::shared_ptr<LiarsDiceEngine>)liarsDiceEngine
{
    self = [super initWithNibName:@"PlayersShowDiceViewController_iPhone" bundle:nil];
    if (self)
    {
        liarsDice = liarsDiceEngine;
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
