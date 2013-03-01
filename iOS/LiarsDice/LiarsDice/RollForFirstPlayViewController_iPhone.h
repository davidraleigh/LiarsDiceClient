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
    
    double maxRollDuration;
}

- (void)setLiarsDiceGame:(std::shared_ptr<LiarsDiceEngine>)liarsDiceEngine;
- (IBAction)rollDiceButton:(id)sender;
@end
