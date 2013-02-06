//
//  GeneralSettingsViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/6/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "GeneralSettingsViewController_iPhone.h"

#import "SetUserNameViewController_iPhone.h"
@interface GeneralSettingsViewController_iPhone ()

@end

@implementation GeneralSettingsViewController_iPhone

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

- (IBAction)setUserNameButton:(id)sender
{
    SetUserNameViewController_iPhone *sunvc = [[SetUserNameViewController_iPhone alloc] init];
    [[self navigationController] pushViewController:sunvc animated:YES];
}

- (IBAction)returnToMainButton:(id)sender
{
    [[self navigationController] popToRootViewControllerAnimated:YES];
}
@end
