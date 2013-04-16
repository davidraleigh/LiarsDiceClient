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
        bidItemViewWidth = (int)bidItemViewSize.width;
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
	CGRect frameRect	= CGRectMake(RPVC_ETV_ORIGIN_X - bidItemViewWidth, RPVC_ETV_ORIGIN_Y, RPVC_ETV_WIDTH + (bidItemViewWidth * 2), bidItemViewHeight + RPVC_ETV_EXTRA_VERT_FOR_PBIV);
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
    NSArray *array = [self.navigationController viewControllers];
    
    int rpvc_index = [array count] - 3;
    RoundPlayViewController_iPhone *rpvc = (RoundPlayViewController_iPhone *)[array objectAtIndex:rpvc_index];
    
    [self.navigationController popToViewController:rpvc animated:YES];
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

// The height of the header section view MUST be the same as your HORIZONTAL_TABLEVIEW_HEIGHT (horizontal EasyTableView only)
- (UIView *)easyTableView:(EasyTableView*)easyTableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
	label.text = [[NSString alloc] initWithFormat:@"Round #%d -->",section + 1];
	label.textColor = [UIColor whiteColor];

	label.textAlignment		= NSTextAlignmentCenter;

    label.frame = CGRectMake(0, 0, bidItemViewWidth, bidItemViewHeight);

    
    switch (section)
    {
        case 0:
            label.backgroundColor = [UIColor redColor];
            break;
        default:
            label.backgroundColor = [UIColor blueColor];
            break;
    }
    return label;
}

- (UIView *)easyTableView:(EasyTableView*)easyTableView viewForFooterInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
	label.text = [[NSString alloc] initWithFormat:@"<-- Round #%d",section + 1];
	label.textColor = [UIColor yellowColor];
    
	label.textAlignment		= NSTextAlignmentCenter;
    
    label.frame = CGRectMake(0, 0, bidItemViewWidth, bidItemViewHeight);
	
    switch (section) {
        case 0:
            label.backgroundColor = [UIColor purpleColor];
            break;
        default:
            label.backgroundColor = [UIColor brownColor];
            break;
    }
    
    return label;
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
    
    int bidCountForGame = liarsDice->GetBidCountForGame();
    
    // all other cases of bids that have already been made
        int bidIndex = indexOfBidInEasyTable ;
        RoundDetails::bid_t bid = liarsDice->GetBid(bidIndex);
        std::string playerNameString = liarsDice->GetPlayerName(bid.playerUID);
        NSString *playerName = [NSString stringWithstring: playerNameString];
        [playerBidItem setPlayerName:playerName bidQuantity:bid.bidQuantity bidFaceValue:bid.bidFaceValue bidOdds:0];
        
        playerBidItem.bidIndex = bidIndex;
    
    [view addSubview:playerBidItem];
}

// Delivers the number of sections in the TableView
- (NSUInteger)numberOfSectionsInEasyTableView:(EasyTableView*)easyTableView
{
    int roundCountForGame = liarsDice->GetRoundCount();
    return roundCountForGame;
}

// Delivers the number of cells in each section, this must be implemented if numberOfSectionsInEasyTableView is implemented
-(NSUInteger)numberOfCellsForEasyTableView:(EasyTableView *)view inSection:(NSInteger)section
{
    int bidCountForRound = liarsDice->GetBidCountForRound(section);
    return bidCountForRound;
}


//- (void)easyTableView:(EasyTableView *)easyTableView viewAtCenter:(UIView *)view
//{
//    [
//}

@end
