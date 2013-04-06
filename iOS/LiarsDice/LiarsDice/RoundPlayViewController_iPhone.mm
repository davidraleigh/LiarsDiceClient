//
//  RoundPlayViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/5/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "RoundPlayViewController_iPhone.h"
#import "PlayersShowDiceViewController_iPhone.h"


#import "ScrollingDiceView.h"
#import "EasyTableView.h"
#import "PlayerBidItemView_iPhone.h"
#import "StringConversion.h"

#import <LiarsDiceEngine.h>
#import <Round.h>
#import <GamePlayers.h>


// PlayerBitItem defines for EasyTableView Layout
#define NUM_OF_VSISIBLE_BID_ITEMS 5
#define BLANK_BID_ITEMS_TO_RIGHT 1
#define BLANK_BID_ITEMS_TO_LEFT 3
#define NEXT_NEXT_PLAYER_BID_ITEM BLANK_BID_ITEMS_TO_LEFT
#define NEXT_PLAYER_BID_ITEM NEXT_NEXT_PLAYER_BID_ITEM + 1
#define CURRENT_BIDDER_BID_ITEM NEXT_PLAYER_BID_ITEM + 1
#define HIGHLIGHTED_BID_ITEM 3
// PlayerBitItem defines for EasyTableView Layout

// BID VIEW
#define PLAYER_BID_ITEM_VIEW_TAG 88
#define FACE_VALUE_TAGS 700
// BID VIEW

// TODO REPLACE THIS TEST CODE
#define MAX_BID_QUANTITY 32
#define MIN_FACE_VALUE 3
#define MIN_BID_QUANTITY 1
#define DICE_COUNT 7
// TODO REPLACE THIS TEST CODE

// #DEFINES FOR SCROLLINGDICEVIEW
#define SCROLLING_DICE_VIEW_X_ORIGIN 10
#define CENTER_OF_WINDOW_Y 90
#define DICE_PIXEL_SEPARATION 2
// #DEFINES FOR SCROLLINGDICEVIEW

// #DEFINES FOR CURTAIN
#define Y_HEIGHT 320
#define X_ORIGIN_HANDLE 171
#define Y_ORIGIN_HANDLE 265
#define Y_MIN_FOR_CURTAIN -Y_ORIGIN_HANDLE
#define Y_MAX_FOR_CURTAIN 0
#define WIDTH_HANDLE 138
#define HEIGHT_HANDLE 56
#define CURTAIN_DESCENT_ANIMATION_DURATION .25
#define CURTAIN_DESCENT_ANIMATION_DELAY .05
#define BOUNCE_DURATION .1
#define BOUNCE_RANGE 8
#define LOWEST_BOUNCE 6

// #DEFINES FOR CURTAIN

// #DEFINES FOR BidView
#define X_ORIGIN_BID_VIEW 0
#define Y_ORIGIN_BID_VIEW 143
// #DEFINES FOR BidView

// #DEFINES FOR EASYTABLEVIEW
//#define SHOW_MULTIPLE_SECTIONS		1		// If commented out, multiple sections with header and footer views are not shown

#define ORIGIN_Y                    12
#define ORIGIN_X                    17
#define SEPARATION_BETWEEN_BID_ITEMS 13
#define LANDSCAPE_WIDTH             460
#define STARTUP_OFFSET_COUNT        2
//#define LANDSCAPE_HEIGHT			98
//#define TABLEVIEW_HEIGHT            94
//#define TABLEVIEW_WIDTH             164
#define TABLE_BACKGROUND_COLOR		[UIColor clearColor]

#define BORDER_VIEW_TAG				10
#define PLAYER_BID_ITEM_TAG         11

#ifdef SHOW_MULTIPLE_SECTIONS
#define NUM_OF_CELLS			10
#define NUM_OF_SECTIONS			2
#else
#define NUM_OF_CELLS			21
#endif
// #DEFINES FOR EASYTABLEVIEW

#define NUM_OF_SELECTABLE_QUANTITIES 5
#define QUANTITY_TAG_BASE 660

@interface RoundPlayViewController_iPhone (MyPrivateMethods)
- (void)setupHorizontalView;
@end

