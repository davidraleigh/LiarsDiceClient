//
//  SummarizeRoundViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/1/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "SummarizeRoundViewController_iPhone.h"

#import "RoundPlayViewController_iPhone.h"
#import "EasyTableView.h"
#import "PlayerBidItemView_iPhone.h"
#import "StringConversion.h"

#include <GamePlayers.h>
#include <LiarsDiceEngine.h>


@interface SummarizeRoundViewController_iPhone ()
- (void)setupEasyTableView;
@end

@implementation SummarizeRoundViewController_iPhone

@synthesize easyTableView;

- (id)initWithLiarsDice:(std::shared_ptr<LiarsDiceEngine>)liarsDiceEngine
{
    self = [super initWithNibName:@"SummarizeRoundViewController_iPhone" bundle:nil];
    if (self)
    {
        liarsDice = liarsDiceEngine;
        CGSize bidItemViewSize = [[[PlayerBidItemView_iPhone alloc] init] getSize];
        bidItemViewWidth = (int)bidItemViewSize.width + RPVC_ETV_SEPARATION_BETWEEN_PBIV;
        bidItemViewHeight = (int)bidItemViewSize.height;

        devicePlayerUID = GamePlayers::getInstance().GetClientUID();
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupEasyTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupEasyTableView
{
	CGRect frameRect	= CGRectMake(RPVC_ETV_ORIGIN_X, RPVC_ETV_ORIGIN_Y, RPVC_ETV_WIDTH, bidItemViewHeight + RPVC_ETV_EXTRA_VERT_FOR_PBIV);
	EasyTableView *view	= [[EasyTableView alloc] initWithFrame:frameRect numberOfColumns: RPVC_ETV_NUM_VISIBLE_PBIV ofWidth:bidItemViewWidth];
	self.easyTableView = view;
	
	easyTableView.delegate						= self;
	easyTableView.tableView.backgroundColor     = RPVC_ETV_BACKGROUND_COLOR;
	easyTableView.tableView.separatorColor		= [UIColor clearColor];
	easyTableView.cellBackgroundColor			= [UIColor clearColor];
	easyTableView.autoresizingMask				= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
	[self.view addSubview:easyTableView];
}

- (IBAction)continueGameButton:(id)sender
{
//    NSArray *array = [self.navigationController viewControllers];
//    
//    int rpvc_index = [array count] - 3;
//    RoundPlayViewController_iPhone *rpvc = (RoundPlayViewController_iPhone *)[array objectAtIndex:rpvc_index];
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToViewController:rpvc animated:YES];
}

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

//// The height of the header section view MUST be the same as your HORIZONTAL_TABLEVIEW_HEIGHT (horizontal EasyTableView only)
//- (UIView *)easyTableView:(EasyTableView*)easyTableView viewForHeaderInSection:(NSInteger)section
//{
//    CGRect rect = CGRectMake(0, 0, bidItemViewWidth, bidItemViewHeight);
//    UIView *container = [[UIView alloc] initWithFrame:rect];
//    
//    PlayerBidItemView_iPhone *playerBidItem = [[PlayerBidItemView_iPhone alloc] init];
//    playerBidItem.tag = PBIV_TAG;
//    [playerBidItem setAsHeader:section +1];
//    [container addSubview:playerBidItem];
//    
//    return container;
//}
//
//- (UIView *)easyTableView:(EasyTableView*)easyTableView viewForFooterInSection:(NSInteger)section
//{
//    CGRect rect = CGRectMake(0, 0, bidItemViewWidth, bidItemViewHeight);
//    UIView *container = [[UIView alloc] initWithFrame:rect];
//    
//    PlayerBidItemView_iPhone *playerBidItem = [[PlayerBidItemView_iPhone alloc] init];
//    playerBidItem.tag = PBIV_TAG;
//    [playerBidItem setAsFooter:section +1];
//    [container addSubview:playerBidItem];
//    
//    return container;
//}

// Second delegate populates the views with data from a data source
- (void)easyTableView:(EasyTableView *)easyTableView
       setDataForView:(UIView *)view
         forIndexPath:(NSIndexPath *)indexPath
{
    PlayerBidItemView_iPhone *playerBidItem = (PlayerBidItemView_iPhone *)[view viewWithTag:PBIV_TAG];
    
    // this is the index of the last bid
    // TODO fix this so that it works a bit differently for only two players
    int indexOfBidInEasyTable = [indexPath row];
    
    // all other cases of bids that have already been made
    int bidIndex = indexOfBidInEasyTable ;
    RoundDetails::bid_t bid = liarsDice->GetBid(bidIndex);
    std::string playerNameString = liarsDice->GetPlayerName(bid.playerUID);
    NSString *playerName = [NSString stringWithstring: playerNameString];
    [playerBidItem setPlayerName:playerName bidQuantity:bid.bidQuantity bidFaceValue:bid.bidFaceValue bidOdds:0];
    
    if (RoundDetails::HonestBid == bid.bidType)
        [playerBidItem highlightGreen];
    else if(RoundDetails::SoftLieBid == bid.bidType)
        [playerBidItem highlightYellow];
    else if (RoundDetails::HardLieBid == bid.bidType)
        [playerBidItem highlightRed];
    
    playerBidItem.bidIndex = bidIndex;
    
    [view addSubview:playerBidItem];
}

// Delivers the number of cells in each section, this must be implemented if numberOfSectionsInEasyTableView is implemented
-(NSUInteger)numberOfCellsForEasyTableView:(EasyTableView *)view inSection:(NSInteger)section
{
    int roundIndex = liarsDice->GetRoundCount() - 1;
    int bidCountForRound = liarsDice->GetBidCountForRound(roundIndex);
    return bidCountForRound;
}


//- (void)easyTableView:(EasyTableView *)easyTableView viewAtCenter:(UIView *)view
//{
//    [
//}

@end
