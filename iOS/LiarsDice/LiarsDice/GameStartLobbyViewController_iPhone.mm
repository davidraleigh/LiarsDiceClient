//
//  GameStartLobbyViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/4/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "GameStartLobbyViewController_iPhone.h"

#import "RollForFirstPlayViewController_iPhone.h"
#import "StringConversion.h"

@interface GameStartLobbyViewController_iPhone ()

@end

@implementation GameStartLobbyViewController_iPhone
@synthesize isWild;
@synthesize diceCount;
@synthesize wildSeed;

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
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:@"wildSeed"] == nil)
        [wildSeedTextField setText:@"1977"];
    else
        [wildSeedTextField setText:[ud objectForKey:@"wildSeed"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rollForFirstPlayButton:(id)sender
{
    if (![[wildSeedTextField text] isInteger])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Edit Error" message:@"You cannot have a seed that is not an Integer. Edit seed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [wildSeedTextField setText:@""];
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[wildSeedTextField text] forKey:@"wildSeed"];
    
    wildSeed = [[wildSeedTextField text] intValue];
    
    RollForFirstPlayViewController_iPhone *rffpvc = [[RollForFirstPlayViewController_iPhone alloc] init];
    [[self navigationController] pushViewController:rffpvc animated:YES];

    
}
@end
