//
//  SummarizeRoundViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/1/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "SummarizeRoundViewController_iPhone.h"

#import "RoundPlayViewController_iPhone.h"
#include <LiarsDiceEngine.h>

@interface SummarizeRoundViewController_iPhone ()

@end

@implementation SummarizeRoundViewController_iPhone

- (IBAction)continueGameButton:(id)sender
{
    NSArray *array = [self.navigationController viewControllers];
    
    int rpvc_index = [array count] - 3;
    RoundPlayViewController_iPhone *rpvc = (RoundPlayViewController_iPhone *)[array objectAtIndex:rpvc_index];
    
    [self.navigationController popToViewController:rpvc animated:YES];
}

- (id)initWithLiarsDice:(std::shared_ptr<LiarsDiceEngine>)liarsDiceEngine
{
    self = [super initWithNibName:@"SummarizeRoundViewController_iPhone" bundle:nil];
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

@end
