//
//  PlayersShowDiceViewController_iPhone.h
//  LiarsDice
//
//  Created by David Raleigh on 2/1/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "PlayersShowDiceViewController.h"

#import <memory>

// forward declaration from this page
// http://www.zedkep.com/blog/index.php?/archives/247-Forward-declaring-C++-classes-in-Objective-C.html
struct LiarsDiceEngine;
typedef struct LiarsDiceEngine LiarsDiceEngine;

@interface PlayersShowDiceViewController_iPhone : PlayersShowDiceViewController
{
    std::shared_ptr<LiarsDiceEngine> liarsDice;
}

- (id)initWithLiarsDice:(std::shared_ptr<LiarsDiceEngine>)liarsDice;
- (IBAction)QAButtonThrowAWayDice:(id)sender;
@end

