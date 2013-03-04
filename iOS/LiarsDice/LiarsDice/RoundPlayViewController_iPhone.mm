//
//  RoundPlayViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/5/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "RoundPlayViewController_iPhone.h"

#import "ScrollingDiceView.h"
#import "EasyTableView.h"
#import "PlayerBidItemView_iPhone.h"
#import "BidView_iPhone.h"
#import "StringConversion.h"

#import <LiarsDiceEngine.h>
#import <Round.h>
#import <GamePlayers.h>


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
#define Y_MIN_FOR_CURTAIN -258
#define Y_MAX_FOR_CURTAIN 0
#define X_ORIGIN_HANDLE 171
#define Y_ORIGIN_HANDLE 265
#define WIDTH_HANDLE 138
#define HEIGHT_HANDLE 56
#define CURTAIN_DESCENT_ANIMATION_DURATION .25
#define CURTAIN_DESCENT_ANIMATION_DELAY .05
#define BOUNCE_DURATION .1
#define BOUNCE_RANGE 8
#define LOWEST_BOUNCE 6

// #DEFINES FOR CURTAIN

// #DEFINES FOR EASYTABLEVIEW
//#define SHOW_MULTIPLE_SECTIONS		1		// If commented out, multiple sections with header and footer views are not shown

#define ORIGIN_Y                    42
#define ORIGIN_X                    17
#define SEPARATION_BETWEEN_BID_ITEMS 17
#define LANDSCAPE_WIDTH             460
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
    
    BidView_iPhone *bidView = [[BidView_iPhone alloc] init];
    CGRect bidViewFrame = bidView.frame;
    bidViewFrame.origin = CGPointMake(0, 143);
    bidView.frame = bidViewFrame;
    [curtainView addSubview:bidView];
    
    // Do any additional setup after loading the view from its nib.
	[self setupHorizontalView];
    currentLowestQuantity = MIN_BID_QUANTITY;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
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
	horizontalView.tableView.allowsSelection	= YES;
	horizontalView.tableView.separatorColor		= [UIColor darkGrayColor];
	horizontalView.cellBackgroundColor			= [UIColor clearColor];
	horizontalView.autoresizingMask				= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    UIView *gamePlayView = [self.view viewWithTag:99];
	[gamePlayView addSubview:horizontalView];
}


#pragma mark -
#pragma mark Utility Methods

- (void)borderIsSelected:(BOOL)selected forView:(UIView *)view
{
	UIImageView *borderView		= (UIImageView *)[view viewWithTag:BORDER_VIEW_TAG];
	NSString *borderImageName	= (selected) ? @"selected_border.png" : @"image_border.png";
	borderView.image			= [UIImage imageNamed:borderImageName];
}


#pragma mark -
#pragma mark EasyTableViewDelegate

// These delegate methods support both example views - first delegate method creates the necessary views

- (UIView *)easyTableView:(EasyTableView *)easyTableView viewForRect:(CGRect)rect
{
    UIView *container = [[UIView alloc] initWithFrame:rect];
    
    PlayerBidItemView_iPhone *tempView = [[PlayerBidItemView_iPhone alloc] init];
    tempView.tag = PLAYER_BID_ITEM_TAG;
    [container addSubview:tempView];
    
//	CGRect labelRect		= CGRectMake(10, 10, rect.size.width-20, rect.size.height-20);
//	UILabel *label			= [[UILabel alloc] initWithFrame:labelRect];
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//	label.textAlignment		= UITextAlignmentCenter;
//#else
//	label.textAlignment		= NSTextAlignmentCenter;
//#endif
//	label.textColor			= [UIColor whiteColor];
//	label.font				= [UIFont boldSystemFontOfSize:60];
//	
//	// Use a different color for the two different examples
//	if (easyTableView == horizontalView)
//		label.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
//	else
//		label.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
//	
//	UIImageView *borderView		= [[UIImageView alloc] initWithFrame:label.bounds];
//	borderView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//	borderView.tag				= BORDER_VIEW_TAG;
//	
//	[label addSubview:borderView];
    
	return container;
}

