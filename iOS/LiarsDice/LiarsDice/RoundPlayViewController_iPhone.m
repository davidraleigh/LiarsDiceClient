//
//  RoundPlayViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/5/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "RoundPlayViewController_iPhone.h"

#import "EasyTableView.h"
#import "PlayerBidItemStore.h"
#import "PlayerBidItemView_iPhone.h"


// TODO REPLACE THIS TEST CODE
#define MAX_BID_QUANTITY 32
#define MIN_FACE_VALUE 3
#define MIN_BID_QUANTITY 1
// TODO REPLACE THIS TEST CODE

// #defines for EasyTableView
//#define SHOW_MULTIPLE_SECTIONS		1		// If commented out, multiple sections with header and footer views are not shown

#define ORIGIN_Y                    16
#define ORIGIN_X                    120
#define LANDSCAPE_WIDTH             350
#define LANDSCAPE_HEIGHT			98
#define TABLEVIEW_HEIGHT            94
#define TABLEVIEW_WIDTH             164
#define TABLE_BACKGROUND_COLOR		[UIColor clearColor]

#define BORDER_VIEW_TAG				10
#define PLAYER_BID_ITEM_TAG         11

#ifdef SHOW_MULTIPLE_SECTIONS
#define NUM_OF_CELLS			10
#define NUM_OF_SECTIONS			2
#else
#define NUM_OF_CELLS			21
#endif

// #defines for EasyTableView

@interface RoundPlayViewController_iPhone (MyPrivateMethods)
- (void)setupHorizontalView;
@end

@implementation RoundPlayViewController_iPhone

@synthesize horizontalView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setupHorizontalView];
    currentLowestQuantity = MIN_BID_QUANTITY;
}

- (void)viewWillAppear:(BOOL)animated {
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
	CGRect frameRect	= CGRectMake(ORIGIN_X, ORIGIN_Y, LANDSCAPE_WIDTH, LANDSCAPE_HEIGHT);
	EasyTableView *view	= [[EasyTableView alloc] initWithFrame:frameRect numberOfColumns:NUM_OF_CELLS ofWidth:TABLEVIEW_WIDTH];
	self.horizontalView = view;
	
	horizontalView.delegate						= self;
	horizontalView.tableView.backgroundColor	= TABLE_BACKGROUND_COLOR;
	horizontalView.tableView.allowsSelection	= YES;
	horizontalView.tableView.separatorColor		= [UIColor darkGrayColor];
	horizontalView.cellBackgroundColor			= [UIColor darkGrayColor];
	horizontalView.autoresizingMask				= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
	
	[self.view addSubview:horizontalView];
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
    
//    PlayerBidItemView_iPhone *tempView = [[PlayerBidItemView_iPhone alloc] init];
//    tempView.tag = PLAYER_BID_ITEM_TAG;
//    [container addSubview:tempView];
    
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

// Second delegate populates the views with data from a data source

- (void)easyTableView:(EasyTableView *)easyTableView
       setDataForView:(UIView *)view
         forIndexPath:(NSIndexPath *)indexPath
{
//    UILabel *label	= (UILabel *)view;
//    label.text		= [NSString stringWithFormat:@"%i", indexPath.row];
//        
//    CGRect rect = view.frame;
//    
//    // selectedIndexPath can be nil so we need to test for that condition
//    BOOL isSelected = (easyTableView.selectedIndexPath) ? ([easyTableView.selectedIndexPath compare:indexPath] == NSOrderedSame) : NO;
//    [self borderIsSelected:isSelected forView:view];
    PlayerBidItemView_iPhone *playerBidItem = [[PlayerBidItemStore sharedStore] getItemByRound:0 andByBid:[indexPath row]];
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
	
	UILabel *label	= (UILabel *)selectedView;
	//bigLabel.text	= label.text;
}

#pragma mark -
#pragma mark Optional EasyTableView delegate methods for section headers and footers

#ifdef SHOW_MULTIPLE_SECTIONS

// Delivers the number of sections in the TableView
- (NSUInteger)numberOfSectionsInEasyTableView:(EasyTableView*)easyTableView
{
    return NUM_OF_SECTIONS;
}

// Delivers the number of cells in each section, this must be implemented if numberOfSectionsInEasyTableView is implemented
-(NSUInteger)numberOfCellsForEasyTableView:(EasyTableView *)view inSection:(NSInteger)section
{
    return NUM_OF_CELLS;
}



#endif

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

- (IBAction)faceValueButton1:(id)sender {
}

- (IBAction)faceValueButton2:(id)sender {
}

- (IBAction)faceValueButton3:(id)sender {
}

- (IBAction)faceValueButton4:(id)sender {
}

- (IBAction)faceValueButton5:(id)sender {
}

- (IBAction)faceValueButton6:(id)sender {
}
@end
