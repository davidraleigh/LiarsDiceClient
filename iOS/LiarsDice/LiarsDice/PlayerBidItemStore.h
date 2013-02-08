//
//  PlayerBidItemStore.h
//  LiarsDice
//
//  Created by David Raleigh on 2/8/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PlayerBidItemView_iPhone;
@interface PlayerBidItemStore : NSObject
{
    NSMutableDictionary *gameDictionary;
}

+ (PlayerBidItemStore *)sharedStore;

- (void)setItemByRound:(int)round andByBid:(int)bid;
- (PlayerBidItemView_iPhone *)getItemByRound:(int)round andByBid:(int)bid;
- (void)deleteItemByRound:(int)round andByBid:(int)bid;
- (void)deleteRound:(int)round;
- (void)deleteAllRounds;
@end
