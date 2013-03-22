//
//  SummarizeRoundViewController_iPhone.h
//  LiarsDice
//
//  Created by David Raleigh on 2/1/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "SummarizeRoundViewController.h"

#import <memory>

// forward declaration from this page
// http://www.zedkep.com/blog/index.php?/archives/247-Forward-declaring-C++-classes-in-Objective-C.html
struct LiarsDiceEngine;
typedef struct LiarsDiceEngine LiarsDiceEngine;

@interface SummarizeRoundViewController_iPhone : SummarizeRoundViewController
{
    std::shared_ptr<LiarsDiceEngine> liarsDice;
}

- (IBAction)continueGameButton:(id)sender;
- (id)initWithLiarsDice:(std::shared_ptr<LiarsDiceEngine>)liarsDice;
@end
