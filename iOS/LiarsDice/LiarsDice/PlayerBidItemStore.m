//
//  PlayerBidItemStore.m
//  LiarsDice
//
//  Created by David Raleigh on 2/8/13.
//  Copyright (c) 2013 David Raleigh. All rights reserved.
//

#import "PlayerBidItemStore.h"

#import "PlayerBidItemView_iPhone.h"

@implementation PlayerBidItemStore

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (PlayerBidItemStore *)sharedStore
{
    static PlayerBidItemStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:NULL] init];
    return sharedStore;
}


- (id)init
{
    self = [super init];
    if (self)
        gameDictionary = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)setItemByRound:(int)round andByBid:(int)bid
{
    NSNumber *roundNumber = [[NSNumber alloc] initWithInt:round];
    NSNumber *bidNumber = [[NSNumber alloc] initWithInt:bid];
    NSMutableDictionary *roundDictionary = [gameDictionary objectForKey:roundNumber];
    if (!roundDictionary)
    {
        roundDictionary = [[NSMutableDictionary alloc] init];
        [gameDictionary setObject:roundDictionary forKey:roundNumber];
    }
    
    PlayerBidItemView_iPhone *playerBidItem = [[PlayerBidItemView_iPhone alloc] init];
    
    int odds = (arc4random() % 101);
    int bidQuantity = (arc4random() % 32) + 1;
    int faceValue = (arc4random() % 6) + 1;
    int toss = (arc4random() % 2);
    if (toss == 1)
        [playerBidItem setPlayerName:@"Bob" bidQuantity:bidQuantity bidFaceValue:faceValue bidOdds:odds];
    [roundDictionary setObject:playerBidItem forKey:bidNumber];
    
}

- (PlayerBidItemView_iPhone *)getItemByRound:(int)round andByBid:(int)bid
{
    NSNumber *roundNumber = [[NSNumber alloc] initWithInt:round];
    NSNumber *bidNumber = [[NSNumber alloc] initWithInt:bid];
    NSMutableDictionary *roundDict = [gameDictionary objectForKey:roundNumber];
    if (!roundDict)
    {
        [self setItemByRound:round andByBid:bid];
        roundDict = [gameDictionary objectForKey:roundNumber];
        return [roundDict objectForKey:bidNumber];
    }
    PlayerBidItemView_iPhone *playerBidItem =[roundDict objectForKey:bidNumber];
    if (!playerBidItem)
    {
        [self setItemByRound:round andByBid:bid];
        playerBidItem =[roundDict objectForKey:bidNumber];
    }
    return playerBidItem;
}

- (void)deleteItemByRound:(int)round andByBid:(int)bid
{
    NSNumber *roundNumber = [[NSNumber alloc] initWithInt:round];
    NSNumber *bidNumber = [[NSNumber alloc] initWithInt:bid];
    NSMutableDictionary *roundDict = [gameDictionary objectForKey:roundNumber];
    if (!roundDict)
        return;
    [roundDict removeObjectForKey:bidNumber];
}

- (void)deleteRound:(int)round
{
    NSNumber *roundNumber = [[NSNumber alloc] initWithInt:round];
    NSMutableDictionary *roundDict = [gameDictionary objectForKey:roundNumber];
    if (!roundDict)
        return;
    [roundDict removeAllObjects];
    [gameDictionary removeObjectForKey:roundNumber];
}

- (void)deleteAllRounds
{
    for (NSMutableDictionary *dict in gameDictionary)
        [dict removeAllObjects];
    [gameDictionary removeAllObjects];
}



@end
