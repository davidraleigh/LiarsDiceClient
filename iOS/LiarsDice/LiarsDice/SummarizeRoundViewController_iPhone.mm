//
//  SummarizeRoundViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/1/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "SummarizeRoundViewController_iPhone.h"

#import "RoundPlayViewController_iPhone.h"
#import "EasyTableView.h"
#import "PlayerBidItemView_iPhone.h"
#import "StringConversion.h"

#include <LiarsDiceEngine.h>

// PlayerBitItem defines for EasyTableView Layout
#define NUM_OF_VSISIBLE_BID_ITEMS 5
#define BLANK_BID_ITEMS_TO_RIGHT 1
#define BLANK_BID_ITEMS_TO_LEFT 3
#define NEXT_NEXT_PLAYER_BID_ITEM BLANK_BID_ITEMS_TO_LEFT
#define NEXT_PLAYER_BID_ITEM NEXT_NEXT_PLAYER_BID_ITEM + 1
#define CURRENT_BIDDER_BID_ITEM NEXT_PLAYER_BID_ITEM + 1
#define HIGHLIGHTED_BID_ITEM 3
// PlayerBitItem defines for EasyTableView Layout

// BID VIEW
#define PLAYER_BID_ITEM_VIEW_TAG 88
#define FACE_VALUE_TAGS 700
// BID VIEW

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
