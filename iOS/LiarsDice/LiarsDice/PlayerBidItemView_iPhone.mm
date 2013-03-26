//
//  PlayerBidItemView_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/8/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "PlayerBidItemView_iPhone.h"

@implementation PlayerBidItemView_iPhone

@synthesize bidIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *screens = [[NSBundle mainBundle] loadNibNamed:@"PlayerBidItemView_iPhone" owner:self options:nil];
        [self addSubview:[screens objectAtIndex:0]];
    }
    return self;
}

- (NSString *)getPlayerName
{
    return [userNameTextView text];
}

- (void)setPlayerName:(NSString *)name bidQuantity:(int)quantity bidFaceValue:(int)faceValue bidOdds:(int)odds
{
    timesMarkTextView.hidden = NO;
    userNameTextView.hidden = NO;
    bidQuantityLabel.hidden = NO;
    bidFaceValueImageView.hidden = NO;
    oddsLabel.hidden = NO;
    
    if (quantity == 0)
        [oddsLabel setText:@"Current bidder"];
    else if (quantity == -1)
        [oddsLabel setText:@"Next bidder"];
    else if (quantity == -2)
        [oddsLabel setText:@"Next next bidder"];
    else
        [oddsLabel setText:[[NSString alloc] initWithFormat:@"%d",odds]];

    if (quantity > 0)
        [bidQuantityLabel setText:[[NSString alloc] initWithFormat:@"%d",quantity]];
    else
        [bidQuantityLabel setText:@""];

    NSString *dieImageName = [[NSString alloc] initWithFormat:@"LD_Die_Highlight_%d.png",faceValue];
    [bidFaceValueImageView setImage:[UIImage imageNamed:dieImageName]];
    
    [userNameTextView setText:name];
    topView.alpha = 1.0;
}

- (void)setAsEmpty
{
    timesMarkTextView.hidden = YES;
    userNameTextView.hidden = YES;
    bidQuantityLabel.hidden = YES;
    bidFaceValueImageView.hidden = YES;
    oddsLabel.hidden = YES;
    topView.alpha = 0.0;
}

- (CGSize)getSize
{
    return topView.frame.size;
}

@end