@implementation RoundPlayViewController_iPhone

@synthesize horizontalView;

- (id)initWithLiarsDice:(std::shared_ptr<LiarsDiceEngine>)liarsDiceEngine
{
    self = [super initWithNibName:@"RoundPlayViewController_iPhone" bundle:nil];
    if (self)
    {
        liarsDice = liarsDiceEngine;
        CGSize viewSize = [[[PlayerBidItemView_iPhone alloc] init] getSize];
        tableviewHeight = (int)viewSize.height;
        tableviewWidth = (int)viewSize.width + SEPARATION_BETWEEN_BID_ITEMS;
        landscapeHeight = (int)tableviewHeight + 4;
        maxRollDuration = 0;
        devicePlayerUID = GamePlayers::getInstance().GetClientUID();
        bidIndexForSelectedBidItem = HIGHLIGHTED_BID_ITEM;
        selectedFaceValue = 0;
        isCurtainLocked = NO;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    double xOrigin = SCROLLING_DICE_VIEW_X_ORIGIN;
    liarsDice->StartRound();
    int diceCount = liarsDice->GetPlayersDiceCount(devicePlayerUID);
    std::vector<int> playersDice = liarsDice->GetPlayersDice(devicePlayerUID);
    for (int i = 0; i < diceCount; i++)
    {
        NSString *fileName = [[NSString alloc] initWithFormat:@"LD_DiceScroll_%d.png", i + 1];
        UIImage *uiImage = [UIImage imageNamed:fileName];
        
        CGRect frame = CGRectMake(xOrigin, CENTER_OF_WINDOW_Y, uiImage.size.width / 2, uiImage.size.height / 2);
        xOrigin += frame.size.width + DICE_PIXEL_SEPARATION;
        
        ScrollingDiceView *scrollingDice = [[ScrollingDiceView alloc]initWithFrame:frame andFaceValue:playersDice[i]];
        
        [scrollingDice setImage:uiImage];
        [scrollingDice setTag:i + 1];
        
        double tempMaxDuration = [scrollingDice getCompleteDuration];
        if (tempMaxDuration > maxRollDuration)
            maxRollDuration = tempMaxDuration;
        
        [self.view insertSubview:scrollingDice atIndex:1 + i];
    }
    
    // Get the bid selection view
    bidSelectionView.hidden = YES;
    
    // Do any additional setup after loading the view from its nib.
	[self setupHorizontalView];

    currentLowestQuantity = MIN_BID_QUANTITY;
}

- (void) viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear:animated];
    NSLog(@"viewWillAppear");

}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear");
    CGPoint offsetPoint = CGPointMake(STARTUP_OFFSET_COUNT * tableviewWidth, 0);
    [horizontalView setContentOffset:offsetPoint];
    //[self updateDetailedPlayerInfo:[horizontalView.visibleViews objectAtIndex:HIGHLIGHTED_BID_ITEM]];
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

- (void)setupHorizontalView
{
	CGRect frameRect	= CGRectMake(ORIGIN_X, ORIGIN_Y, LANDSCAPE_WIDTH, landscapeHeight);
	EasyTableView *view	= [[EasyTableView alloc] initWithFrame:frameRect numberOfColumns:7 ofWidth:tableviewWidth];
	self.horizontalView = view;
	
	horizontalView.delegate						= self;
	horizontalView.tableView.backgroundColor	= TABLE_BACKGROUND_COLOR;
	horizontalView.tableView.separatorColor		= [UIColor clearColor];
	horizontalView.cellBackgroundColor			= [UIColor clearColor];
	horizontalView.autoresizingMask				= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    UIView *gamePlayView = [self.view viewWithTag:99];
	[gamePlayView addSubview:horizontalView];
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
    playerBidItemView.tag = PLAYER_BID_ITEM_TAG;
    [container addSubview:playerBidItemView];
    
	return container;
}

