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
    if (self) {
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
    
    ScrollingDiceView *scrollingDice = [[ScrollingDiceView alloc]initWithFrame:frame andFaceValue:1];
    
    [scrollingDice setImage:uiImage];
    [scrollingDice setTag:1];
    
    maxRollDuration = [scrollingDice getCompleteDuration];
    
    [self.view insertSubview:scrollingDice atIndex:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rollDiceButton:(id)sender
{
    RoundPlayViewController_iPhone *rpvc = [[RoundPlayViewController_iPhone alloc] init];
    [rpvc setLiarsDiceGame:liarsDice];
    [[self navigationController] pushViewController:rpvc animated:YES];
}

- (void)setLiarsDiceGame:(std::shared_ptr<LiarsDiceEngine>)liarsDiceEngine
{
    liarsDice = liarsDiceEngine;
}
@end
