//
//  RoundPlayViewController_iPhone.h
//  LiarsDice
//
//  Created by David Raleigh on 2/5/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "RoundPlayViewController.h"
#import "EasyTableView.h"

#import <memory>

// forward declaration from this page
// http://www.zedkep.com/blog/index.php?/archives/247-Forward-declaring-C++-classes-in-Objective-C.html
struct LiarsDiceEngine;
typedef struct LiarsDiceEngine LiarsDiceEngine;

@interface RoundPlayViewController_iPhone : RoundPlayViewController <EasyTableViewDelegate>
{
    std::shared_ptr<LiarsDiceEngine> liarsDice;
    
	EasyTableView *horizontalView;
    __weak IBOutlet UIButton *quantityButtonText1;
    __weak IBOutlet UIButton *quantityButtonText2;
    __weak IBOutlet UIButton *quantityButtonText3;
    __weak IBOutlet UIButton *quantityButtonText4;
    __weak IBOutlet UIButton *quantityButtonText5;
    __weak IBOutlet UIButton *quantityButtonText6;
 
    __weak IBOutlet UILabel *playersOddsLabel;
    __weak IBOutlet UILabel *typicalOddsLabel;
    
    __weak IBOutlet UIView *curtainView;
    
    unsigned int devicePlayerUID;
    
    int currentLowestQuantity;
    int selectedQuantity;
    int selectedFaceValue;
    int currentHighlightedPosition;
    int bidIndexForCenterBidItem;
    
    int landscapeHeight;
    int tableviewHeight;
    int tableviewWidth;
    
    double maxRollDuration;
    
    BOOL dragging;
    float oldY;
    
    NSTimer *myTimer;
}

@property (nonatomic) EasyTableView *horizontalView;

- (id)initWithLiarsDice:(std::shared_ptr<LiarsDiceEngine>)liarsDice;
- (IBAction)qaAdvanceGame:(id)sender;

- (IBAction)quantityButton1:(id)sender;
- (IBAction)quantityButton2:(id)sender;
- (IBAction)quantityButton3:(id)sender;
- (IBAction)quantityButton4:(id)sender;
- (IBAction)quantityButton5:(id)sender;
- (IBAction)quantityButton6:(id)sender;

- (IBAction)faceValueButton1:(id)sender;
- (IBAction)faceValueButton2:(id)sender;
- (IBAction)faceValueButton3:(id)sender;
- (IBAction)faceValueButton4:(id)sender;
- (IBAction)faceValueButton5:(id)sender;
- (IBAction)faceValueButton6:(id)sender;

- (IBAction)rollDiceButton:(id)sender;

- (void)rollDice;
- (void)changeButtonTexts:(int)shiftValue withButtonPosition:(int)buttonPositionSelected;
- (UIView *)searchSubviewsForTaggedView:(int)tag inSubviews:(UIView *)view;
- (void)bounceAnimation:(UIView *)view withCount:(int)bounceCount andBounceHeight:(int)bounceHeight;
- (void)updateDetailedPlayerInfo:(UIView *)view;
@end