// Second delegate populates the views with data from a data source
- (void)easyTableView:(EasyTableView *)easyTableView
       setDataForView:(UIView *)view
         forIndexPath:(NSIndexPath *)indexPath
{
    PlayerBidItemView_iPhone *playerBidItem = (PlayerBidItemView_iPhone *)[view viewWithTag:PLAYER_BID_ITEM_TAG];
    
    // this is the index of the last bid
    // TODO fix this so that it works a bit differently for only two players
    int indexOfBidInEasyTable = [indexPath row];
    
    int currentBidCount = liarsDice->GetBidCount();
    
    if (indexOfBidInEasyTable < BLANK_BID_ITEMS_TO_LEFT ||
        indexOfBidInEasyTable >= currentBidCount + NUM_OF_VSISIBLE_BID_ITEMS + BLANK_BID_ITEMS_TO_RIGHT)
    {
        // first we check to make sure the first two and
        // the last two playerBidItems are invisible
        [playerBidItem setAsEmpty];
        //playerBidItem.bidIndex = indexOfBidOnScreen == 1 ? liarsDice->GetBidCount() + 1 : liarsDice->GetBidCount() + 2;
    }
    
    else if (indexOfBidInEasyTable == NEXT_NEXT_PLAYER_BID_ITEM)
    {
        // This is for the case of the player after the next player
        unsigned int nextNextPlayerUID = liarsDice->GetNextPlayerUID(liarsDice->GetNextPlayerUID());
        std::string playerNameString = liarsDice->GetPlayerName(nextNextPlayerUID);
        NSString *playerName = [NSString stringWithstring: playerNameString];
        // TODO replace with setEmpty method
        [playerBidItem setPlayerName:playerName bidQuantity:-2 bidFaceValue:0 bidOdds:0];
        
        playerBidItem.bidIndex = currentBidCount + 2;
    }
    else if (indexOfBidInEasyTable == NEXT_PLAYER_BID_ITEM)
    {
        // This is the case of the next player
        unsigned int nextPlayerUID = liarsDice->GetNextPlayerUID();
        std::string playerNameString = liarsDice->GetPlayerName(nextPlayerUID);
        NSString *playerName = [NSString stringWithstring: playerNameString];
        // TODO replace with setEmpty method
        [playerBidItem setPlayerName:playerName bidQuantity:-1 bidFaceValue:0 bidOdds:0];
        
        playerBidItem.bidIndex = currentBidCount + 1;
    }
    else if (indexOfBidInEasyTable == CURRENT_BIDDER_BID_ITEM)
    {
        // the case where the player bid view is the currently bidding player
        unsigned int currentPlayerUID = liarsDice->GetCurrentUID();
        std::string playerNameString = liarsDice->GetPlayerName(currentPlayerUID);
        NSString *playerName = [NSString stringWithstring: playerNameString];
        [playerBidItem setPlayerName:playerName bidQuantity:0
                        bidFaceValue:0 bidOdds:0];

        playerBidItem.bidIndex = currentBidCount;
    }
    else if (indexOfBidInEasyTable > CURRENT_BIDDER_BID_ITEM &&
             currentBidCount + indexOfBidInEasyTable > CURRENT_BIDDER_BID_ITEM + 1)
    {
        // all other cases of bids that have already been made
        int bidIndex = indexOfBidInEasyTable - (CURRENT_BIDDER_BID_ITEM + 1);
        RoundDetails::bid_t bid = liarsDice->GetBid(bidIndex);
        std::string playerNameString = liarsDice->GetPlayerName(bid.playerUID);
        NSString *playerName = [NSString stringWithstring: playerNameString];
        [playerBidItem setPlayerName:playerName bidQuantity:bid.bidQuantity bidFaceValue:bid.bidFaceValue bidOdds:0];
        
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
    return liarsDice->GetBidCount() + 7;
}

- (void)changeQuantityPositionBy:(int)shiftValue atButtonPosition:(int)buttonPositionSelected
{
    RoundDetails::bid_t lowestBid = liarsDice->GetLowestPossibleBid();
    int remainingDice = liarsDice->GetTotalDieLeft();
    
    if (shiftValue + currentLowestQuantity < lowestBid.bidQuantity && shiftValue < 0)
        shiftValue = lowestBid.bidQuantity - currentLowestQuantity;
    else if(shiftValue + currentLowestQuantity + (NUM_OF_SELECTABLE_QUANTITIES - 1) > remainingDice)
        shiftValue = remainingDice - (NUM_OF_SELECTABLE_QUANTITIES - 1) - currentLowestQuantity;
    
    if ((currentLowestQuantity == lowestBid.bidQuantity && shiftValue < 0) ||
        (currentLowestQuantity + (NUM_OF_SELECTABLE_QUANTITIES - 1) == remainingDice && shiftValue > 0))
        shiftValue = 0;
    
    int largestShiftOffset = (NUM_OF_SELECTABLE_QUANTITIES / 2);
    if (shiftValue > largestShiftOffset || shiftValue < -largestShiftOffset)
        NSLog(@"Shift Value should never be greater than %d or less than -%d", largestShiftOffset, largestShiftOffset);
    
    int newSelectedPosition = buttonPositionSelected - shiftValue;
    currentLowestQuantity += shiftValue;
    
    for (int position = 1; position <= NUM_OF_SELECTABLE_QUANTITIES; position++)
    {
        int tag = QUANTITY_TAG_BASE + position;
        UIButton *button = (UIButton *)[self searchSubviewsForTaggedView:tag inSubviews:self.view];
        if (!button || ![button isKindOfClass:[UIView class]])
        {
            NSLog(@"One of the tag numbers is not associated with a view or a tag is not properly associated with a UIButton");
            continue;
        }
        
        int quantityValue = currentLowestQuantity + position - 1;
        NSLog(@"Button position: %d and button value: %d", position, quantityValue);
        
        if (newSelectedPosition != currentHighlightedPosition &&
            currentHighlightedPosition == position)
        {
            [self deselectQuantityValue:quantityValue withButton:button];
//            selectedQuantity = 0;
        }
        else if (newSelectedPosition == position)
        {
            [self selectQuantityValue:quantityValue withButton:button];
            selectedQuantity = quantityValue;
        }
        else
        {
            [self deselectQuantityValue:quantityValue withButton:button];
        }
        
    }
    currentHighlightedPosition = newSelectedPosition;
}



- (void)deselectFaceValue:(int)faceValue
{
    UIButton *view = (UIButton*)[self searchSubviewsForTaggedView:FACE_VALUE_TAGS + selectedFaceValue inSubviews:self.view];
    NSString *fileName = [[NSString alloc] initWithFormat:@"LD_Die_%d.png", selectedFaceValue];
    [view setImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
}

- (void)deselectQuantityValue:(int)quantityValue withButton:(UIButton *)button
{
    NSString *fileName = [[NSString alloc] initWithFormat:@"LD_BidNumber_%d.png", quantityValue];
    [button setImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
}

- (void)deselectQuantityValue:(int)quantityValue atPosition:(int)position
{
    UIButton *view = (UIButton *)[self searchSubviewsForTaggedView:QUANTITY_TAG_BASE + position inSubviews:self.view];
    [self deselectQuantityValue:quantityValue withButton:view];
}

- (void)selectFaceValue:(int)faceValue withButton:(UIButton *)button
{
    NSString *fileName = [[NSString alloc] initWithFormat:@"LD_Die_Highlight_%d.png", faceValue];
    [button setImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
}

- (void)selectQuantityValue:(int)quantityValue withButton:(UIButton *)button
{
    NSString *fileName = [[NSString alloc] initWithFormat:@"LD_BidNumber_Highlight_%d.png", quantityValue];
    [button setImage:[UIImage imageNamed:fileName] forState:UIControlStateNormal];
}

- (void)updateDieFaceButton:(UIButton *)button withValue:(int)faceValue
{
    if (selectedFaceValue != faceValue)
    {
        // deselect button
        if (selectedFaceValue != 0)
            [self deselectFaceValue:selectedFaceValue];
        
        [self selectFaceValue:faceValue withButton:button];
        selectedFaceValue = faceValue;
    }
    else
    {
        [self deselectFaceValue:selectedFaceValue];
        selectedFaceValue = 0;
    }
}

- (IBAction)faceValueButton1:(id)sender
{
    UIButton *theButton = (UIButton*)sender;
    [self updateDieFaceButton:theButton withValue:1];
}

- (IBAction)faceValueButton2:(id)sender
{
    UIButton *theButton = (UIButton*)sender;
    [self updateDieFaceButton:theButton withValue:2];
}

- (IBAction)faceValueButton3:(id)sender
{
    UIButton *theButton = (UIButton*)sender;
    [self updateDieFaceButton:theButton withValue:3];
}

- (IBAction)faceValueButton4:(id)sender
{
    UIButton *theButton = (UIButton*)sender;
    [self updateDieFaceButton:theButton withValue:4];
}

- (IBAction)faceValueButton5:(id)sender
{
    UIButton *theButton = (UIButton*)sender;
    [self updateDieFaceButton:theButton withValue:5];
}

- (IBAction)faceValueButton6:(id)sender
{
    UIButton *theButton = (UIButton*)sender;
    [self updateDieFaceButton:theButton withValue:6];
}

- (void)updateQuantityButton:(UIButton *)button withPosition:(int)position
{
    // the shift value is based off of the number of selectable quantities.
    // and the position of the current button
    int shiftValue = position - (1 + NUM_OF_SELECTABLE_QUANTITIES / 2);
    if (currentHighlightedPosition != position)
    {
        [self changeQuantityPositionBy:shiftValue atButtonPosition:position];
    }
    else
    {
        [self deselectQuantityValue:selectedQuantity atPosition:position];
        selectedQuantity = 0;
        currentHighlightedPosition = 0;
    }
}

- (IBAction)quantityPositionButton1:(id)sender
{
    [self updateQuantityButton:sender withPosition:1];
}

- (IBAction)quantityPositionButton2:(id)sender
{
    [self updateQuantityButton:sender withPosition:2];
}

- (IBAction)quantityPositionButton3:(id)sender
{
    [self updateQuantityButton:sender withPosition:3];
}

- (IBAction)quantityPositionButton4:(id)sender
{
    [self updateQuantityButton:sender withPosition:4];
}

- (IBAction)quantityPositionButton5:(id)sender
{
    [self updateQuantityButton:sender withPosition:5];
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
    [horizontalView reloadData];
    [self updateDetailedPlayerInfo:[horizontalView.visibleViews objectAtIndex:HIGHLIGHTED_BID_ITEM]];
}

- (IBAction)qaChallengeButton:(id)sender
{
    liarsDice->Challenge();
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
        PlayersShowDiceViewController_iPhone *psdvc = [[PlayersShowDiceViewController_iPhone alloc] initWithLiarsDice:liarsDice];
        [[self navigationController] pushViewController:psdvc animated:YES];
    }
    else
    {
        liarsDice->Bid(bidValue.bidQuantity, bidValue.bidFaceValue);
        [horizontalView reloadData];
        [self updateDetailedPlayerInfo:[horizontalView.visibleViews objectAtIndex:HIGHLIGHTED_BID_ITEM]];
    }
}

- (IBAction)rollDiceButton:(id)sender
{
    //liarsDice->StartRound();
    if ([self.view subviews])
    {
        // Make sure we have a chance to discover devices before showing the user that nothing was found (yet)
        double interval = 1.0 / [ScrollingDiceView animationHZ];
        myTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(rollDice) userInfo:nil repeats:YES];
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
    CGRect handleRect = CGRectMake(X_ORIGIN_HANDLE, Y_ORIGIN_HANDLE, WIDTH_HANDLE, HEIGHT_HANDLE);
    
    // if the curtain locked in the up position
    if (isCurtainLocked == YES)
        handleRect = CGRectMake(X_ORIGIN_HANDLE, 0, WIDTH_HANDLE, HEIGHT_HANDLE);
    
    if (CGRectContainsPoint(handleRect, touchLocation))//[[self view] window].frame, touchLocation))
    {
        dragging = YES;
        oldY = touchLocation.y;
        return;
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (dragging)
    {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint touchLocation = [touch locationInView:self.view];
        
        for (UIView *subview in [self.view subviews])
        {
            if ([subview tag] == 99)
            {
                CGRect workingFrame = subview.frame;
                workingFrame.origin.y += touchLocation.y - oldY;
                oldY = touchLocation.y;
                if (workingFrame.origin.y < Y_MIN_FOR_CURTAIN)
                {
                    workingFrame.origin.y = Y_MIN_FOR_CURTAIN;
                }
                else if (workingFrame.origin.y > Y_MAX_FOR_CURTAIN)
                {
                    workingFrame.origin.y = Y_MAX_FOR_CURTAIN;
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
        if (dragging == YES && [subview tag] == 99)
        {
            CGRect workingFrame = subview.frame;
            
            if (workingFrame.origin.y == Y_MIN_FOR_CURTAIN && !isCurtainLocked)
            {
                isCurtainLocked = YES;
            }
            else
            {
                int releaseHeight = 0 - workingFrame.origin.y;
                workingFrame.origin.y = 0;
                CGPoint center = CGPointMake(workingFrame.origin.x + workingFrame.size.width/2, workingFrame.origin.y + workingFrame.size.height/2);
                
                [UIView animateWithDuration:CURTAIN_DESCENT_ANIMATION_DURATION delay:CURTAIN_DESCENT_ANIMATION_DELAY options:UIViewAnimationCurveEaseOut animations:^{
                    subview.center = center;
                    NSLog(@"Animation Start");
                }
                completion:^(BOOL finished) {
                    int bounceCount = (arc4random() % 3) + 1;
                    int bounceHeight = LOWEST_BOUNCE + arc4random() % BOUNCE_RANGE;
                    if (releaseHeight > 100)
                        [self bounceAnimation:subview withCount:bounceCount andBounceHeight:bounceHeight];
                    NSLog(@"finished animation");
                }];
                isCurtainLocked = NO;
            }
            dragging = NO;
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
        [UIView animateWithDuration:BOUNCE_DURATION animations:^{
            view.center = centerBounce;
            NSLog(@"Bounce Start");
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:BOUNCE_DURATION animations:^{
                view.center = center;
                NSLog(@"Bounce Finish");
            } completion:^(BOOL finished) {
                [self bounceAnimation:view withCount:bounceCount andBounceHeight:bounceHeight];
            }];
        }];
    }
}

- (void)updateDetailedPlayerInfo:(UIView *)view
{
    PlayerBidItemView_iPhone *playerBidItem = (PlayerBidItemView_iPhone *)[view viewWithTag:PLAYER_BID_ITEM_TAG];
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
        bidHighlight.hidden = NO;
        bidSelectionView.hidden = NO;
        bullshitView.hidden = NO;
        nonBidHighlight.hidden = YES;
    }
    else if (bidIndexForSelectedBidItem == liarsDice->GetBidCount() -1 &&
             GamePlayers::getInstance().GetClientUID() == liarsDice->GetCurrentUID())
    {
        NSLog(@"Show challenge option now %@", [playerBidItem getPlayerName]);
        bidHighlight.hidden = YES;
        bidSelectionView.hidden = YES;
        bullshitView.hidden = YES;
        nonBidHighlight.hidden = NO;

    }
    else if (bidIndexForSelectedBidItem > liarsDice->GetBidCount())
    {
        NSLog(@"Show info about potential bids %@", [playerBidItem getPlayerName]);
        bidHighlight.hidden = YES;
        bidSelectionView.hidden = YES;
        bullshitView.hidden = YES;
        nonBidHighlight.hidden = NO;
    }
    else if (bidIndexForSelectedBidItem == liarsDice->GetBidCount())
    {
        NSLog(@"Show current bidder info %@", [playerBidItem getPlayerName]);
        bidHighlight.hidden = YES;
        bidSelectionView.hidden = YES;
        bullshitView.hidden = YES;
        nonBidHighlight.hidden = NO;
    }
    else
    {
        NSLog(@"Show previous bid info %@",[playerBidItem getPlayerName]);
        bidHighlight.hidden = YES;
        bidSelectionView.hidden = YES;
        bullshitView.hidden = YES;
        nonBidHighlight.hidden = NO;
    }

}
- (void)viewDidUnload
{
    bidSelectionView = nil;
    nonBidHighlight = nil;
    bidHighlight = nil;
    bullshitView = nil;
    [super viewDidUnload];
}
@end
