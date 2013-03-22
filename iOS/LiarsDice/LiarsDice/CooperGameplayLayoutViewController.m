//
//  CooperGameplayLayoutViewController.m
//  LiarsDice
//
//  Created by Cooper Buckingham on 3/22/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "CooperGameplayLayoutViewController.h"

@interface CooperGameplayLayoutViewController ()

@end

@implementation CooperGameplayLayoutViewController

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

- (IBAction)backButton:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
