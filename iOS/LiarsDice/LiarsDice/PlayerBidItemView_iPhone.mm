//
//  PlayerBidItemView_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/8/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "PlayerBidItemView_iPhone.h"

@implementation PlayerBidItemView_iPhone

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
//        NSArray *screens = [[NSBundle mainBundle] loadNibNamed:@"PlayerBidItemView_iPhone" owner:self options:nil];
//        [self addSubview:[screens objectAtIndex:0]];
    }
    return self;
}

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


- (void)setPlayerName:(NSString *)name bidQuantity:(int)quantity bidFaceValue:(int)faceValue bidOdds:(int)odds
{

    [bidQuantityLabel setText:[[NSString alloc] initWithFormat:@"%d",quantity]];
    [oddsLabel setText:[[NSString alloc] initWithFormat:@"%d",odds]];
    
    NSString *dieImageName = [[NSString alloc] initWithFormat:@"Die%d.png",faceValue];
    [bidFaceValueImageView setImage:[UIImage imageNamed:dieImageName]];
    
    [userNameTextView setText:name];
}

- (CGSize)getSize
{
    return topView.frame.size;
}

@end