- (void)easyTableView:(EasyTableView *)easyTableView scrolledToOffset:(CGPoint)contentOffset
{
    CGFloat contentOffsetRaw = contentOffset.x;
    CGFloat newOffsetX = tableviewWidth * (::round(contentOffsetRaw / ((CGFloat)tableviewWidth)));
    contentOffset.x = newOffsetX;
    
    //tableviewWidth
    [horizontalView setContentOffset:contentOffset];
}

// Second delegate populates the views with data from a data source

- (void)easyTableView:(EasyTableView *)easyTableView
       setDataForView:(UIView *)view
         forIndexPath:(NSIndexPath *)indexPath
{
    PlayerBidItemView_iPhone *playerBidItem = (PlayerBidItemView_iPhone *)[view viewWithTag:PLAYER_BID_ITEM_TAG];
    // this is the index of the last bid
    // TODO fix this so that it works a bit differently for only two players
    int indexOfBid = [indexPath row];
    if (indexOfBid == 0 || indexOfBid == 1 ||
        indexOfBid == liarsDice->GetBidCount() + 5 ||
        indexOfBid == liarsDice->GetBidCount() + 6)
    {
        [playerBidItem setAsEmpty];
    }
    else if (indexOfBid == 2)
    {
        unsigned int nextNextPlayerUID = liarsDice->GetNextPlayerUID(liarsDice->GetNextPlayerUID());
        std::string playerNameString = liarsDice->GetPlayerName(nextNextPlayerUID);
        NSString *playerName = [NSString stringWithstring: playerNameString];
        [playerBidItem setPlayerName:playerName bidQuantity:-2 bidFaceValue:0 bidOdds:0];
    }
    else if (indexOfBid == 3)
    {
        unsigned int nextPlayerUID = liarsDice->GetNextPlayerUID();
        std::string playerNameString = liarsDice->GetPlayerName(nextPlayerUID);
        NSString *playerName = [NSString stringWithstring: playerNameString];
        [playerBidItem setPlayerName:playerName bidQuantity:-1 bidFaceValue:0 bidOdds:0];
    }
    else if (indexOfBid == 4)
    {
        unsigned int currentPlayerUID = liarsDice->GetCurrentUID();
        std::string playerNameString = liarsDice->GetPlayerName(currentPlayerUID);
        NSString *playerName = [NSString stringWithstring: playerNameString];
        [playerBidItem setPlayerName:playerName bidQuantity:0
                        bidFaceValue:0 bidOdds:0];
    }
    else if (indexOfBid > 4 && liarsDice->GetBidCount() + indexOfBid > 5)
    {
        RoundDetails::bid_t bid = liarsDice->GetBid(indexOfBid - 5);
        std::string playerNameString = liarsDice->GetPlayerName(bid.playerUID);
        NSString *playerName = [NSString stringWithstring: playerNameString];
        [playerBidItem setPlayerName:playerName bidQuantity:bid.bidQuantity bidFaceValue:bid.bidFaceValue bidOdds:0];
    }
    [view addSubview:playerBidItem];
}

// Optional delegate to track the selection of a particular cell

- (void)easyTableView:(EasyTableView *)easyTableView
         selectedView:(UIView *)selectedView
          atIndexPath:(NSIndexPath *)indexPath
       deselectedView:(UIView *)deselectedView
{
	[self borderIsSelected:YES forView:selectedView];
	
	if (deselectedView)
		[self borderIsSelected:NO forView:deselectedView];
	
	//UILabel *label	= (UILabel *)selectedView;
	//bigLabel.text	= label.text;
}


#pragma mark -
#pragma mark Optional EasyTableView delegate methods for section headers and footers

// Delivers the number of cells in each section, this must be implemented if numberOfSectionsInEasyTableView is implemented
-(NSUInteger)numberOfCellsForEasyTableView:(EasyTableView *)view inSection:(NSInteger)section
{
    return liarsDice->GetBidCount() + 7;
}








