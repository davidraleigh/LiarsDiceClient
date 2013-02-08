//
//  PlayerBidItemView_iPhone.h
//  LiarsDice
//
//  Created by David Raleigh on 2/8/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerBidItemView_iPhone : UIView
{
    __weak IBOutlet UITextView *userNameTextView;
    __weak IBOutlet UILabel *bidQuantityLabel;
    __weak IBOutlet UIImageView *bidFaceValueImageView;
    __weak IBOutlet UILabel *oddsLabel;
    
}

- (void)setPlayerName:(NSString *)name bidQuantity:(int)quantity bidFaceValue:(int)faceValue bidOdds:(int)odds;

@end
