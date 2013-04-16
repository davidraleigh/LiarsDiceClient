//
//  LiarsDiceEngine.cpp
//  NativeEngine
//
//  Created by David Raleigh on 9/5/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#include "LiarsDiceEngine.h"
#include "Utilities.h"
#include "Player.h"
#include "GamePlayers.h"

#include <iostream>
#include <math.h>
#include <sstream>
#include <json/json.h>

typedef std::pair <int, Player*> playerPair;

//LiarsDiceEngine::LiarsDiceEngine(std::map<int, std::string> players, int numberOfDicePerPlayer, bool bOnesWild, unsigned int seed)
//{
//    _init(players, numberOfDicePerPlayer, bOnesWild, seed);
//}

//LiarsDiceEngine::LiarsDiceEngine(const std::string playersJSON, int numberOfDicePerPlayer, bool bOnesWild, unsigned int seed)
//{
//    std::map<int, std::string> players = LiarsDiceEngine::GetPlayersFromJSON(playersJSON);
//    _init(players, numberOfDicePerPlayer, bOnesWild, seed);
//}

LiarsDiceEngine::LiarsDiceEngine()
{
    
}

LiarsDiceEngine::LiarsDiceEngine(int numberOfDicePerPlayer, bool bOnesWild, unsigned int seed)
{
    m_playerCount = GamePlayers::getInstance().PlayerCount();
    
    if (m_playerCount < 2)
        return;

    m_bProbabilityExactlyZero = false;
    m_numberOfDicePerPlayer = numberOfDicePerPlayer;
    m_totalNumberOfDiceLeft = m_playerCount * m_numberOfDicePerPlayer;
    m_currentPlayerUID = 0;
    
    // seed random number generator
    m_randomGenerator = std::make_shared<PseudoRandom>(seed);
    
    for (short position = 0; position < m_playerCount; position++)
    {
        m_orderedPlayerList.push_back(GamePlayers::getInstance().GetPlayerUID(position));
        // TODO error statement
        // bool success = 
        GamePlayers::getInstance().GetPlayerAtPosition(position)->FillGameDice(m_randomGenerator, m_playerCount, m_numberOfDicePerPlayer);
        
    }
    
    _RollForPlayOrder();
    m_bOnesWild = bOnesWild;
    
}

LiarsDiceEngine::~LiarsDiceEngine()
{
    for (int position = 0; position < m_playerCount; position++)
        GamePlayers::getInstance().GetPlayerAtPosition(position)->ResetDice();
}

bool LiarsDiceEngine::Bid(int bidQuantity, int bidFaceValue)
{
    
    if (!IsBidValid(bidFaceValue, bidQuantity))
        return false;
    
    // if it is beginning of the round
    if (GetBidCount() == 0 && bidFaceValue == 1 && m_bOnesWild)
        m_roundDetails.back().SetRoundWild();
//    else if (GetBidCount() == 0)
//        m_bWildOneUsedThisRound = false;
    
    // TODO place bid info in Round class
    m_roundDetails.back().RecordBid(m_currentPlayerUID, bidQuantity, bidFaceValue);
    
    // increment player ID
    // TODO Prep for a player having dropped
    m_currentPlayerUID = GetNextPlayerUID();
    return true;
}

unsigned int LiarsDiceEngine::Challenge()
{
    // TODO decide how to handle error
    if (GetBidCount() < 1)
    {
        return 0;
    }
    
    // get the last bid
    RoundDetails::bid_t lastBid = m_roundDetails.back().GetBid(0);// m_bidsInRound[0];
    int numberOfDieInHands = 0;
    
    std::vector<unsigned int>::iterator iter;
    for (iter = m_orderedPlayerList.begin(); iter != m_orderedPlayerList.end(); iter++)
    {
        Player *player = GamePlayers::getInstance().GetPlayerAtUID(*iter);
        for (int i = 0; i < player->GetDiceCount(); i++)
        {
            if (player->GetDieFaceValue(i) == lastBid.bidFaceValue)
                numberOfDieInHands++;
            else if (m_roundDetails.back().IsRoundWild() && player->GetDieFaceValue(i) == 1)
                numberOfDieInHands++;
        }
    }
    
    // if the last bid was successful return the
    // bidder's number and set the next rounds current bidder
    // be the last bidder.
    if (numberOfDieInHands >= lastBid.bidQuantity)
    {
        m_roundDetails.back().RecordChallenge(m_currentPlayerUID, lastBid.playerUID, lastBid.playerUID);
        PlayerLosesDie(m_currentPlayerUID);
        m_currentPlayerUID = lastBid.playerUID;
    }
    else
    {
        m_roundDetails.back().RecordChallenge(m_currentPlayerUID, lastBid.playerUID, m_currentPlayerUID);
        PlayerLosesDie(lastBid.playerUID);
    }
    
    return m_currentPlayerUID;
    
    // DO NOT void out m_bidsInRound.  It will be used to display results
    // game data should be saved in some JSON format and pumped up to
    // a database for analysis
}

