//
//  PlayerBidItemView_iPhone.m
//  LiarsDice
//
//  Created by David Raleigh on 2/8/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "PlayerBidItemView_iPhone.h"

#define HIGHLIGHT_ALPHA 0.2

@interface PlayerBidItemView_iPhone ()
- (void)highlightColor:(UIColor *)color;
- (void)clearHighlight;
@end

@implementation PlayerBidItemView_iPhone

@synthesize bidIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        NSArray *screens = [[NSBundle mainBundle] loadNibNamed:@"PlayerBidItemView_iPhone" owner:self options:nil];
        [self addSubview:[screens objectAtIndex:0]];
        highlightState = Highlights::NoHighlight;
        endOfRoundStatus = EndOfRoundStatus::Neutral;
        
        bIsCurrentBidder = false;
    }
    return self;
}

- (void)clearHighlight
{
    highlightView.hidden = YES;
    highlightView.alpha = 0.0;
    highlightView.backgroundColor = [UIColor clearColor];
}

- (NSString *)getPlayerName
{
    return [userNameTextView text];
}

- (CGSize)getSize
{
    return topView.frame.size;
}

- (void)highlightColor:(UIColor *)color
{
    highlightView.hidden = NO;
    highlightView.alpha = HIGHLIGHT_ALPHA;
    highlightView.backgroundColor = color;
}

- (void)highlightGreen
{
    [self highlightColor:[UIColor greenColor]];
}

- (void)highlightLoser
{
    [self highlightColor:[UIColor blackColor]];
}

- (void)highlightRed
{
    [self highlightColor:[UIColor redColor]];
}

- (void)highlightWinner
{
    [self highlightColor:[UIColor whiteColor]];
}

- (void)highlightYellow
{
    [self highlightColor:[UIColor yellowColor]];
}

- (void)setAsEmpty
{
    highlightView.hidden = YES;
    timesMarkTextView.hidden = YES;
    userNameTextView.hidden = YES;
    bidQuantityLabel.hidden = YES;
    bidFaceValueImageView.hidden = YES;
    oddsLabel.hidden = YES;
    topView.alpha = 0.0;
}

- (void)setAsHeader:(int)roundNumber
{
    [self setAsEmpty];
    NSString *roundDetails = [[NSString alloc] initWithFormat:@"Round %d ->", roundNumber];
    userNameTextView.hidden = NO;
    [userNameTextView setText:roundDetails];
    topView.alpha = 1.0;
}

- (void)setAsFooter:(int)roundNumber
{
    [self setAsEmpty];
    NSString *roundDetails = [[NSString alloc] initWithFormat:@"<- Round %d", roundNumber];
    userNameTextView.hidden = NO;
    [userNameTextView setText:roundDetails];
    topView.alpha = 1.0;
}

- (void)setChallengerName:(NSString *)challengerName setChallengedName:(NSString *)challengedName
{
    [self setAsEmpty];
    bIsCurrentBidder = false;
    userNameTextView.hidden = NO;
    [userNameTextView setText:challengerName];
    topView.alpha = 1.0;
}

- (void)setCurrentBidderName:(NSString *)name
{
    [self setAsEmpty];
    bIsCurrentBidder = true;
    userNameTextView.hidden = NO;
    [userNameTextView setText:name];
    topView.alpha = 1.0;
}

- (void)setNextAfterNextBidderName:(NSString *)name
{
    [self setAsEmpty];
    bIsCurrentBidder = false;
    userNameTextView.hidden = NO;
    [userNameTextView setText:name];
    topView.alpha = 1.0;
}

- (void)setNextBidderName:(NSString *)name
{
    [self setAsEmpty];
    bIsCurrentBidder = false;
    userNameTextView.hidden = NO;
    [userNameTextView setText:name];
    topView.alpha = 1.0;
}

- (void)setPlayerName:(NSString *)name bidQuantity:(int)quantity bidFaceValue:(int)faceValue bidOdds:(int)odds
{
    [self setAsEmpty];
    timesMarkTextView.hidden = NO;
    userNameTextView.hidden = NO;
    bidQuantityLabel.hidden = NO;
    bidFaceValueImageView.hidden = NO;
    oddsLabel.hidden = NO;
    
    [oddsLabel setText:[[NSString alloc] initWithFormat:@"%d",odds]];
    [bidQuantityLabel setText:[[NSString alloc] initWithFormat:@"%d",quantity]];

    NSString *dieImageName = [[NSString alloc] initWithFormat:@"LD_Die_Highlight_%d.png",faceValue];
    [bidFaceValueImageView setImage:[UIImage imageNamed:dieImageName]];
    
    [userNameTextView setText:name];
    topView.alpha = 1.0;
}

- (void)updateBidQuantity:(int)quantity
{
    if (!bIsCurrentBidder)
        return;
    
    if (quantity == 0)
    {
        bidQuantityLabel.hidden = YES;
        timesMarkTextView.hidden = YES;
        return;
    }
    
    if (bidFaceValueImageView.hidden == NO)
    {
        timesMarkTextView.hidden = NO;
    }
    
    bidQuantityLabel.hidden = NO;
    [bidQuantityLabel setText:[[NSString alloc] initWithFormat:@"%d",quantity]];
}

- (void)updateBidFaceValue:(int)faceValue
{
    if (!bIsCurrentBidder)
        return;
    
    if (faceValue == 0)
    {
        bidFaceValueImageView.hidden = YES;
        timesMarkTextView.hidden = YES;
        return;
    }
    
    if (bidQuantityLabel.hidden == NO)
    {
        timesMarkTextView.hidden = NO;
    }
    
    bidFaceValueImageView.hidden = NO;
    NSString *dieImageName = [[NSString alloc] initWithFormat:@"LD_Die_Highlight_%d.png",faceValue];
    [bidFaceValueImageView setImage:[UIImage imageNamed:dieImageName]];
}

- (void)updateBidOdds:(int)bidOdds
{
    if (!bIsCurrentBidder)
        return;
    
    if (bidOdds < 0)
    {
        oddsLabel.hidden = YES;
        return;
    }
    
    oddsLabel.hidden = NO;
    [oddsLabel setText:[[NSString alloc] initWithFormat:@"%d", bidOdds]];
}

@end
