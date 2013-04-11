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
    // This is the reference to the game
    std::shared_ptr<LiarsDiceEngine> liarsDice;
    
    // horizontalTableView of all the playerBidItems
	EasyTableView *horizontalView;

    // the curtain view is the overlaying view where player
    // can review bids and make their own bids and challenges
    __weak IBOutlet UIView *curtainView;
    
    // green, red, or green and red highlight for the 

    __weak IBOutlet UIImageView *activeBidItemHighlight;
    __weak IBOutlet UIImageView *activeChallengeItemHighlight;
    __weak IBOutlet UIImageView *activeBidOrChallengeItemHighlight;
    __weak IBOutlet UIImageView *inactiveBidItemHighlight;
    __weak IBOutlet UIView *bidSelectionView;
    __weak IBOutlet UIView *challengeView;
    
    __weak IBOutlet UIButton *selectPosition1ButtonView;
    __weak IBOutlet UILabel *leftSideLabel;
    __weak IBOutlet UILabel *rightSideLabel;
    
    
    // TODO change this to be a list of
    // the current players using this device
    unsigned int devicePlayerUID;
    
    int currentLowestQuantity;
    int selectedQuantity;
    int selectedFaceValue;
    
    int currentHighlightedQuantityPosition;
    int bidIndexForSelectedBidItem;
    
    int bidItemViewHeight;
    int bidItemViewWidth;
    
    double maxRollDuration;
    
    BOOL bIsDragging;
    BOOL bIsCurtainLocked;
    BOOL bHasRolled;
    
    float curtainOldY;
    
    NSTimer *animationTimer;
}

@property (nonatomic) EasyTableView *horizontalView;

- (id)initWithLiarsDice:(std::shared_ptr<LiarsDiceEngine>)liarsDice;

- (IBAction)qaAdvanceGame:(id)sender;

- (void)bounceAnimation:(UIView *)view withCount:(int)bounceCount andBounceHeight:(int)bounceHeight;
- (void)changeQuantityPositionBy:(int)shiftValue atButtonPosition:(int)buttonPositionSelected;

- (void)resetDiceToOnePosition;

- (void)rollDice;
- (IBAction)rollDiceButton:(id)sender;

- (UIView *)searchSubviewsForTaggedView:(int)tag inSubviews:(UIView *)view;

- (void)setDeselectedFaceValueImage:(int)faceValue;
- (void)setDeselectedQuantityValueImage:(int)quantityValue atButton:(UIButton *)button;
- (void)setDeselectedQuantityValueImage:(int)quantityValue atPosition:(int)position;
- (void)setSelectedFaceValueImage:(int)faceValue atButton:(UIButton *)button;
- (void)setSelectedQuantityValueImage:(int)quantityValue atButton:(UIButton *)button;
- (void)setSelectedQuantityValueImage:(int)quantityValue atPosition:(int)position;

- (void)setDiceToOnePosition;

- (void)shiftQuantityButtonRange:(int)newLowestQuantity;

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