RoundDetails::bid_t LiarsDiceEngine::GenerateAIBid(unsigned int playerUID)
{
    Player *player = GamePlayers::getInstance().GetPlayerAtUID(playerUID);
    if (player && player->GetPlayerType() == Player::HonestAI)
        return GenerateHonestAIBid(playerUID);
    return GenerateLiarAIBid(playerUID);
}

RoundDetails::bid_t LiarsDiceEngine::GenerateHonestAIBid(unsigned int playerUID)
{
    RoundDetails::bid_t lowestBid = m_roundDetails.back().GetLowestPossibleBid();
    RoundDetails::bid_t bestBid;
    bestBid.playerUID = playerUID;
    int rollProbability = -1;
    for (int i = 6; i >= 1; i--)
    {
        int tempRollProbability = GetProbabilityForPlayer(lowestBid.bidQuantity, i, playerUID);
        if (rollProbability < tempRollProbability)
        {
            bestBid.bidFaceValue = i;
            bestBid.bidQuantity = lowestBid.bidQuantity;
            rollProbability = tempRollProbability;
        }
        
        if (lowestBid.bidFaceValue == i)
            lowestBid.bidQuantity++;
    }
    
    // TODO put challenge cutoff in player AI details
    int challengeCutOff = 58;
    if (rollProbability < challengeCutOff)
    {
        bestBid.bidQuantity = -1;
        bestBid.bidFaceValue = -1;
    }
    
    return bestBid;
}

RoundDetails::bid_t LiarsDiceEngine::GenerateLiarAIBid(unsigned int playerUID)
{
    int idealPercentProbability = 80;
    int differenceToIdeal = 100;
    RoundDetails::bid_t lowestBid = m_roundDetails.back().GetLowestPossibleBid();
    RoundDetails::bid_t bestBid;
    bestBid.playerUID = playerUID;
    bestBid.bidFaceValue = -1;
    bestBid.bidQuantity = -1;
    Player *player = GamePlayers::getInstance().GetPlayerAtUID(playerUID);
    int diceCount = player->GetDiceCount();
    for (int lowestDiceCount = 0; lowestDiceCount <= diceCount; lowestDiceCount++)
    {
        for (int dieFaceValue = 6; dieFaceValue >= 1; dieFaceValue--)
        {
            if (player->GetFaceValueCount(dieFaceValue) != lowestDiceCount)
                continue;
            int tempLowestQuantity = dieFaceValue < lowestBid.bidFaceValue ? lowestBid.bidQuantity + 1 : lowestBid.bidQuantity;
            int testProbability;
            while ((testProbability = GetProbabilityForPlayer(tempLowestQuantity, dieFaceValue, playerUID)) > idealPercentProbability)
            {
                if ((testProbability - idealPercentProbability) > differenceToIdeal)
                    break;
                differenceToIdeal = testProbability - idealPercentProbability;
                bestBid.bidFaceValue = dieFaceValue;
                bestBid.bidQuantity = tempLowestQuantity++;
            }
            if (bestBid.bidQuantity != -1)
                return bestBid;
        }
    }
    
    return bestBid;
}

std::vector<unsigned int> LiarsDiceEngine::GetAllActivePlayers()
{
    std::vector<unsigned int> allActivePlayers = m_orderedPlayerList;
    return allActivePlayers;
}

RoundDetails::bid_t LiarsDiceEngine::GetBid(int bidIndex)
{
    return m_roundDetails.back().GetBid(bidIndex);
}

RoundDetails::bid_t LiarsDiceEngine::GetBid(int bidIndex, int roundNumber)
{
    return m_roundDetails[roundNumber - 1].GetBid(bidIndex);
}

