//
//  RollForFirstPlayViewController_iPhone.h
//  LiarsDice
//
//  Created by David Raleigh on 2/1/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "RollForFirstPlayViewController.h"

#include <memory>
// forward declaration from this page
// http://www.zedkep.com/blog/index.php?/archives/247-Forward-declaring-C++-classes-in-Objective-C.html
struct LiarsDiceEngine;
typedef struct LiarsDiceEngine LiarsDiceEngine;

@interface RollForFirstPlayViewController_iPhone : RollForFirstPlayViewController
{
    std::shared_ptr<LiarsDiceEngine> liarsDice;
    __weak IBOutlet UILabel *rollResultsLable;
    
    bool hasRolledDie;
    double maxRollDuration;
    NSTimer *myTimer;
}

- (IBAction)startRound:(id)sender;
- (void)setLiarsDiceGame:(std::shared_ptr<LiarsDiceEngine>)liarsDiceEngine;
- (void)rollDice;
- (IBAction)rollDiceButton:(id)sender;
@end
