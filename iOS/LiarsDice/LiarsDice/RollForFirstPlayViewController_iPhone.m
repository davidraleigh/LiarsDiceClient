//
//  RollForFirstPlayViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/1/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "RollForFirstPlayViewController_iPhone.h"

#import "RoundPlayViewController_iPhone.h"

@interface RollForFirstPlayViewController_iPhone ()

@end

@implementation RollForFirstPlayViewController_iPhone

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

- (IBAction)rollDiceButton:(id)sender
{
    RoundPlayViewController_iPhone *rpvc = [[RoundPlayViewController_iPhone alloc] init];
    [[self navigationController] pushViewController:rpvc animated:YES];
}
@end