int LiarsDiceEngine::GetBidCount()
{
    if (m_roundDetails.size() > 0)
        return m_roundDetails.back().GetBidCount();
    return 0;
}

int LiarsDiceEngine::GetBidCountForGame()
{
    int bidCount = 0;
    if (m_roundDetails.size() == 0)
        return bidCount;
    
    for (int i = 0; i < m_roundDetails.size(); i++)
        bidCount += GetBidCountForRound(i);
    return bidCount;
}
int LiarsDiceEngine::GetBidCountForRound(int roundIndex)
{
    if (roundIndex < m_roundDetails.size() && roundIndex >= 0)
        return m_roundDetails[roundIndex].GetBidCount();
    return 0;
}

int LiarsDiceEngine::GetCurrentCycle()
{
    int bidCount = (int)m_roundDetails.size();
    if (bidCount == 0)
        return 1;
    
    return m_playerCount / m_roundDetails.size();
}

std::string LiarsDiceEngine::GetHandAsString(unsigned int playerUID)
{
    std::string playersHand = GetPlayerName(playerUID);
    playersHand.append("'s Hand : [ ");
    std::vector<int> hand = GetPlayersDice(playerUID);
    std::vector<int>::iterator iter;
    for (iter = hand.begin(); iter != hand.end(); iter++)
    {
        std::ostringstream ss;
        ss << *iter;
        playersHand.append(ss.str());
        playersHand.append(" ");
    }
    playersHand.append("]");
    return playersHand;
}

RoundDetails::bid_t LiarsDiceEngine::GetLowestPossibleBid()
{
    if (m_roundDetails.size() > 0)
        return m_roundDetails.back().GetLowestPossibleBid();
    RoundDetails::bid_t lowestBid;
    lowestBid.playerUID = 0;
    lowestBid.bidFaceValue = 1;
    lowestBid.bidQuantity = 1;
    return lowestBid;
}

unsigned int LiarsDiceEngine::GetNextPlayerUID(unsigned int playerUID)
{
    std::vector<unsigned int>::iterator playerIndex = _GetPlayerIndexFromPlayerList(playerUID);
    if (++playerIndex == m_orderedPlayerList.end())
        return m_orderedPlayerList.front();
    else
        return *playerIndex;
}

std::string LiarsDiceEngine::GetPlayerName(unsigned int playerUID)
{
    return GamePlayers::getInstance().GetPlayerNameAtUID(playerUID);
}

std::vector<int> LiarsDiceEngine::GetPlayersDice(unsigned int playerUID)
{
    return GamePlayers::getInstance().GetPlayerAtUID(playerUID)->GetPlayerDice();
}

int LiarsDiceEngine::GetPlayersDiceCount(unsigned int playerUID)
{
    return GamePlayers::getInstance().GetPlayerAtUID(playerUID)->GetDiceCount();
}

unsigned int LiarsDiceEngine::GetPreviousPlayerUID(unsigned int playerUID)
{
    std::vector<unsigned int>::iterator playerIndex = _GetPlayerIndexFromPlayerList(playerUID);
    if (playerIndex == m_orderedPlayerList.begin()) // if the player is the first player then return the last player as the previous
        return m_orderedPlayerList.back();
    // decrement to get previous player
    playerIndex--;
    return *playerIndex;
}

int LiarsDiceEngine::GetProbabilityAtTable(int numberOfDice, int bidFaceValue)
{
    bool bBidIsWildValue = IsBidAWildValue(bidFaceValue);
    return Utilities::GetProbability(numberOfDice, m_totalNumberOfDiceLeft, bBidIsWildValue, m_roundDetails.back().IsRoundWild());
}

int LiarsDiceEngine::GetProbabilityForPlayer(int bidQuantity, int bidFaceValue, unsigned int playerUID)
{
    Player *player = GamePlayers::getInstance().GetPlayerAtUID(playerUID);
    
    for (int i = 0; i < player->GetDiceCount(); i++)
    {
        // Go through die to check for bid value in hand
        if (player->GetDieFaceValue(i) == bidFaceValue)
        {
            bidQuantity--;
            continue;
        }
        
        // if there are wild values and wilds are permitted in
        // bidding round look at hand for wilds and subtract
        // number of wilds
        if (m_roundDetails.back().IsRoundWild() && player->GetDieFaceValue(i) == 1)
            bidQuantity--;
        
    }
    // if there are no die needed and the player
    // has all the die necessary to meet the
    // number of die needed for a given bid.
    // return 100 percent
    if (bidQuantity < 1)
        return 100;
    
    // Now that numberOfDieNeeded is adjusted, get the numberOfUnknownDie
    // possessed by competitors
    int numberOfUnknownDie = m_totalNumberOfDiceLeft - player->GetDiceCount();
    
    // check that the bid face value isn't one of the wild values,
    // if it is, then the single roll probability is 1/6 less than
    // what it would be if it were a non wild face value bid in a
    // wild round
    bool bBidIsWildValue = IsBidAWildValue(bidFaceValue);
    
    return Utilities::GetProbability(bidQuantity, numberOfUnknownDie, bBidIsWildValue, m_roundDetails.back().IsRoundWild());
}

