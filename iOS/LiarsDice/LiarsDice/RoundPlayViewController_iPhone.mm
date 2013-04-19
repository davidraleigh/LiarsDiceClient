//
//  RoundPlayViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/5/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "RoundPlayViewController_iPhone.h"

#import "SummarizeRoundViewController_iPhone.h"
#import "ScrollingDiceView.h"
#import "EasyTableView.h"
#import "PlayerBidItemView_iPhone.h"
#import "StringConversion.h"
#import "HelperFunctions.h"

#import <LiarsDiceEngine.h>
#import <Round.h>
#import <GamePlayers.h>


// #Defines for ScrollingDiceView (SDV)
// number of dice a player can have
#define SDV_MAX_DICE_COUNT 7
// the x origin of the leftmost SDV
#define SDV_X_ORIGIN 10
// the center of the SDV with position centered at 1
#define SDV_CENTER_OF_WINDOW_Y 90
// the separation between each SDV
#define SDV_X_SEPARATION 2
// the base for tags which number from 901 to SDV_TAG_BASE + SDV_MAX_DICE_COUNT
#define SDV_TAG_BASE 900
// #Defines for ScrollingDiceView (SDV)

// #Defines for Curtain View
// the handle's width
#define CV_HANDLE_WIDTH 138
// the handle's height
#define CV_HANDLE_HEIGHT 56
// x origin for the view's handle
#define CV_HANDLE_X_ORIGIN 171
// y origin for the view's handle
#define CV_HANDLE_Y_ORIGIN 265
// when the curtain is at it's highest position the handle must show
#define CV_Y_MIN -CV_HANDLE_Y_ORIGIN
// when the curtain is at it's lowest position it's origin at at the vc's origin
#define CV_Y_MAX 0
// the duration of the animation for the curtain slamming down
#define CV_ANIMATION_DURATION .25
// the delay before the animation begins
#define CV_ANIMATION_DELAY .05
// the duration of the bounce animations
#define CV_BOUNCE_DURATION .1
// the lowest height from which to animate a bounce
#define CV_LOWEST_BOUNCE 6
// the range is from the Lowest height to CV_LOWEST_BOUNCE + CV_BOUNCE_RANGE
#define CV_BOUNCE_RANGE 8

// #DEFINES FOR Bid View
// the numer of quantity buttons
#define BV_NUM_QUANTITIES 5
// the bid view quantity button view base value for the tags
#define BV_QBV_TAG_BASE 660
// the bid view face button view base value for the tags
#define BV_FBV_TAG_BASE 700
// #DEFINES FOR BidView

// PlayerBitItem defines for EasyTableView Layout

// the startup position of the PBIV in the ETV is defined by the offset of the PBIVs from 0
#define ETV_PBIV_STARTUP_OFFSET_COUNT              2
// the number of blank spaces to the right of the visible PBIV
#define ETV_BLANK_PBIV_AT_RIGHT 1
// the number of blank spaces to the left of the visible PBIV
#define ETV_BLANK_PBIV_AT_LEFT 3
// the number of pending PBIV.  The current, the next player and the next after next player are all pending PBIV.
#define ETV_NUM_PENDING_PBIV 3
// the total number of PBIV which don't contain bid information
#define ETV_NUM_NON_BID_PBIV ETV_BLANK_PBIV_AT_RIGHT + ETV_BLANK_PBIV_AT_LEFT + ETV_NUM_PENDING_PBIV

// index of the Next after next PBIV
#define PBIV_NEXT_AFTER_NEXT_IDX ETV_BLANK_PBIV_AT_LEFT
// index of the Next player PBIV
#define PBIV_NEXT_IDX PBIV_NEXT_AFTER_NEXT_IDX + 1
// index of the current player[
#define PBIV_CURRENT_IDX PBIV_NEXT_IDX + 1
// the position index among the all the visible PBIV in the ETV
#define ETV_PBIV_HIGHLIGHTED_IDX 3

// PlayerBitItem defines for EasyTableView Layout


@interface RoundPlayViewController_iPhone (MyPrivateMethods)
- (void)setupEasyTableView;
@end

@implementation RoundPlayViewController_iPhone

@synthesize easyTableView;

