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
 
    __weak IBOutlet UILabel *playersOddsLabel;
    __weak IBOutlet UILabel *typicalOddsLabel;
    
    __weak IBOutlet UIView *curtainView;
    __weak IBOutlet UIImageView *nonBidHighlight;
    __weak IBOutlet UIImageView *bidHighlight;
    __weak IBOutlet UIView *bullshitView;
    
    // TODO change this to be a list of
    // the current players using this device
    unsigned int devicePlayerUID;
    
    //
    int currentLowestQuantity;
    int selectedQuantity;
    int selectedFaceValue;
    
    int currentHighlightedPosition;
    int bidIndexForSelectedBidItem;
    
    int landscapeHeight;
    int tableviewHeight;
    int tableviewWidth;
    
    double maxRollDuration;
    
    BOOL dragging;
    float oldY;
    BOOL isCurtainLocked;
    
    NSTimer *myTimer;
    __weak IBOutlet UIView *bidSelectionView;
}

@property (nonatomic) EasyTableView *horizontalView;

- (id)initWithLiarsDice:(std::shared_ptr<LiarsDiceEngine>)liarsDice;

- (IBAction)qaAdvanceGame:(id)sender;

- (void)bounceAnimation:(UIView *)view withCount:(int)bounceCount andBounceHeight:(int)bounceHeight;
- (void)changeQuantityPositionBy:(int)shiftValue atButtonPosition:(int)buttonPositionSelected;
- (void)deselectFaceValue:(int)faceValue;
- (void)deselectQuantityValue:(int)quantityValue withButton:(UIButton *)button;
- (void)deselectQuantityValue:(int)quantityValue atPosition:(int)position;

- (void)resetDiceToOnePosition;

- (void)rollDice;
- (IBAction)rollDiceButton:(id)sender;

- (UIView *)searchSubviewsForTaggedView:(int)tag inSubviews:(UIView *)view;
- (void)selectFaceValue:(int)faceValue withButton:(UIButton *)button;
- (void)selectQuantityValue:(int)quantityValue withButton:(UIButton *)button;

- (void)setDiceToOnePosition;

- (void)updateDieFaceButton:(UIButton *)button withValue:(int)faceValue;
- (void)updateQuantityButton:(UIButton *)button withPosition:(int)position;
- (void)updateDetailedPlayerInfo:(UIView *)view;

- (IBAction)faceValueButton1:(id)sender;
- (IBAction)faceValueButton2:(id)sender;
- (IBAction)faceValueButton3:(id)sender;
- (IBAction)faceValueButton4:(id)sender;
- (IBAction)faceValueButton5:(id)sender;
- (IBAction)faceValueButton6:(id)sender;

- (IBAction)quantityPositionButton1:(id)sender;
- (IBAction)quantityPositionButton2:(id)sender;
- (IBAction)quantityPositionButton3:(id)sender;
- (IBAction)quantityPositionButton4:(id)sender;
- (IBAction)quantityPositionButton5:(id)sender;

- (IBAction)qaBidButton:(id)sender;
- (IBAction)qaChallengeButton:(id)sender;

- (IBAction)qaButtonResetDice:(id)sender;

@end