- (void)changeButtonTexts:(int)shiftValue withButtonPosition:(int)buttonPositionSelected
{
    if (shiftValue + currentLowestQuantity < MIN_BID_QUANTITY && shiftValue < 0)
        shiftValue = MIN_BID_QUANTITY - currentLowestQuantity;
    else if(shiftValue + currentLowestQuantity + 5 > MAX_BID_QUANTITY)
        shiftValue = MAX_BID_QUANTITY - 5 - currentLowestQuantity;
    
    if ((currentLowestQuantity == MIN_BID_QUANTITY && shiftValue < 0) ||
        (currentLowestQuantity + 5 == MAX_BID_QUANTITY && shiftValue > 0))
        shiftValue = 0;
    
    if (shiftValue > 3 || shiftValue < -3)
        NSLog(@"Shift Value should never be greater than 3 or less than -3");
    
    int newSelectedPosition = buttonPositionSelected - shiftValue;
    currentLowestQuantity += shiftValue;
    
    for (int tag = 661; tag < 667; tag++)
    {
        UIView *view = [self searchSubviewsForTaggedView:tag inSubviews:self.view];
        if (!view || ![view isKindOfClass:[UIView class]])
        {
            NSLog(@"One of the tag numbers is not associated with a view or a tag is not properly associated with a UIButton");
            continue;
        }
        UIButton *button = (UIButton *)view;
        int additionalShift = tag - 661;
        int currentPosition = additionalShift + 1;
        int buttonValue = currentLowestQuantity + additionalShift;
        NSString *buttonNumber = [[NSString alloc] initWithFormat:@"%d",buttonValue];
        [button setTitle:buttonNumber forState:UIControlStateNormal];
        if (newSelectedPosition != currentHighlightedPosition &&
            currentHighlightedPosition == currentPosition)
            [button setHighlighted:NO];
        if (newSelectedPosition == currentPosition)
            [NSOperationQueue.mainQueue addOperationWithBlock:^{ button.highlighted = YES; }];
    }
    currentHighlightedPosition = newSelectedPosition;

}

- (IBAction)faceValueButton1:(id)sender
{
}

- (IBAction)faceValueButton2:(id)sender
{
}

- (IBAction)faceValueButton3:(id)sender
{
}

- (IBAction)faceValueButton4:(id)sender
{
}

- (IBAction)faceValueButton5:(id)sender
{
}

- (IBAction)faceValueButton6:(id)sender
{
}

- (IBAction)qaAdvanceGame:(id)sender
{
    unsigned int currentUID = liarsDice->GetCurrentUID();
    RoundDetails::bid_t bidValue = liarsDice->GenerateAIBid(currentUID);
    liarsDice->Bid(bidValue.bidQuantity, bidValue.bidFaceValue);
    [horizontalView reloadData];
}

- (IBAction)quantityButton1:(id)sender
{
    //shift -3
    [self changeButtonTexts:-3 withButtonPosition:1];
}

- (IBAction)quantityButton2:(id)sender
{
    // shift -2
    [self changeButtonTexts:-2 withButtonPosition:2];
}

- (IBAction)quantityButton3:(id)sender
{
    // shift -1
    [self changeButtonTexts:-1 withButtonPosition:3];
}

- (IBAction)quantityButton4:(id)sender
{
    // shift 1
    [self changeButtonTexts:1 withButtonPosition:4];
}

- (IBAction)quantityButton5:(id)sender
{
    // shift 2
    [self changeButtonTexts:2 withButtonPosition:5];
}

- (IBAction)quantityButton6:(id)sender
{
    // shift 3
    [self changeButtonTexts:3 withButtonPosition:6];
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
    //
    CGRect handleRect = CGRectMake(X_ORIGIN_HANDLE, Y_ORIGIN_HANDLE, WIDTH_HANDLE, HEIGHT_HANDLE);
    if (CGRectContainsPoint(handleRect, touchLocation))//[[self view] window].frame, touchLocation))
    {
        dragging = YES;
        oldY = touchLocation.y;
    }
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
                    workingFrame.origin.y = Y_MIN_FOR_CURTAIN;
                else if (workingFrame.origin.y > Y_MAX_FOR_CURTAIN)
                    workingFrame.origin.y = Y_MAX_FOR_CURTAIN;
                
                [subview setFrame:workingFrame];
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dragging = NO;
    
    for (UIView *subview in [self.view subviews])
    {
        if ([subview tag] == 99)
        {
            CGRect workingFrame = subview.frame;
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
@end
