//
//  RollForFirstPlayViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/1/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "RollForFirstPlayViewController_iPhone.h"

#import "RoundPlayViewController_iPhone.h"
#import "ScrollingDiceView.h"
#import "StringConversion.h"

#include <GamePlayers.h>
#include <LiarsDiceEngine.h>

// #DEFINES FOR SCROLLINGDICEVIEW
#define SCROLLING_DICE_VIEW_X_ORIGIN 10
#define CENTER_OF_WINDOW_Y 90
#define DICE_COUNT 7
#define DICE_PIXEL_SEPARATION 2
// #DEFINES FOR SCROLLINGDICEVIEW

@interface RollForFirstPlayViewController_iPhone ()

@end

@implementation RollForFirstPlayViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *uiImage = [UIImage imageNamed:@"LD_DiceScroll_1.png"];
    CGRect frame = CGRectMake(0, CENTER_OF_WINDOW_Y, uiImage.size.width / 2, uiImage.size.height / 2);
    frame.origin.x = SCROLLING_DICE_VIEW_X_ORIGIN + 3 * (frame.size.width + DICE_PIXEL_SEPARATION);
    
    std::map<unsigned int, int> firstRoll = liarsDice->GetRollsForPlayOrder();
    unsigned int clientUID = GamePlayers::getInstance().GetClientUID();
    assert(clientUID != 0);
    assert(firstRoll.count(clientUID) != 0);
    int rollValue = firstRoll[clientUID];
    
    ScrollingDiceView *scrollingDice = [[ScrollingDiceView alloc]initWithFrame:frame andFaceValue:rollValue];
    
    [scrollingDice setImage:uiImage];
    [scrollingDice setTag:1];
    
    maxRollDuration = [scrollingDice getCompleteDuration];
    
    [self.view insertSubview:scrollingDice atIndex:1];
    hasRolledDie = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rollDice
{
    bool allViewsFinished = true;
    
    for (UIView *subview in [self.view subviews])
    {
        if ([subview isKindOfClass:[ScrollingDiceView class]])
        {
            ScrollingDiceView *scrollDice = (ScrollingDiceView *)subview;
            //int dieIndex = [scrollDice tag];
            [scrollDice scroll];
            
            if (![scrollDice isFinished])
                allViewsFinished = false;
        }
    }
    
    std::map<unsigned int, int> firstRoll = liarsDice->GetRollsForPlayOrder();
    unsigned int clientUID = GamePlayers::getInstance().GetClientUID();
    assert(clientUID != 0);
    assert(firstRoll.count(clientUID) != 0);
    int rollValue = firstRoll[clientUID];
    
    NSString *results = [[NSString alloc] initWithFormat:@"Your roll of %d wins you first bid position", rollValue];
    if (liarsDice->GetCurrentUID() != clientUID)
    {
        NSString *winner = [NSString stringWithstring:liarsDice->GetPlayerName(liarsDice->GetCurrentUID())];
        results = [[NSString alloc] initWithFormat:@"Your roll of %d wasn't good enough. %@ is the first bidder.", rollValue, winner];
    }
    
    [rollResultsLable setText:results];
}

- (IBAction)rollDiceButton:(id)sender
{
    if ([self.view subviews])
    {
        hasRolledDie = true;
        // Make sure we have a chance to discover devices before showing the user that nothing was found (yet)
        double interval = 1.0 / [ScrollingDiceView animationHZ];
        myTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(rollDice) userInfo:nil repeats:YES];
    }
}

- (IBAction)startRound:(id)sender {
    if (!hasRolledDie)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Roll Error" message:@"You need to roll your die first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        return;
    }
    RoundPlayViewController_iPhone *rpvc = [[RoundPlayViewController_iPhone alloc] initWithLiarsDice:liarsDice];
    [[self navigationController] pushViewController:rpvc animated:YES];
}

- (void)setLiarsDiceGame:(std::shared_ptr<LiarsDiceEngine>)liarsDiceEngine
{
    liarsDice = liarsDiceEngine;
}
@end
