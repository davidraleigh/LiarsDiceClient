//
//  BidSelectionData.h
//  LiarsDice
//
//  Created by David Raleigh on 2/4/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import <Foundation/Foundation.h>
// TODO wrap LiarsDice
// TODO make into a singleton or a stateless wrapper of a LiarsDice object
@interface BidSelectionData : NSObject
{
    // lastBidFaceValue
    // lastBidQuantity
    // diceAtTable
}

+ (int)getLastBidFaceValue;
+ (int)getLastBidQuantity;
+ (int)getDiceAtTableCount;

@end
