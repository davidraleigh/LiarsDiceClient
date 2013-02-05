//
//  RoundPlayViewController_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/5/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "RoundPlayViewController_iPhone.h"

#import "EasyTableView.h"

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
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setupHorizontalView];
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

- (void)setupHorizontalView {
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
	CGRect labelRect		= CGRectMake(10, 10, rect.size.width-20, rect.size.height-20);
	UILabel *label			= [[UILabel alloc] initWithFrame:labelRect];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
	label.textAlignment		= UITextAlignmentCenter;
#else
	label.textAlignment		= NSTextAlignmentCenter;
#endif
	label.textColor			= [UIColor whiteColor];
	label.font				= [UIFont boldSystemFontOfSize:60];
	
	// Use a different color for the two different examples
	if (easyTableView == horizontalView)
		label.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
	else
		label.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
	
	UIImageView *borderView		= [[UIImageView alloc] initWithFrame:label.bounds];
	borderView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	borderView.tag				= BORDER_VIEW_TAG;
	
	[label addSubview:borderView];
    
	return label;
}

// Second delegate populates the views with data from a data source

- (void)easyTableView:(EasyTableView *)easyTableView
       setDataForView:(UIView *)view
         forIndexPath:(NSIndexPath *)indexPath
{
	UILabel *label	= (UILabel *)view;
	label.text		= [NSString stringWithFormat:@"%i", indexPath.row];
	
	// selectedIndexPath can be nil so we need to test for that condition
	BOOL isSelected = (easyTableView.selectedIndexPath) ? ([easyTableView.selectedIndexPath compare:indexPath] == NSOrderedSame) : NO;
	[self borderIsSelected:isSelected forView:view];
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
- (NSUInteger)numberOfSectionsInEasyTableView:(EasyTableView*)easyTableView{
    return NUM_OF_SECTIONS;
}

// Delivers the number of cells in each section, this must be implemented if numberOfSectionsInEasyTableView is implemented
-(NSUInteger)numberOfCellsForEasyTableView:(EasyTableView *)view inSection:(NSInteger)section {
    return NUM_OF_CELLS;
}

//// The height of the header section view MUST be the same as your HORIZONTAL_TABLEVIEW_HEIGHT (horizontal EasyTableView only)
//- (UIView *)easyTableView:(EasyTableView*)easyTableView
//   viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *label = [[UILabel alloc] init];
//	label.text = @"HEADER";
//	label.textColor = [UIColor whiteColor];
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//	label.textAlignment		= UITextAlignmentCenter;
//#else
//	label.textAlignment		= NSTextAlignmentCenter;
//#endif
//    
//	if (easyTableView == self.horizontalView) {
//		label.frame = CGRectMake(0, 0, TABLEVIEW_WIDTH, TABLEVIEW_HEIGHT);
//	}
////	if (easyTableView == self.verticalView) {
////		label.frame = CGRectMake(0, 0, VERTICAL_TABLEVIEW_WIDTH, 20);
////	}
//    
//    switch (section) {
//        case 0:
//            label.backgroundColor = [UIColor redColor];
//            break;
//        default:
//            label.backgroundColor = [UIColor blueColor];
//            break;
//    }
//    return label;
//}

//// The height of the footer section view MUST be the same as your HORIZONTAL_TABLEVIEW_HEIGHT (horizontal EasyTableView only)
//- (UIView *)easyTableView:(EasyTableView*)easyTableView
//   viewForFooterInSection:(NSInteger)section
//{
//    UILabel *label = [[UILabel alloc] init];
//	label.text = @"FOOTER";
//	label.textColor = [UIColor yellowColor];
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
//	label.textAlignment		= UITextAlignmentCenter;
//#else
//	label.textAlignment		= NSTextAlignmentCenter;
//#endif
//	label.frame = CGRectMake(0, 0, TABLEVIEW_WIDTH, 20);
//    
//	if (easyTableView == self.horizontalView) {
//		label.frame = CGRectMake(0, 0, TABLEVIEW_WIDTH, TABLEVIEW_HEIGHT);
//	}
////	if (easyTableView == self.verticalView) {
////		label.frame = CGRectMake(0, 0, VERTICAL_TABLEVIEW_WIDTH, 20);
////	}
//	
//    switch (section) {
//        case 0:
//            label.backgroundColor = [UIColor purpleColor];
//            break;
//        default:
//            label.backgroundColor = [UIColor brownColor];
//            break;
//    }
//    
//    return label;
//}

#endif

@end
