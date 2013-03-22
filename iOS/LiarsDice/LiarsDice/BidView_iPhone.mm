//
//  BidView_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/24/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "BidView_iPhone.h"

@implementation BidView_iPhone

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        NSArray *screens = [[NSBundle mainBundle] loadNibNamed:@"BidView_iPhone" owner:self options:nil];
        [self addSubview:[screens objectAtIndex:0]];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *screens = [[NSBundle mainBundle] loadNibNamed:@"BidView_iPhone" owner:self options:nil];
        [self addSubview:[screens objectAtIndex:0]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)bidButton:(id)sender {
}
@end
