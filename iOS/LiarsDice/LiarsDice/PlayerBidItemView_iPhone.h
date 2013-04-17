//
//  PlayerBidItemView_iPhone.h
//  LiarsDice
//
//  Created by David Raleigh on 2/8/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PBIV_TAG         11

typedef enum
{
    GreenHighlight,
    YelllowHighlight,
    RedHighlight,
    NoHighlight
}Highlights;

typedef enum
{
    Winner,
    Loser,
    Neutral
}EndOfRoundStatus;

@interface PlayerBidItemView_iPhone : UIView
{
    __weak IBOutlet UIView *highlightView;
    __weak IBOutlet UILabel *timesMarkTextView;
    __weak IBOutlet UITextView *userNameTextView;
    __weak IBOutlet UILabel *bidQuantityLabel;
    __weak IBOutlet UIImageView *bidFaceValueImageView;
    __weak IBOutlet UILabel *oddsLabel;
    IBOutlet UIView *topView;
    
    bool bIsCurrentBidder;
    Highlights highlightState;
    EndOfRoundStatus endOfRoundStatus;
}

@property (nonatomic) int bidIndex;

// get the player's name from the PBIV
- (NSString *)getPlayerName;
// Get the size of the UIView
- (CGSize)getSize;


// green highlight indicates that the player's bid was the best bid in his hand
- (void)highlightGreen;
// the loser
- (void)highlightLoser;
// red highlights indicates that the bid was a complete lie and the player had none of the values for the die indicated
- (void)highlightRed;
// the winner.
- (void)highlightWinner;
// yellow highlights that while it wasn't the best bid in the player's hand, the player had at least 1 of the indicated die
- (void)highlightYellow;

// clear the highlight?

// set the PBIV as empty (translucent)
- (void)setAsEmpty;
- (void)setAsHeader:(int)roundNumber;
- (void)setAsFooter:(int)roundNumber;
// set the challenger
- (void)setChallengerName:(NSString *)challengerName setChallengedName:(NSString *)challengedName;
// set the current bidder
- (void)setCurrentBidderName:(NSString *)name;
// set the next bidder
- (void)setNextBidderName:(NSString *)name;
// set the next after next bidder
- (void)setNextAfterNextBidderName:(NSString *)name;
// set the bid
- (void)setPlayerName:(NSString *)name bidQuantity:(int)quantity bidFaceValue:(int)faceValue bidOdds:(int)odds;


// this only ought to be used for the       
- (void)updateBidQuantity:(int)quantity;
- (void)updateBidFaceValue:(int)faceValue;
- (void)updateBidOdds:(int)bidOdds;

@end
