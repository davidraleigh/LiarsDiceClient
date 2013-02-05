//
//  RoundPlayViewController_iPhone.h
//  LiarsDice
//
//  Created by David Raleigh on 2/5/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "RoundPlayViewController.h"
#import "EasyTableView.h"


@interface RoundPlayViewController_iPhone : RoundPlayViewController <EasyTableViewDelegate>
{
	EasyTableView *horizontalView;
}

@property (nonatomic) EasyTableView *horizontalView;
@end
