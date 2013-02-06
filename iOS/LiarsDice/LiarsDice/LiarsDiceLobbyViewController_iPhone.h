//
//  LiarsDiceLobbyViewController_iPhone.h
//  LiarsDice
//
//  Created by David Raleigh on 2/4/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "LiarsDiceLobbyViewController.h"

@interface LiarsDiceLobbyViewController_iPhone : LiarsDiceLobbyViewController
{
    __weak IBOutlet UIButton *sortByButtonText;
    int sortByKey;
}

- (IBAction)startGameButton:(id)sender;
- (IBAction)sortyByButton:(id)sender;

@end
