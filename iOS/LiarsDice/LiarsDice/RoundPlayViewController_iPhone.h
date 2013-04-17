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

@class PlayerBidItemView_iPhone;
// #DEFINES FOR EasyTableView
// The number of visible PlayerBidItemView in the EasyTableView
#define RPVC_ETV_NUM_VISIBLE_PBIV 5
// the x origin of the easytableview
#define RPVC_ETV_ORIGIN_X                               14
// the y origin of the easytableview
#define RPVC_ETV_ORIGIN_Y                               11
// the separation between the playerBidItemViews
#define RPVC_ETV_SEPARATION_BETWEEN_PBIV                13
// The additional space above and below each PBIV in the ETV
#define RPVC_ETV_EXTRA_VERT_FOR_PBIV                    4
// the width of the ETV
#define RPVC_ETV_WIDTH                                  454
#define RPVC_ETV_BACKGROUND_COLOR                       [UIColor clearColor]
// #DEFINES FOR EASYTABLEVIEW

// forward declaration from this page
// http://www.zedkep.com/blog/index.php?/archives/247-Forward-declaring-C++-classes-in-Objective-C.html
struct LiarsDiceEngine;
typedef struct LiarsDiceEngine LiarsDiceEngine;

@interface RoundPlayViewController_iPhone : RoundPlayViewController <EasyTableViewDelegate>
{
    // This is the reference to the game
    std::shared_ptr<LiarsDiceEngine> liarsDice;
    
    // horizontalTableView of all the playerBidItems
	EasyTableView *easyTableView;

    // the curtain view is the overlaying view where player
    // can review bids and make their own bids and challenges
    __weak IBOutlet UIView *curtainView;
    
    // The highlight border for when a player can bid but not challenge
    __weak IBOutlet UIImageView *activeBidItemHighlight;
    // the highlight border for when a player can challenge but not bid
    __weak IBOutlet UIImageView *activeChallengeItemHighlight;
    // the highlight border for when a player can either bid or challenge
    __weak IBOutlet UIImageView *activeBidOrChallengeItemHighlight;
    // the highlight border if the selected player bid item is not the current bidder/challenger
    __weak IBOutlet UIImageView *inactiveBidItemHighlight;
    // the view that comes up when the player is bidding
    __weak IBOutlet UIView *bidSelectionView;
    // the view that comes up when the player is challenging
    __weak IBOutlet UIView *challengeView;
    
    __weak IBOutlet UIButton *selectPosition1ButtonView;
    __weak IBOutlet UILabel *leftSideLabel;
    __weak IBOutlet UILabel *rightSideLabel;
    
    
    // TODO change this to be a list of
    // the current players using this device
    unsigned int devicePlayerUID;
    
    // the lowerst selectable quantity currently displayed in the bidSelectionView
    int currentLowestQuantity;
    // the currently selected quantity
    int selectedQuantity;
    // the currently selected face value
    int selectedFaceValue;
    // the position of the currently highlighted (selected) quantity position
    int currentHighlightedQuantityPosition;
    // the bid index (in terms of the round) for the currently selected bid item
    int bidIndexForSelectedBidItem;
    
    // height of the playerBidItemView. used to determine the height of the easytableview
    int bidItemViewHeight;
    // width of the playerBidItemView. used to determine the width of the easytableview
    int bidItemViewWidth;
    
    // maximum duration of the spinning dice
    double maxRollDuration;
    
    // is the curtain currently being dragged around the screen
    BOOL bIsDragging;
    //

    BOOL bIsCurtainLocked;
    BOOL bHasRolled;
    
    float curtainOldY;
    
    NSTimer *animationTimer;
}

@property (nonatomic) EasyTableView *easyTableView;

- (id)initWithLiarsDice:(std::shared_ptr<LiarsDiceEngine>)liarsDice;

- (IBAction)qaAdvanceGame:(id)sender;

- (void)bounceAnimation:(UIView *)view withCount:(int)bounceCount andBounceHeight:(int)bounceHeight;
- (void)changeQuantityPositionBy:(int)shiftValue atButtonPosition:(int)buttonPositionSelected;

- (BOOL)isPBIVDeviceAndCurrentBidder:(PlayerBidItemView_iPhone *)pbiView;

- (void)resetPlayersDiceToAllOnes;

- (void)rollDice;
- (IBAction)rollDiceButton:(id)sender;

- (UIView *)searchSubviewsForTaggedView:(int)tag inSubviews:(UIView *)view;

- (void)setDeselectedFaceValueImage:(int)faceValue;
- (void)setDeselectedQuantityValueImage:(int)quantityValue atButton:(UIButton *)button;
- (void)setDeselectedQuantityValueImage:(int)quantityValue atPosition:(int)position;
- (void)setSelectedFaceValueImage:(int)faceValue atButton:(UIButton *)button;
- (void)setSelectedQuantityValueImage:(int)quantityValue atButton:(UIButton *)button;
- (void)setSelectedQuantityValueImage:(int)quantityValue atPosition:(int)position;

- (void)setPlayersDiceToAllOnes;

- (void)shiftQuantityButtonRange:(int)newLowestQuantity;

- (void)updateDieFaceButton:(UIButton *)button atValue:(int)faceValue;
- (void)updateQuantityButton:(UIButton *)button atPosition:(int)position;
- (void)updateDetailedPlayerInfo:(UIView *)view;

- (void)updateCurrentPlayerBidItemFaceValue:(int)faceValue;
- (void)updateCurrentPlayerBidItemQuantity:(int)quantity;

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
