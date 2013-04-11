//
//  SummarizeRoundViewController_iPhone.h
//  LiarsDice
//
//  Created by David Raleigh on 2/1/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "SummarizeRoundViewController.h"

#import <memory>

@class EasyTableView;

// forward declaration from this page
// http://www.zedkep.com/blog/index.php?/archives/247-Forward-declaring-C++-classes-in-Objective-C.html
struct LiarsDiceEngine;
typedef struct LiarsDiceEngine LiarsDiceEngine;

@interface SummarizeRoundViewController_iPhone : SummarizeRoundViewController
{
    // This is the reference to the game
    std::shared_ptr<LiarsDiceEngine> liarsDice;
    
    // horizontalTableView of all the playerBidItems
	EasyTableView *horizontalView;
    
    // TODO change this to be a list of
    // the current players using this device
    unsigned int devicePlayerUID;
    
    int bidItemViewHeight;
    int bidItemViewWidth;
}

@property (nonatomic) EasyTableView *horizontalView;

- (IBAction)continueGameButton:(id)sender;
- (id)initWithLiarsDice:(std::shared_ptr<LiarsDiceEngine>)liarsDice;
@end
