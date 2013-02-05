//
//  StartViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/1/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "StartViewController_iPhone.h" 

#import "LiarsDiceLobbyViewController_iPhone.h"
#import "SetUserNameViewController_iPhone.h"

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

- (IBAction)onlineGameButton:(id)sender
{
    LiarsDiceLobbyViewController_iPhone *ldlvc = [[LiarsDiceLobbyViewController_iPhone alloc] init];
    [[self navigationController] pushViewController:ldlvc animated:YES];
}

- (IBAction)settingsButton:(id)sender
{
    SetUserNameViewController_iPhone *sunvc = [[SetUserNameViewController_iPhone alloc] init];
    [[self navigationController] pushViewController:sunvc animated:YES];
}
@end
