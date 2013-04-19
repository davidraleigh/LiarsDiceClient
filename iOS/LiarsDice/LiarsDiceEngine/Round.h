//
//  Round.h
//  LiarsDiceClient
//
//  Created by David B Raleigh on 10/19/12.
//  Copyright (c) 2012 David Raleigh. All rights reserved.
//

#ifndef __LiarsDiceClient__Round__
#define __LiarsDiceClient__Round__

#include <iostream>
#include <deque>
#include <map>
#include <vector>

class RoundDetails
{
    
public:
    
    typedef enum{
        HonestBid,
        SoftLieBid,
        HardLieBid,
        BlindBid,
        UnknownBid
    }BidType;
    
    struct bid_t
    {
        unsigned int playerUID;
        int bidFaceValue;
        int bidQuantity;
        BidType bidType;
    } bid;
    
    RoundDetails();
    
    RoundDetails(int totalDiceCount);
    
    RoundDetails(RoundDetails *roundDetails);
    
    //RoundDetails(std::vector<unsigned int> playersInRound);
    
    ~RoundDetails();
    
    RoundDetails::bid_t GetBid(int bidIndex);
    
    int GetBidCount();
    
    int GetBidCount(unsigned int playerUID);
    
    inline unsigned int GetChallengerUID() { return m_challengerUID; };
    
    inline unsigned int GetLastBidderUID() { return m_lastBidderUID; };
    
    inline unsigned int GetLoserUID() { return m_loserUID; };
    
    RoundDetails::bid_t GetLowestPossibleBid();
    
    inline unsigned int GetWinnerUID() { return m_winnerUID; };
    
    inline bool IsRoundFinished() { return (m_challengerUID != 0 && m_lastBidderUID != 0 &&
                                            m_winnerUID != 0 && m_loserUID != 0); };
    
    inline bool IsRoundWild() { return m_bRoundIsWild; };
    
    void RecordBid(unsigned int playerUID, int bidQuantity, int bidFaceValue, BidType bidType);
    
    void RecordChallenge(unsigned int challengerUID, unsigned int lastBidderUID, unsigned int winnerUID);
    
    void SetRoundWild();
    
private:
    std::deque<bid_t> m_bidsInRound;
    bool m_bRoundIsWild;
    
    unsigned int m_challengerUID;
    unsigned int m_lastBidderUID;
    unsigned int m_winnerUID;
    unsigned int m_loserUID;
    
    int m_totalDiceCount;
    
    static RoundDetails::bid_t _EmptyBid();
};

#endif /* defined(__LiarsDiceClient__Round__) */
