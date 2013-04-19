//
//  Round.cpp
//  LiarsDiceClient
//
//  Created by David B Raleigh on 10/19/12.
//  Copyright (c) 2012 David Raleigh. All rights reserved.
//

#include "Round.h"
#include "GamePlayers.h"

RoundDetails::RoundDetails()
{
    m_challengerUID = 0;
    m_lastBidderUID = 0;
    m_winnerUID = 0;
    m_loserUID = 0;
    m_totalDiceCount = 0;
    m_bRoundIsWild = false;
}

RoundDetails::RoundDetails(int totalDiceCount)
{
    m_totalDiceCount = totalDiceCount;
    m_bRoundIsWild = false;
}

RoundDetails::RoundDetails(RoundDetails *round)
{
    m_challengerUID = round->m_challengerUID;
    m_lastBidderUID = round->m_lastBidderUID;
    m_winnerUID = round->m_winnerUID;
    m_loserUID = round->m_loserUID;
    
    m_totalDiceCount = round->m_totalDiceCount;
    m_bRoundIsWild = false;    
    
    m_bidsInRound = round->m_bidsInRound;
}

//RoundDetails::RoundDetails(std::vector<unsigned int> playersInRound)
//{
//    m_challengerUID = 0;
//    m_challengedUID = 0;
//    m_winnerUID = 0;
//    m_loserUID = 0;
//}

RoundDetails::~RoundDetails()
{
    
}

RoundDetails::bid_t RoundDetails::_EmptyBid()
{
    bid_t bid;
    bid.playerUID = 0;
    bid.bidFaceValue = -1;
    bid.bidQuantity = -1;
    bid.bidType = BidType::UnknownBid;
    return bid;
}

RoundDetails::bid_t RoundDetails::GetBid(int bidIndex)
{
    if (m_bidsInRound.size() > 0)
        return m_bidsInRound[bidIndex];
    return _EmptyBid();
}

int RoundDetails::GetBidCount()
{
    return (int)m_bidsInRound.size();
}

int RoundDetails::GetBidCount(unsigned int playerUID)
{
    int count = 0;
    std::deque<bid_t>::iterator iter;
    for (iter = m_bidsInRound.begin(); iter != m_bidsInRound.end(); iter++)
        if ((*iter).playerUID == playerUID)
            count++;
    
    return count;
}


RoundDetails::bid_t RoundDetails::GetLowestPossibleBid()
{
    RoundDetails::bid_t lowestBid;
    lowestBid.playerUID = 0;
    lowestBid.bidFaceValue = 1;
    lowestBid.bidQuantity = 1;
    
    if (GetBidCount() == 0)
        return lowestBid;
    
    lowestBid = GetBid(0);
    
    if (lowestBid.bidFaceValue == 6)
    {
        if (lowestBid.bidQuantity == m_totalDiceCount)
        {
            lowestBid.bidQuantity = -1;
            lowestBid.bidFaceValue = -1;
        }
        else
        {
            lowestBid.bidQuantity++;
            lowestBid.bidFaceValue = 1;
        }
    }
    else
    {
        lowestBid.bidFaceValue++;
    }
    return lowestBid;
}

void RoundDetails::RecordBid(unsigned int playerUID, int bidQuantity, int bidFaceValue, BidType bidType)
{
    bid_t bid;
    bid.playerUID = playerUID;
    bid.bidFaceValue = bidFaceValue;
    bid.bidQuantity = bidQuantity;
    bid.bidType = bidType;
    m_bidsInRound.push_front(bid);
}

void RoundDetails::RecordChallenge(unsigned int challengerUID, unsigned int lastBidderUID, unsigned int winnerUID)
{
    m_challengerUID = challengerUID;
    m_lastBidderUID = lastBidderUID;
    m_winnerUID = winnerUID;
    if (m_winnerUID == m_challengerUID)
        m_loserUID = m_lastBidderUID;
    else
        m_loserUID = m_challengerUID;
}

void RoundDetails::SetRoundWild()
{
    m_bRoundIsWild = true;
}