- (id)initWithLiarsDice:(std::shared_ptr<LiarsDiceEngine>)liarsDiceEngine
{
    self = [super initWithNibName:@"RoundPlayViewController_iPhone" bundle:nil];
    if (self)
    {
        liarsDice = liarsDiceEngine;
        CGSize viewSize = [[[PlayerBidItemView_iPhone alloc] init] getSize];
        bidItemViewWidth = (int)viewSize.width + RPVC_ETV_SEPARATION_BETWEEN_PBIV;
        bidItemViewHeight = (int)viewSize.height;

        maxRollDuration = 0;
        devicePlayerUID = GamePlayers::getInstance().GetClientUID();
        bidIndexForSelectedBidItem = ETV_PBIV_HIGHLIGHTED_IDX;
        selectedFaceValue = 0;
        bIsCurtainLocked = NO;
        bHasRolled = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // hide all the brackets to start with and then let the updateDetailedPlayerInfo method
    // sort out which should be shown
    activeBidOrChallengeItemHighlight.hidden = YES;
    activeBidItemHighlight.hidden = YES;
    activeChallengeItemHighlight.hidden = YES;
    inactiveBidItemHighlight.hidden = YES;
    bidSelectionView.hidden = YES;
    challengeView.hidden = YES;

    liarsDice->StartRound();
    
    [self setPlayersDiceToAllOnes];
    
    // Get the bid selection view
    bidSelectionView.hidden = YES;
    
    // Do any additional setup after loading the view from its nib.
	[self setupEasyTableView];

    currentLowestQuantity = liarsDice->GetLowestPossibleBid().bidQuantity;
}

- (void) viewWillAppear:(BOOL)animated
{
    if (liarsDice->GetBidCountForGame() == 0)
        return;
    //[super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    liarsDice->StartRound();
    
    [easyTableView reloadData];
    [self resetPlayersDiceToAllOnes];

}

- (void)setPlayersDiceToAllOnes
{
    double xOrigin = SDV_X_ORIGIN;
    int diceCount = liarsDice->GetPlayersDiceCount(devicePlayerUID);
    std::vector<int> playersDice = liarsDice->GetPlayersDice(devicePlayerUID);
    for (int i = 1; i <= SDV_MAX_DICE_COUNT; i++)
    {
        if (i > diceCount)
            break;
        
        NSString *fileName = [[NSString alloc] initWithFormat:@"LD_DiceScroll_%d.png", 1];
        UIImage *uiImage = [UIImage imageNamed:fileName];
        
        CGRect frame = CGRectMake(xOrigin, SDV_CENTER_OF_WINDOW_Y, uiImage.size.width / 2, uiImage.size.height / 2);
        xOrigin += frame.size.width + SDV_X_SEPARATION;
        
        ScrollingDiceView *scrollingDice = [[ScrollingDiceView alloc]initWithFrame:frame andFaceValue:playersDice[i - 1]];
        
        [scrollingDice setImage:uiImage];
        [scrollingDice setTag: SDV_TAG_BASE + i];
        
        double tempMaxDuration = [scrollingDice getCompleteDuration];
        if (tempMaxDuration > maxRollDuration)
            maxRollDuration = tempMaxDuration;
        
        [self.view insertSubview:scrollingDice atIndex:i];
    }
    bHasRolled = NO;
}

- (void)resetPlayersDiceToAllOnes
{
    if(animationTimer)
    {
        [animationTimer invalidate];
        animationTimer = nil;
    }
    int diceCount = liarsDice->GetPlayersDiceCount(devicePlayerUID);
    // test to see if the player lost a die last round.
    int lastRoundIndex = liarsDice->GetRoundCount() - 2;
    if (liarsDice->GetRoundLoser(lastRoundIndex) == devicePlayerUID)
    {
        // hide the highest order scrolling dice
        ScrollingDiceView *scrollingDice = (ScrollingDiceView *)[self searchSubviewsForTaggedView:SDV_TAG_BASE + diceCount + 1 inSubviews:self.view];
        scrollingDice.hidden = YES;
    }
    
    double xOrigin = SDV_X_ORIGIN;
    
    std::vector<int> playersDice = liarsDice->GetPlayersDice(devicePlayerUID);
    for (int i = 1; i <= SDV_MAX_DICE_COUNT; i++)
    {
        if (i > diceCount)
            break;
        ScrollingDiceView *scrollingDice = (ScrollingDiceView *)[self searchSubviewsForTaggedView:SDV_TAG_BASE + i inSubviews:self.view];
        
        CGRect frame = CGRectMake(xOrigin, SDV_CENTER_OF_WINDOW_Y, scrollingDice.frame.size.width, scrollingDice.frame.size.height);
        xOrigin += frame.size.width + SDV_X_SEPARATION;
        [scrollingDice setFrame:frame];
        
        [scrollingDice scrollSetup:frame andFaceValue:playersDice[i - 1]];
        
        double tempMaxDuration = [scrollingDice getCompleteDuration];
        if (tempMaxDuration > maxRollDuration)
            maxRollDuration = tempMaxDuration;
    }

    bHasRolled = NO;
}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
    CGPoint offsetPoint = CGPointMake(ETV_PBIV_STARTUP_OFFSET_COUNT * bidItemViewWidth, 0);
    [easyTableView setContentOffset:offsetPoint];
    //[self updateDetailedPlayerInfo:[easyTableView.visibleViews objectAtIndex:ETV_PBIV_HIGHLIGHTED_IDX]];
    
    //UIVIEW *curtainView = [self searchSubviewsForTaggedView:99 inSubviews:self.view];
    CGRect workingFrame = curtainView.frame;
    // animate curtain up for roll
    workingFrame.origin.y = -CV_HANDLE_Y_ORIGIN;
    CGPoint center = CGPointMake(workingFrame.origin.x + workingFrame.size.width/2, workingFrame.origin.y + workingFrame.size.height/2);
    
    [UIView animateWithDuration:CV_ANIMATION_DURATION delay:CV_ANIMATION_DELAY options:UIViewAnimationCurveEaseOut animations:^
     {
         curtainView.center = center;
         NSLog(@"Animation Start");
     }
    completion:nil];

    bIsCurtainLocked = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark EasyTableView Initialization

- (void)setupEasyTableView
{
	CGRect frameRect	= CGRectMake(RPVC_ETV_ORIGIN_X, RPVC_ETV_ORIGIN_Y, RPVC_ETV_WIDTH, bidItemViewHeight + RPVC_ETV_EXTRA_VERT_FOR_PBIV);
	EasyTableView *view	= [[EasyTableView alloc] initWithFrame:frameRect numberOfColumns:ETV_NUM_NON_BID_PBIV ofWidth:bidItemViewWidth];
	self.easyTableView = view;
	
	easyTableView.delegate						= self;
	easyTableView.tableView.backgroundColor	= RPVC_ETV_BACKGROUND_COLOR;
	easyTableView.tableView.separatorColor	= [UIColor clearColor];
	easyTableView.cellBackgroundColor			= [UIColor clearColor];
	easyTableView.autoresizingMask				= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    UIView *gamePlayView = [self.view viewWithTag:99];
	[gamePlayView addSubview:easyTableView];
}


#pragma mark -
#pragma mark Utility Methods


#pragma mark -
#pragma mark EasyTableViewDelegate

// The first delegate method creates the necessary views
- (UIView *)easyTableView:(EasyTableView *)easyTableView viewForRect:(CGRect)rect
{
    // PlayerBidItemView is a subview of the container.
    // The container is larger and clear
    UIView *container = [[UIView alloc] initWithFrame:rect];
    
    PlayerBidItemView_iPhone *playerBidItemView = [[PlayerBidItemView_iPhone alloc] init];
    playerBidItemView.tag = PBIV_TAG;
    [container addSubview:playerBidItemView];
    
	return container;
}

// Second delegate populates the views with data from a data source
- (void)easyTableView:(EasyTableView *)easyTableView
       setDataForView:(UIView *)view
         forIndexPath:(NSIndexPath *)indexPath
{
    PlayerBidItemView_iPhone *playerBidItem = (PlayerBidItemView_iPhone *)[view viewWithTag:PBIV_TAG];
    
    // this is the index of the last bid
    // TODO fix this so that it works a bit differently for only two players
    int indexOfBidInEasyTable = [indexPath row];
    
    int currentBidCount = liarsDice->GetBidCount();
    
    if (indexOfBidInEasyTable < ETV_BLANK_PBIV_AT_LEFT ||
        indexOfBidInEasyTable >= currentBidCount + RPVC_ETV_NUM_VISIBLE_PBIV + ETV_BLANK_PBIV_AT_RIGHT)
    {
        // first we check to make sure the first two and
        // the last two playerBidItems are invisible
        [playerBidItem setAsEmpty];
        //playerBidItem.bidIndex = indexOfBidOnScreen == 1 ? liarsDice->GetBidCount() + 1 : liarsDice->GetBidCount() + 2;
    }
    
    else if (indexOfBidInEasyTable == PBIV_NEXT_AFTER_NEXT_IDX)
    {
        // This is for the case of the player after the next player
        unsigned int nextNextPlayerUID = liarsDice->GetNextPlayerUID(liarsDice->GetNextPlayerUID());
        std::string playerNameString = liarsDice->GetPlayerName(nextNextPlayerUID);
        NSString *playerName = [NSString stringWithstring: playerNameString];
        [playerBidItem setNextAfterNextBidderName:playerName];
        playerBidItem.bidIndex = currentBidCount + 2;
    }
    else if (indexOfBidInEasyTable == PBIV_NEXT_IDX)
    {
        // This is the case of the next player
        unsigned int nextPlayerUID = liarsDice->GetNextPlayerUID();
        std::string playerNameString = liarsDice->GetPlayerName(nextPlayerUID);
        NSString *playerName = [NSString stringWithstring: playerNameString];
        [playerBidItem setNextBidderName:playerName];
        playerBidItem.bidIndex = currentBidCount + 1;
    }
    else if (indexOfBidInEasyTable == PBIV_CURRENT_IDX)
    {
        // the case where the player bid view is the currently bidding player
        unsigned int currentPlayerUID = liarsDice->GetCurrentUID();
        std::string playerNameString = liarsDice->GetPlayerName(currentPlayerUID);
        NSString *playerName = [NSString stringWithstring: playerNameString];
        [playerBidItem setCurrentBidderName:playerName];
        playerBidItem.bidIndex = currentBidCount;
    }
    else if (indexOfBidInEasyTable > PBIV_CURRENT_IDX &&
             currentBidCount + indexOfBidInEasyTable > PBIV_CURRENT_IDX + 1)
    {
        // all other cases of bids that have already been made
        int bidIndex = indexOfBidInEasyTable - (PBIV_CURRENT_IDX + 1);
        RoundDetails::bid_t bid = liarsDice->GetBid(bidIndex);
        std::string playerNameString = liarsDice->GetPlayerName(bid.playerUID);
        NSString *playerName = [NSString stringWithstring: playerNameString];
        // it is important to note that you need to use the devicePlayerUID to demonstrate
        // the probability vs. your hand
        int bidOdds = liarsDice->GetProbabilityForPlayer(bid.bidQuantity, bid.bidFaceValue, devicePlayerUID);
        [playerBidItem setPlayerName:playerName bidQuantity:bid.bidQuantity bidFaceValue:bid.bidFaceValue bidOdds:bidOdds];
        
        playerBidItem.bidIndex = bidIndex;
    }
    [view addSubview:playerBidItem];
}

- (void)easyTableView:(EasyTableView *)easyTableView viewAtCenter:(UIView *)view
{
    [self updateDetailedPlayerInfo:view];    
}

#pragma mark -
#pragma mark Optional EasyTableView delegate methods for section headers and footers

// Delivers the number of cells in each section, this must be implemented if numberOfSectionsInEasyTableView is implemented
-(NSUInteger)numberOfCellsForEasyTableView:(EasyTableView *)view inSection:(NSInteger)section
{
    return liarsDice->GetBidCount() + ETV_NUM_NON_BID_PBIV;
}

- (void)changeQuantityPositionBy:(int)shiftValue atButtonPosition:(int)buttonPositionSelected
{
    RoundDetails::bid_t lowestBid = liarsDice->GetLowestPossibleBid();
    int remainingDice = liarsDice->GetTotalDieLeft();
    
    if (shiftValue + currentLowestQuantity < lowestBid.bidQuantity && shiftValue < 0)
        shiftValue = lowestBid.bidQuantity - currentLowestQuantity;
    else if(shiftValue + currentLowestQuantity + (BV_NUM_QUANTITIES - 1) > remainingDice)
        shiftValue = remainingDice - (BV_NUM_QUANTITIES - 1) - currentLowestQuantity;
    
    if ((currentLowestQuantity == lowestBid.bidQuantity && shiftValue < 0) ||
        (currentLowestQuantity + (BV_NUM_QUANTITIES - 1) == remainingDice && shiftValue > 0))
        shiftValue = 0;
    
    int largestShiftOffset = (BV_NUM_QUANTITIES / 2);
    if (shiftValue > largestShiftOffset || shiftValue < -largestShiftOffset)
        NSLog(@"Shift Value should never be greater than %d or less than -%d", largestShiftOffset, largestShiftOffset);
    
    int newSelectedPosition = buttonPositionSelected - shiftValue;
    currentLowestQuantity += shiftValue;
    
    for (int position = 1; position <= BV_NUM_QUANTITIES; position++)
    {
        int quantityValue = currentLowestQuantity + position - 1;
        NSLog(@"Button position: %d and button value: %d", position, quantityValue);
        
        if (newSelectedPosition != currentHighlightedQuantityPosition &&
            currentHighlightedQuantityPosition == position)
        {
            [self setDeselectedQuantityValueImage:quantityValue atPosition:position];
        }
        else if (newSelectedPosition == position)
        {
            [self setSelectedQuantityValueImage:quantityValue atPosition:position];
            selectedQuantity = quantityValue;
        }
        else
        {
            [self setDeselectedQuantityValueImage:quantityValue atPosition:position];
        }
    }
    currentHighlightedQuantityPosition = newSelectedPosition;
}

- (void)setDeselectedFaceValueImage:(int)faceValue
{
    UIButton *view = (UIButton*)[self searchSubviewsForTaggedView:BV_FBV_TAG_BASE + selectedFaceValue inSubviews:bidSelectionView];
    NSString *fileName = [[NSString alloc] initWithFormat:@"LD_Die_%d.png", selectedFaceValue];
    [view setImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
}

- (void)setDeselectedQuantityValueImage:(int)quantityValue atButton:(UIButton *)button
{
    NSString *fileName = [[NSString alloc] initWithFormat:@"LD_BidNumber_%d.png", quantityValue];
    [button setImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
}

- (void)setDeselectedQuantityValueImage:(int)quantityValue atPosition:(int)position
{
    UIButton *view = (UIButton *)[self searchSubviewsForTaggedView:BV_QBV_TAG_BASE + position inSubviews:bidSelectionView];
    [self setDeselectedQuantityValueImage:quantityValue atButton:view];
}

- (void)setSelectedFaceValueImage:(int)faceValue atButton:(UIButton *)button
{
    NSString *fileName = [[NSString alloc] initWithFormat:@"LD_Die_Highlight_%d.png", faceValue];
    [button setImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
}

- (void)setSelectedQuantityValueImage:(int)quantityValue atButton:(UIButton *)button
{
    NSString *fileName = [[NSString alloc] initWithFormat:@"LD_BidNumber_Highlight_%d.png", quantityValue];
    [button setImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
}

- (void)setSelectedQuantityValueImage:(int)quantityValue atPosition:(int)position
{
    UIButton *button = (UIButton *)[self searchSubviewsForTaggedView:BV_QBV_TAG_BASE + position inSubviews:bidSelectionView];
    [self setSelectedQuantityValueImage:quantityValue atButton:button];
}
- (void)shiftQuantityButtonRange:(int)newLowestQuantity
{
    if (newLowestQuantity == currentLowestQuantity)
        return;
    
    for (int position = 1; position <= BV_NUM_QUANTITIES; position++)
        [self setDeselectedQuantityValueImage:newLowestQuantity + position - 1 atPosition:position];

    currentHighlightedQuantityPosition = 0;
    currentLowestQuantity = newLowestQuantity;
}

- (void)updateDieFaceButton:(UIButton *)button atValue:(int)faceValue
{
    if (selectedFaceValue != faceValue)
    {
        // deselect button
        if (selectedFaceValue != 0)
            [self setDeselectedFaceValueImage:selectedFaceValue];
        
        [self setSelectedFaceValueImage:faceValue atButton:button];
        selectedFaceValue = faceValue;
    }
    else
    {
        [self setDeselectedFaceValueImage:selectedFaceValue];
        selectedFaceValue = 0;
    }
}

- (IBAction)faceValueButton1:(id)sender
{
    [self updateDieFaceButton:sender atValue:1];
    [self updateCurrentPlayerBidItemFaceValue:selectedFaceValue];
}

- (IBAction)faceValueButton2:(id)sender
{
    [self updateDieFaceButton:sender atValue:2];
    [self updateCurrentPlayerBidItemFaceValue:selectedFaceValue];
}

- (IBAction)faceValueButton3:(id)sender
{
    [self updateDieFaceButton:sender atValue:3];
    [self updateCurrentPlayerBidItemFaceValue:selectedFaceValue];
}

- (IBAction)faceValueButton4:(id)sender
{
    [self updateDieFaceButton:sender atValue:4];
    [self updateCurrentPlayerBidItemFaceValue:selectedFaceValue];
}

- (IBAction)faceValueButton5:(id)sender
{
    [self updateDieFaceButton:sender atValue:5];
    [self updateCurrentPlayerBidItemFaceValue:selectedFaceValue];
}

- (IBAction)faceValueButton6:(id)sender
{
    [self updateDieFaceButton:sender atValue:6];
    [self updateCurrentPlayerBidItemFaceValue:selectedFaceValue];
}

- (void)updateQuantityButton:(UIButton *)button atPosition:(int)position
{
    // the shift value is based off of the number of selectable quantities.
    // and the position of the current button
    int shiftValue = position - (1 + BV_NUM_QUANTITIES / 2);
    if (currentHighlightedQuantityPosition != position)
    {
        [self changeQuantityPositionBy:shiftValue atButtonPosition:position];
    }
    else
    {
        [self setDeselectedQuantityValueImage:selectedQuantity atPosition:position];
        selectedQuantity = 0;
        currentHighlightedQuantityPosition = 0;
    }
}

- (IBAction)quantityPositionButton1:(id)sender
{
    [self updateQuantityButton:sender atPosition:1];
    [self updateCurrentPlayerBidItemQuantity:selectedQuantity];
}

- (IBAction)quantityPositionButton2:(id)sender
{
    [self updateQuantityButton:sender atPosition:2];
    [self updateCurrentPlayerBidItemQuantity:selectedQuantity];
}

- (IBAction)quantityPositionButton3:(id)sender
{
    [self updateQuantityButton:sender atPosition:3];
    [self updateCurrentPlayerBidItemQuantity:selectedQuantity];
}

- (IBAction)quantityPositionButton4:(id)sender
{
    [self updateQuantityButton:sender atPosition:4];
    [self updateCurrentPlayerBidItemQuantity:selectedQuantity];
}

- (IBAction)quantityPositionButton5:(id)sender
{
    [self updateQuantityButton:sender atPosition:5];
    [self updateCurrentPlayerBidItemQuantity:selectedQuantity];
}

- (IBAction)qaBidButton:(id)sender
{
    int faceValue = selectedFaceValue;
    int quantity = selectedQuantity;
    
    if (faceValue == 0 || quantity == 0)
    {
        NSString *message = [[NSString alloc] initWithFormat:@"Your bid is %d of face value %d. This isn't a permissable bid", quantity, faceValue];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bid Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (!liarsDice->IsBidValid(faceValue, quantity))
    {
        NSString *message = [[NSString alloc] initWithFormat:@"Your bid is %d of face value %d. This isn't a permissable bid", quantity, faceValue];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bid Error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    liarsDice->Bid(quantity, faceValue);
    [self setDeselectedQuantityValueImage:selectedQuantity atPosition:currentHighlightedQuantityPosition];
    [self setDeselectedFaceValueImage:selectedFaceValue];
    [easyTableView reloadData];
    [self updateDetailedPlayerInfo:[easyTableView.visibleViews objectAtIndex:ETV_PBIV_HIGHLIGHTED_IDX]];
    
    selectedQuantity = 0;
    selectedFaceValue = 0;
    currentHighlightedQuantityPosition = 0;
}

- (IBAction)qaChallengeButton:(id)sender
{
    liarsDice->Challenge();
    
    bHasRolled = false;
    
    // if the player lost then set the last scrollingDiceView to hidden
    // do some other stuff
}

- (IBAction)qaAdvanceGame:(id)sender
{
    unsigned int currentUID = liarsDice->GetCurrentUID();
    RoundDetails::bid_t bidValue = liarsDice->GenerateAIBid(currentUID);
    if (bidValue.bidFaceValue == -1)
    {
        
        NSString *challenger = [NSString stringWithstring:liarsDice->GetPlayerName(currentUID)];
        NSString *previousBidder = [NSString stringWithstring:liarsDice->GetPlayerName(liarsDice->GetPreviousPlayerUID())];
        NSString *message = [[NSString alloc] initWithFormat:@"%@ challenged the bid from %@", challenger, previousBidder];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Challenge" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        liarsDice->Challenge();
        SummarizeRoundViewController_iPhone *srvc = [[SummarizeRoundViewController_iPhone alloc] initWithLiarsDice:liarsDice];
        [[self navigationController] pushViewController:srvc animated:YES];
    }
    else
    {
        liarsDice->Bid(bidValue.bidQuantity, bidValue.bidFaceValue);
        [easyTableView reloadData];
        [self updateDetailedPlayerInfo:[easyTableView.visibleViews objectAtIndex:ETV_PBIV_HIGHLIGHTED_IDX]];
    }
}

- (IBAction)rollDiceButton:(id)sender
{
    //liarsDice->StartRound();
    if ([self.view subviews] && !bHasRolled && !animationTimer)
    {
        // Make sure we have a chance to discover devices before showing the user that nothing was found (yet)
        double interval = 1.0 / [ScrollingDiceView animationHZ];
        animationTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(rollDice) userInfo:nil repeats:YES];
        bHasRolled = true;
    }
}

- (void)rollDice
{
    bool allViewsFinished = true;
    
    for (UIView *subview in [self.view subviews])
    {
        if ([subview isKindOfClass:[ScrollingDiceView class]])
        {
            ScrollingDiceView *scrollDice = (ScrollingDiceView *)subview;
            //int dieIndex = [scrollDice tag];
            [scrollDice scroll];
            
            if (![scrollDice isFinished])
                allViewsFinished = false;
        }
    }
}

- (UIView *)searchSubviewsForTaggedView:(int)tag inSubviews:(UIView *)view
{
    UIView *taggedView = nil;
    for (UIView *subview in view.subviews)
    {
        if (subview.tag == tag)
            return subview;
        else if ([subview.subviews count] > 0)
            taggedView = [self searchSubviewsForTaggedView:tag inSubviews:subview];
        
        if (taggedView != nil)
            return taggedView;
    }
    return taggedView;
}

- (void)setLiarsDiceGame:(std::shared_ptr<LiarsDiceEngine>)liarsDiceEngine
{
    liarsDice = liarsDiceEngine;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    // check that handle has been touched
    CGRect handleRect = CGRectMake(CV_HANDLE_X_ORIGIN, CV_HANDLE_Y_ORIGIN, CV_HANDLE_WIDTH, CV_HANDLE_HEIGHT);
    
    // if the curtain locked in the up position
    if (bIsCurtainLocked == YES)
        handleRect = CGRectMake(CV_HANDLE_X_ORIGIN, 0, CV_HANDLE_WIDTH, CV_HANDLE_HEIGHT);
    
    if (CGRectContainsPoint(handleRect, touchLocation))//[[self view] window].frame, touchLocation))
    {
        bIsCurtainBeingDragged = YES;
        curtainOldY = touchLocation.y;
        return;
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (bIsCurtainBeingDragged)
    {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint touchLocation = [touch locationInView:self.view];
        
        for (UIView *subview in [self.view subviews])
        {
            if ([subview tag] == 99)
            {
                CGRect workingFrame = subview.frame;
                workingFrame.origin.y += touchLocation.y - curtainOldY;
                curtainOldY = touchLocation.y;
                if (workingFrame.origin.y < CV_Y_MIN)
                {
                    workingFrame.origin.y = CV_Y_MIN;
                }
                else if (workingFrame.origin.y > CV_Y_MAX)
                {
                    workingFrame.origin.y = CV_Y_MAX;
                }
                
                [subview setFrame:workingFrame];
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView *subview in [self.view subviews])
    {
        if (bIsCurtainBeingDragged == YES && [subview tag] == 99)
        {
            CGRect workingFrame = subview.frame;
            
            if (workingFrame.origin.y == CV_Y_MIN && !bIsCurtainLocked)
            {
                bIsCurtainLocked = YES;
            }
            else
            {
                int releaseHeight = 0 - workingFrame.origin.y;
                workingFrame.origin.y = 0;
                CGPoint center = CGPointMake(workingFrame.origin.x + workingFrame.size.width/2, workingFrame.origin.y + workingFrame.size.height/2);
                
                [UIView animateWithDuration:CV_ANIMATION_DURATION delay:CV_ANIMATION_DELAY options:UIViewAnimationCurveEaseOut animations:^{
                    subview.center = center;
                    NSLog(@"Animation Start");
                }
                completion:^(BOOL finished) {
                    int bounceCount = (arc4random() % 3) + 1;
                    int bounceHeight = CV_LOWEST_BOUNCE + arc4random() % CV_BOUNCE_RANGE;
                    if (releaseHeight > 100)
                        [self bounceAnimation:subview withCount:bounceCount andBounceHeight:bounceHeight];
                    NSLog(@"finished animation");
                }];
                bIsCurtainLocked = NO;
            }
            bIsCurtainBeingDragged = NO;
        }
    }
}

- (void)bounceAnimation:(UIView *)view withCount:(int)bounceCount andBounceHeight:(int)bounceHeight
{
    if (bounceCount-- > 0)
    {
        CGRect workingFrame = view.frame;
        CGPoint center = CGPointMake(workingFrame.origin.x + workingFrame.size.width/2, workingFrame.origin.y + workingFrame.size.height/2);
        CGPoint centerBounce = CGPointMake(center.x, center.y - bounceHeight);
        bounceHeight /= 3;
        [UIView animateWithDuration:CV_BOUNCE_DURATION animations:^{
            view.center = centerBounce;
            NSLog(@"Bounce Start");
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:CV_BOUNCE_DURATION animations:^{
                view.center = center;
                NSLog(@"Bounce Finish");
            } completion:^(BOOL finished) {
                [self bounceAnimation:view withCount:bounceCount andBounceHeight:bounceHeight];
            }];
        }];
    }
}

- (BOOL)isPBIVDeviceAndCurrentBidder:(PlayerBidItemView_iPhone *)pbiView
{
    return (pbiView.bidIndex == liarsDice->GetBidCount() &&
            GamePlayers::getInstance().GetClientUID() == liarsDice->GetCurrentUID());
}

- (void)updateDetailedPlayerInfo:(UIView *)view
{
    // extract playerBidItem view from the container view 
    PlayerBidItemView_iPhone *playerBidItem = (PlayerBidItemView_iPhone *)[view viewWithTag:PBIV_TAG];
    
//    if (bidIndexForSelectedBidItem == playerBidItem.bidIndex)
//        return;
    
    bidIndexForSelectedBidItem = playerBidItem.bidIndex;
    NSLog(@"Bid index for selected item %d", bidIndexForSelectedBidItem);
    // if the current highlighted bid item view is the client and it is the clients turn to bid
    // then show bid view
    if (bidIndexForSelectedBidItem == liarsDice->GetBidCount() &&
        GamePlayers::getInstance().GetClientUID() == liarsDice->GetCurrentUID())
    {
        // Show bidding view
        NSLog(@"Show bidding window now %@", [playerBidItem getPlayerName]);
        if (liarsDice->GetBidCount() == 0)
        {
            int newLowestQuantity = liarsDice->GetLowestPossibleBid().bidQuantity;
            [self shiftQuantityButtonRange:newLowestQuantity];
            activeBidItemHighlight.hidden = NO;
            bidSelectionView.hidden = NO;
        }
        else if (liarsDice->LastBidTerminatesRound())
        {
            activeChallengeItemHighlight.hidden = NO;
            challengeView.hidden = NO;
        }
        else
        {
            int newLowestQuantity = liarsDice->GetLowestPossibleBid().bidQuantity;
            [self shiftQuantityButtonRange:newLowestQuantity];
            activeBidOrChallengeItemHighlight.hidden = NO;
            bidSelectionView.hidden = NO;
            challengeView.hidden = NO;
        }
        
        inactiveBidItemHighlight.hidden = YES;
    }
    else if (bidIndexForSelectedBidItem == liarsDice->GetBidCount() -1 &&
             GamePlayers::getInstance().GetClientUID() == liarsDice->GetCurrentUID())
    {
        NSLog(@"Show challenge option now %@", [playerBidItem getPlayerName]);
        activeBidItemHighlight.hidden = YES;
        activeChallengeItemHighlight.hidden = YES;
        activeBidOrChallengeItemHighlight.hidden = YES;
        
        bidSelectionView.hidden = YES;
        challengeView.hidden = YES;
        inactiveBidItemHighlight.hidden = NO;

    }
    else if (bidIndexForSelectedBidItem > liarsDice->GetBidCount())
    {
        NSLog(@"Show info about potential bids %@", [playerBidItem getPlayerName]);
        activeBidItemHighlight.hidden = YES;
        activeChallengeItemHighlight.hidden = YES;
        activeBidOrChallengeItemHighlight.hidden = YES;
        
        bidSelectionView.hidden = YES;
        challengeView.hidden = YES;
        inactiveBidItemHighlight.hidden = NO;
    }
    else if (bidIndexForSelectedBidItem == liarsDice->GetBidCount())
    {
        NSLog(@"Show current bidder info %@", [playerBidItem getPlayerName]);
        activeBidItemHighlight.hidden = YES;
        activeChallengeItemHighlight.hidden = YES;
        activeBidOrChallengeItemHighlight.hidden = YES;
        bidSelectionView.hidden = YES;
        challengeView.hidden = YES;
        inactiveBidItemHighlight.hidden = NO;
    }
    else
    {
        NSLog(@"Show previous bid info %@",[playerBidItem getPlayerName]);
        activeBidItemHighlight.hidden = YES;
        activeChallengeItemHighlight.hidden = YES;
        activeBidOrChallengeItemHighlight.hidden = YES;
        bidSelectionView.hidden = YES;
        challengeView.hidden = YES;
        inactiveBidItemHighlight.hidden = NO;
    }

}

- (void)updateCurrentPlayerBidItemFaceValue:(int)faceValue
{
//    if (faceValue < 1)
//        return;
    
    UIView *view = [easyTableView.visibleViews objectAtIndex:ETV_PBIV_HIGHLIGHTED_IDX];
    PlayerBidItemView_iPhone *playerBidItem = (PlayerBidItemView_iPhone *)[view viewWithTag:PBIV_TAG];
    [playerBidItem updateBidFaceValue:faceValue];
    
    if (selectedFaceValue > 0 && selectedQuantity > 0)
    {
        int bidOdds = liarsDice->GetProbabilityForPlayer(selectedQuantity, selectedFaceValue, devicePlayerUID);
        [playerBidItem updateBidOdds:bidOdds];
    }
}

- (void)updateCurrentPlayerBidItemQuantity:(int)quantity
{
    if (quantity < 1)
        return;
    
    UIView *view = [easyTableView.visibleViews objectAtIndex:ETV_PBIV_HIGHLIGHTED_IDX];
    PlayerBidItemView_iPhone *playerBidItem = (PlayerBidItemView_iPhone *)[view viewWithTag:PBIV_TAG];
    [playerBidItem updateBidQuantity:quantity];
    
    if (selectedFaceValue > 0 && selectedQuantity > 0)
    {
        int bidOdds = liarsDice->GetProbabilityForPlayer(selectedQuantity, selectedFaceValue, devicePlayerUID);
        [playerBidItem updateBidOdds:bidOdds];
    }
}

- (void)viewDidUnload
{
    bidSelectionView = nil;
    selectPosition1ButtonView = nil;
    activeBidItemHighlight = nil;
    inactiveBidItemHighlight = nil;
    challengeView = nil;
    activeBidOrChallengeItemHighlight = nil;
    activeChallengeItemHighlight = nil;
    activeChallengeItemHighlight = nil;
    activeBidItemHighlight = nil;
    activeChallengeItemHighlight = nil;
    leftSideLabel = nil;
    rightSideLabel = nil;
    [super viewDidUnload];
}
@end