int LiarsDiceEngine::GetRandCount()
{
    return m_randomGenerator->GetRandomCount();
}

std::map<unsigned int, int> LiarsDiceEngine::GetRollsForPlayOrder()
{
    //TODO this should have been called by the constructor, but
    // if not then too bad
    _RollForPlayOrder();
    std::map<unsigned int, int> playersRollsForFirstPlay = m_rollsForFirstPlay;
    return playersRollsForFirstPlay;
}

int LiarsDiceEngine::GetRollProbability(int bidIndex)//(int rollNumber)
{
    RoundDetails::bid_t bid = m_roundDetails.back().GetBid(bidIndex);// m_bidsInRound[rollNumber];
    // check that the bid face value isn't one of the wild values,
    // if it is, then the single roll probability is 1/6 less than
    // what it would be if it were a non wild face value bid in a
    // wild round
    bool bBidIsWildValue = IsBidAWildValue(bid.bidFaceValue);
    
    return Utilities::GetProbability(bid.bidQuantity, m_totalNumberOfDiceLeft, bBidIsWildValue, m_roundDetails.back().IsRoundWild());
}


int LiarsDiceEngine::GetRollProbability(unsigned int playerUID, int bidIndex)//, int rollNumber)
{
    
    RoundDetails::bid_t bid = m_roundDetails.back().GetBid(bidIndex);//m_bidsInRound[rollNumber];
    return GetProbabilityForPlayer(bid.bidQuantity, bid.bidFaceValue, playerUID);
}

unsigned int LiarsDiceEngine::GetRoundChallenger(int roundIndex)
{
    if (roundIndex < m_roundDetails.size() && roundIndex >= 0)
        return m_roundDetails[roundIndex].GetChallengerUID();
    return 0;
}

unsigned int LiarsDiceEngine::GetRoundLastBidder(int roundIndex)
{
    if (roundIndex < m_roundDetails.size() && roundIndex >= 0)
        return m_roundDetails[roundIndex].GetLastBidderUID();
    return 0;
}

unsigned int LiarsDiceEngine::GetRoundLoser(int roundIndex)
{
     if (roundIndex < m_roundDetails.size() && roundIndex >= 0)
         return m_roundDetails[roundIndex].GetLoserUID();
    return 0;
}

unsigned int LiarsDiceEngine::GetRoundWinner(int roundIndex)
{
    if (roundIndex < m_roundDetails.size() && roundIndex >= 0)
        return m_roundDetails[roundIndex].GetWinnerUID();
    return 0;
}


bool LiarsDiceEngine::IsBidAWildValue(int bidFaceValue)
{
    if (m_roundDetails.back().IsRoundWild() || (m_roundDetails.back().GetBidCount() == 0 && m_bOnesWild))
        return bidFaceValue == 1;
    return false;
}

bool LiarsDiceEngine::IsBidValid(int bidFaceValue, int bidQuantity)
{
    // test for the quantity of the last bid, to make sure
    // this one is a valid bid
    if (bidFaceValue < 1 || bidFaceValue > 6 || bidQuantity < 1 || bidQuantity >m_totalNumberOfDiceLeft)
        return false;
    
    if (m_roundDetails.back().GetBidCount() == 0)
        return true;
    
    RoundDetails::bid_t lastBid = m_roundDetails.back().GetBid(0);// m_bidsInRound[0];
    if ((bidQuantity < lastBid.bidQuantity) ||
        (bidQuantity == lastBid.bidQuantity && bidFaceValue <= lastBid.bidFaceValue))
    {
        return false;
    }
    
    return true;
}

bool LiarsDiceEngine::IsWildRound()
{
    return m_roundDetails.back().IsRoundWild();
}

void LiarsDiceEngine::IncreaseRandCount(int countIncrease)
{
    for (int i = 0; i < countIncrease; i++)
        m_randomGenerator->GetDiceValue();
}

bool LiarsDiceEngine::LastBidTerminatesRound()
{
    if (m_roundDetails.back().GetBidCount() == 0)
        return false;
    
    RoundDetails::bid_t lastBid = m_roundDetails.back().GetBid(0);
    if (lastBid.bidFaceValue == 6 && lastBid.bidQuantity == m_totalNumberOfDiceLeft)
        return true;
    return false;
}

bool LiarsDiceEngine::LastProbabiltyIsZero()
{
    return m_bProbabilityExactlyZero;
}

bool LiarsDiceEngine::PlayerLosesDie(unsigned int playerUID)
{
    Player *player = GamePlayers::getInstance().GetPlayerAtUID(playerUID);
    // check number of die in cup.
    if (player->GetDiceCount() == 1)
    {// remove player from game
        PlayerLostLastDie(playerUID);
        return true;
    }
    
    player->RemoveDie();
    m_totalNumberOfDiceLeft--;
    
    return false;
}

// TODO where is this even used?
bool LiarsDiceEngine::PlayerLostLastDie(unsigned int playerUID)
{
    // TODO Not finished
    // TODO this is fucking ugly.  clean this up!!!!!!
    // Handle case where
    m_playerCount--;
    
    //TODO change asser to c++
    //assert m_playerCount != 0;
    m_totalNumberOfDiceLeft = m_totalNumberOfDiceLeft - GamePlayers::getInstance().GetPlayerAtUID(playerUID)->GetDiceCount();//m_playerDictionary[playerUID].GetNumberOfDice();
    
    //TODO change asser to c++
    //assert m_totalNumberOfDiceLeft > 1;
    
    // TODO, check this GamePlayers::getInstance().DropPlayer(playerUID);     //m_playerDictionary.erase(playerUID);
    std::vector<unsigned int>::iterator playerIndex = _GetPlayerIndexFromPlayerList(playerUID);
    m_orderedPlayerList.erase(playerIndex);
    //m_loserList.push_back(playerUID);
    
    if (m_playerCount == 1)
        return false;
    
    // handle current player ID or not?
    return true;
}


void LiarsDiceEngine::PlayerDisconnect(unsigned int playerUID)
{
    // adjust total number of die
    
    // check for master slave relationship.
    
    // remove player from dictionary
    
    // remove player from m_orderedPlayerList
	
}

void LiarsDiceEngine::StartRound()
{
    RoundDetails round(m_totalNumberOfDiceLeft);
    m_roundDetails.push_back(round);
    
    for (short position = 0; position < m_playerCount; position++)
        GamePlayers::getInstance().GetPlayerAtPosition(position)->Roll();
}


void LiarsDiceEngine::_RollForPlayOrder()
{
    if (m_currentPlayerUID > 0)
        return;
    
    int maxValue = 1;
    int maxRollIndex = -1;
    while (maxValue == 1)
    {
        for (int i = 0; i < m_playerCount; i++)
        {
            int roll = m_randomGenerator->GetDiceValue();
            // TODO, test with all roll values being set to one
            // number (once with 1 once with another value)
            
            m_rollsForFirstPlay[m_orderedPlayerList[i]] = roll;
            
            if (roll > maxValue)
            {
                maxValue = roll;
                maxRollIndex = i;
            }
            else if (roll == maxValue && roll != 1)
            {
                // roll off
                PseudoRandom::CoinSide lastPlayer = PseudoRandom::Heads;
                PseudoRandom::CoinSide thisPlayer = PseudoRandom::Heads;
                while (lastPlayer == thisPlayer)
                {
                    thisPlayer = m_randomGenerator->CoinToss();
                    lastPlayer = m_randomGenerator->CoinToss();
                }
                if (lastPlayer > thisPlayer)
                {
                    m_rollsForFirstPlay[m_orderedPlayerList[i]] = roll - 1;
                }
                else
                {
                    m_rollsForFirstPlay[m_orderedPlayerList[maxRollIndex]] = roll - 1;
                    maxRollIndex = i;
                }
            }
        }
    }
    
    // set the current player id from the roll
    m_currentPlayerUID = m_orderedPlayerList[maxRollIndex];
}
